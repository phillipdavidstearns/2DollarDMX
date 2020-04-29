/*
 
 2DollarDMX example GUI Control Interface
 
 by Phillip David Stearns 2018
 
 Communicates to a Arduino via serial, Raspberry Pi via TCP/IP
 Arduino Code:
 Raspberry Pi Code:
 
 
 
 */

import processing.serial.*;
import processing.net.*;

//serial communication
Serial arduinoPort;
// networking stuff
Client c;

String IP_ADDR = "10.79.103.125";
int PORT = 31337;

boolean editMode;
boolean demoMode;
boolean manual;
int connMode=1; // connection method 0 = serial, 1 = TCP/IP

//variables associated with Light
ArrayList <Light> lights;
int lightCount;
int lightsMax = 32;
boolean allOn;
boolean random;
boolean caOn;
boolean inverted;
boolean lfsrOn;
int serialPort = 1; // *** set this to the device you want to send serial data to! ***

//variables associated with Group
ArrayList <Group> groups;
int groupCount;
int groupsMax = 6;
boolean[] group; //holds logic for toggling groups on and off
String[] groupNames = {"KEYS", "DRUMS", "VOCALS", "GUITAR", "BASS"};

ArrayList <Ring> rings;
ArrayList <Line> lines;

CA ca;
LFSR lfsr;

color bgcolor;

//variables for calculating and drawing the grid
float stageWidth =24; // in feet
float stageDepth=12; // in feet
float wallHeight=6; // in feet
float gridWidth; // in pixels
float gridHeight; // in pixels
float gridSize; // in pixels
float padding = 25; // in pixels
int heavy = 4;
int medium = 2;
int light = 1;
float gridXstart;
float gridXend;
float gridYstart;
float gridYend;
float textX;
float columnLabelY;
float rowLabelX;

/////////////////////////////////SETUP///////////////////////////////

void setup() {
  //size(800, 600);
  fullScreen();
  frameRate(30);

  println("[+] Initializing network client...");

  establishConnection();

  computeGrid();
  drawGrid();

  editMode=false; //0 = edit, 1 = perform
  demoMode=false;
  manual=false;

  lights = new ArrayList<Light>();
  lightCount=0;
  allOn = false;
  inverted = false;
  random = false;
  caOn = false;
  lfsrOn = false;

  groups = new ArrayList<Group>();
  groupCount=0;
  group = new boolean[groupsMax];

  rings = new ArrayList<Ring>();
  lines = new ArrayList<Line>();

  ca = new CA();
  lfsr = new LFSR();

  loadSettings();
}

/////////////////////////////////MAIN LOOP///////////////////////////////

void draw() {

  if (editMode) {
    bgcolor = 63;
  } else if (inverted) {
    bgcolor = 127;
  } else {
    bgcolor = 0;
  }

  background(bgcolor);

  drawGrid();

  if (!editMode) {
    updateRings();
    updateLines();
    if (caOn) ca.update();
    if (lfsrOn) lfsr.update();
  }
  //updateGroups();
  updateLights();
  sendData(packLights());
}

/////////////////////////////////FUNCTIONS///////////////////////////////

void establishConnection() {
  switch(connMode) {
  case 0:
    printArray(Serial.list()); // List all the available serial ports:
    try {
      arduinoPort = new Serial(this, Serial.list()[serialPort], 115200); // Open the port you are using at the rate you want
    } 
    catch(Exception e) {
      println(e);
      exit();
    }
    break;
  case 1:
    try {
      c = new Client(this, IP_ADDR, PORT); // Replace with your server’s IP and port
    } 
    catch( Exception e) {
      println(e);
    }
    if (!c.active()) {
      println("Failed to connect to remote server. Check IP and whether the service is listening.");
      exit();
    }
    break;
  default:
    break;
  }
}

void computeGrid() {
  if (width/stageWidth < height/(stageDepth+wallHeight)) {
    gridSize = (width-(2*padding))/stageWidth;
  } else {
    gridSize = (height-(2*padding))/(stageDepth+wallHeight);
  }
  gridWidth = gridSize*stageWidth;
  gridHeight = gridSize*(stageDepth+wallHeight);
  gridXstart = (width - gridWidth)/2;
  gridYstart = (height - gridHeight)/2;
  columnLabelY=height-gridYstart+(gridSize/4);
  rowLabelX=gridXstart-(gridSize/4);
  gridYend = height-gridYstart;
  gridXend = width-gridXstart;
}

void drawGrid() {

  //Grid colors
  if (editMode) {
    fill(255);  
    stroke(255);
  } else if (inverted) {
    fill(63);
    stroke(63);
  } else {
    fill(127);
    stroke(127);
  }

  textAlign(CENTER, CENTER);

  //draw vertical lines
  for (int x = 0; x <= stageWidth; x++) {
    //set line weight
    if (x==0 || x == stageWidth) {
      strokeWeight(heavy);
    } else if (x % 2 == 0) {
      strokeWeight(medium);
    } else {
      strokeWeight(light);
    }
    //label grid
    float columnLabelX=gridXstart+(gridSize*x)+(gridSize/2);
    if (x < stageWidth) text(x+1, columnLabelX, columnLabelY);
    float boxX = gridXstart+(gridSize*x);
    line(boxX, gridYstart, boxX, gridYend);
    strokeWeight(0);
    line(boxX, 0, boxX, height);
  }

  //draw horizontal lines
  for (int y = 0; y <= wallHeight+stageDepth; y++) {
    //set line weight
    if (y==wallHeight || y==0 || y == wallHeight+stageDepth) {
      strokeWeight(heavy);
    } else if (y % 2 == 0) {
      strokeWeight(medium);
    } else {  
      strokeWeight(light);
    }
    //label grid
    float rowLabelY = gridYstart+(gridSize*y)+(gridSize/2);
    if (y < stageDepth+wallHeight) text(y+1, rowLabelX, rowLabelY);
    float boxY = gridYstart+(gridSize*y);
    line(gridXstart, boxY, gridXend, boxY);
    strokeWeight(0);
    line(0, boxY, width, boxY);
  }
}

void updateRings() {
  for (int i = rings.size() - 1; i >= 0; i--) {
    Ring ring = rings.get(i);
    if (ring.isDone()) {
      rings.remove(i);
    } else {
      ring.update();
    }
  }
}

void updateLines() {
  for (int i = lines.size() - 1; i >= 0; i--) {
    Line line = lines.get(i);
    if (line.isDone()) {
      lines.remove(i);
    } else {
      line.update();
    }
  }
}

void updateLights() {
  for (Light light : lights) {
    light.update();
  }
}

void updateGroups() {
  for (Group group : groups) {
    group.update();
  }
}

long packLights() {
  long packed=0;
  for (int i = lights.size()-1; i >=0; i--) {
    Light light = lights.get(i);
    packed |= int(light.isOn()) << i;
  }
  return packed;
}

void sendData(long _output) {
  byte data = 0;
  byte payload[] = new byte[4];
  for (int i = 0; i < 4; i++) {
    data = byte((_output >> (i*8)) & 0xFF);
    payload[i]=data;
  }
  switch(connMode) {
  case 0:
    arduinoPort.write(0xA0); // send sync byte, Arduino is looking for 0xA0
    arduinoPort.write(payload);
    break;
  case 1:
    try {
      c.write(payload);
    } 
    catch(Exception e) {
      exit();
    }
    break;
  }
}
