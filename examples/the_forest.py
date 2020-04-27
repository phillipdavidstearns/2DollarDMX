#!/usr/bin/python3

#------------------------------------------------------
#
# the_forest.py
#
# A script to translate network traffic into lighting control
# should be run on a raspberry pi.
# Raspberry Pi needs to be connected to a network
# Raspberry Pi GPIO is used to output controlsignals
# via a 4094 shift register
# The output of the shift register can be used to trigger
# devices connected to Solid State Relays.

import os
import sys
import subprocess
import argparse
from signal import *
import socket
import time
import select
import CD4094 as IO

# object for our socket
s = object()
conn = object()

#------------------------------------------------------------------------
#

def bytes_to_bits(data, channels):
	channelStates=[]
	for i in range(len(data)):
		b = data[i]
		for j in range(8):
			channelStates.append(b >> j & 1)
	return channelStates

#------------------------------------------------------------------------
#

def shutdown(s, sig):
	IO.stop()
	try:
		conn.shutdown(socket.SHUT_RDWR)
	except:
		pass
	try:
		conn.close()
	except:
		pass
	try:
		s.shutdown(socket.SHUT_RDWR)
	except:
		pass
	try:
		s.close()
	except:
		pass
	sys.exit(0)

#------------------------------------------------------------------------
#	Signal Interrupt/Terminate Handlers

# catch control+c
def SIGINT_handler(sig, frame):
	shutdown(s, sig)

# catch termination signals from the system
def SIGTERM_handler(sig, frame):
	shutdown(s, sig)

#------------------------------------------------------------------------
# main

def main():

	if os.getuid() != 0:
		print("Must be run as root.")
		sys.exit(1)

	# interrupt and terminate signal handling
	signal(SIGINT, SIGINT_handler)
	signal(SIGTERM, SIGTERM_handler)

	#-------------------------------------------------------------------
	# argument stuff
	ap = argparse.ArgumentParser()
	ap.add_argument("-i", "--interface", default="wlan0", required=False, help="[if]")
	ap.add_argument("-l","--lhost-ip", default="", required=False, help="LHOST IP")
	ap.add_argument("-p","--lhost-port", type=int, default=31337, required=False, help="LHOST PORT")
	ap.add_argument("-c", "--chunk-size", type=float, default=1024, required=False, help="chunk size in frames") # not sure if I need this
	ap.add_argument("-r", "--frame-rate", type=float, default=30, required=False, help="frames per second")
	ap.add_argument("-s", "--frame-size", type=int, default=4, required=False, help="number of bytes to display per frame")
	ap.add_argument("-b", "--frame-buffer", type=int, default=16, required=False, help="number of bytes to display per frame")
	ap.add_argument('-v', "--verbose", action='store_true', default=False, help='Verbose mode. Display debug messages')
	args = ap.parse_args()

	IFACE = args.interface
	CHUNK = args.chunk_size
	RATE = args.frame_rate
	FRAME_SIZE = args.frame_size
	BUFFER_SIZE = args.frame_buffer 
	VERBOSE = args.verbose
	HOST = ''
	PORT = 31337

	#------------------------------------------------------------------------
	#	verbose or debug mode

	def debug(message):
		if VERBOSE:
			print(message)

	if VERBOSE:
		debug("Verbose mode. Displaying debug messeges")

	# initalize TCP socket
	# from example at https://docs.python.org/3.7/library/socket.html#example
	global s
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	try:
		s.bind((HOST, PORT))
	except:
		print("Could not bind socket"+ str(HOST) +":" +str(PORT))
		s.close()
		sys.exit(1)
	s.listen(1)

	packets = []

	channels = 32 # number of output channels

	# Pin assignments
	# outputs
	strobe = 17 # latch strobe GPIO pin
	data = 27 # data GPIO pin
	clock = 22 # clock GPIO pin
	enable = 23 # IOister enable GPIO pin
	# make composite lists to pass along to IO
	pins = [ strobe, data, clock, enable ]
	IO.init(pins, channels)

	global conn

	while True:
		conn, addr = s.accept()
		with conn:
			debug('Connected from' + str(addr))
			while True:
				data = conn.recv(CHUNK)
				if not data: break
				packets += data
				while len(packets) > BUFFER_SIZE:
					block = packets[:FRAME_SIZE]
					start_time = time.time()
					while len(block) < FRAME_SIZE:
						block.append(0)
					packets = packets [FRAME_SIZE:]
					IO.update(bytes_to_bits(block, channels))
					stop_time = time.time()
					time.sleep((1/RATE) - ( stop_time - start_time ))

if __name__ == '__main__':
	main()
