/*
   32 Light control system code for Arduino Nano

   Reads a 4 byte (32bit) "command" from the serial port and outputs it to a
   32 bit serial to parallel array made from daisy chained CD4094 CMOS shift registers

   Note that modifying this code for other Arduino platforms will require changin
   pin numbers and IO/PORT. Here pins 10, 11, 12, are Strobe, Data, and Clock rsp.
   IO is controlled via PORTB on Nano and Uno/Deumillanova boards.

*/

//Timer1 used maintain a steady refresh rate of the lamps.
#include <TimerOne.h>

//display register control pins
#define ENABLE 9
#define STROBE 10
#define DATA 11
#define CLK 12

byte lights[4];
volatile unsigned long int count;

//////////////////////////////////////////////////////////////////////////////

void setup() {
  PORTB = B00000000; // disable shiftregister output
  Timer1.initialize(1e6 / 30); // period in micro seconds (1x10^6 / frames per second)
  Timer1.attachInterrupt(callback);

  //note: use setPeriod(period) to adjust the frequency of stuff

  pinMode(CLK, OUTPUT);
  pinMode(DATA, OUTPUT);
  pinMode(STROBE, OUTPUT);
  pinMode(ENABLE, OUTPUT);
  Serial.begin(115200);
  PORTB = B00000010; // enable shiftregister output
}

//////////////////////////////////////////////////////////////////////////////

void loop() {
  serial();
}

void callback() {
  updateRegisters();
}

void serial() {
  if (Serial.available() >= 5) { // start reading when the buffer has enough data
    if (Serial.read() == 0xA0) { // 0xA0 is an arbitrary sync bit being transmitted by the processing patch before every transmission 
      for (int i = 0 ; i < 4; i++) {
        lights[i] = Serial.read();
      }
    }
  }
}

void updateRegisters() {

  // B00000000
  //     ^^^^
  //     ||||
  // pin12||| connected to the clock pin of the 4094 array
  //  pin11|| connected to the data pin of the 4094 array
  //   pin10| connected to the strobe pin of the 4094 array
  //    pin09 connected to the enable pin of the 4094 array  
 
  //load data into 4094 shift registers MSB to LSB (BACKWARDS ;)
  for (int i = 3 ; i >= 0 ; i--) { //run through the bytes
   for(int j = 7 ; j >= 0 ; j--){ //run through each bit
    PORTB = ((lights[i] >> j) & 1) << 3; //change the state of the data pin
    PORTB |= B00010010; //pulse clock pin
    PORTB = B00000010; // return clock to 0
   }
  }
  //pulse strobe to update 4094 shift registers
  PORTB = B00000110;
  PORTB = B00000010;
}
