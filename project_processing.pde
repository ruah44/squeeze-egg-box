// Set up communication with pure data, by importing the oscP5 libraries
import oscP5.*;
import netP5.*;
OscP5 gOscController;  // Main controller object that oscP5 uses
int gOscReceivePort = 11001;  // Port to receive messages on
String gOscTransmitHost = "127.0.0.1";  // Host to send messages to the local machine
int gOscTransmitPort = 11000;           // Port to send messages to
NetAddress gRemoteDestination; // Location to send messages to

//Set up communication with arduino, by using serial
import processing.serial.*;
Serial myPort;

// variables:
float f1 = 0.0; float f2 = 0.0; float f3 = 0.0; float f4 = 0.0; float f5 = 0.0;
char key; 
int j1 = 0; int j2 = 0; int j3 = 0; int j4 = 0; int j5 = 0;
int volume = 0;

// constants:
int l = 10; // length of each unit 
PFont f; // font
  
void setup() {
  // Initialise the OSC controller. This sets up a listener on the
  // port given in the second argument.
  gOscController = new OscP5(this, gOscReceivePort);
  
  // This part is only needed if you want to send OSC messages.
  // First argument is the host, second argument is the port.
  gRemoteDestination = new NetAddress(gOscTransmitHost, gOscTransmitPort);  
  
  String portName = Serial.list()[0]; // find the arduino port 
  myPort = new Serial(this, portName, 9600); // match port, use the same rate as in arduino: 9600 bits per second
  
  // use bufferUntil() along with serialEvent() to avoid arduino serial imports from accumulating and causing delay in processing  
  myPort.bufferUntil('\n'); 
  
  // set up a black screen
  size(1000, 800);
  background(0, 0, 0);  
  // set up font to display texts onto the screen
  f = createFont("Arial",16,true); 
}

// use bufferUntil() along with serialEvent() to avoid arduino serial imports from accumulating and causing delay in processing  
void serialEvent(Serial myPort) { 
  if (myPort.available() > 0) {  // If the data from pushbutton is available,
   String val = myPort.readStringUntil('\n'); // read and store the data divided into different loops in arduino
    if (val != null){ // received the data
      volume = int(val.charAt(0) - 48); // read the first character of the data, the flex level set in arduino as an integer from 0 to 9      
        int len = val.length();
        if (len > 1){ // the rest of the data contains letters that suggest frequencies infornation
// reset all frequency information about current state of each key as zeros
          f1 = 0.0; f2 = 0.0; f3 = 0.0; f4 = 0.0; f5 = 0.0;
          j1 = 0; j2 = 0; j3 = 0; j4 = 0; j5 = 0;
// use for loop to assign frequency information according to triggered notes one by one
          for (int i = 1; i < len; i++){ 
            key = val.charAt(i);
            switch(key){
// for key1 assign a frequency f1 and a j1 to according to which note within the 4 possible ones is triggered
              case 'a':
              f1 = 220.00; j1 = -2;// A3: renew frequency of the key, frequencies reference: https://pages.mtu.edu/~suits/notefreqs.html
              break; 
              case 'A':
              f1 = 233.08; j1 = -1;// A3#
              break; 
              case 'b':
              f1 = 246.94; j1 = 1;// B3
              break; 
              case 'B':
              f1 = 261.63; j1 = 2; // B3# C4
// for key2 assign a frequency f2 and a j2 to according to which note within the 4 possible ones is triggered
              case 'c':
              f2 = 261.63; j2 = -2;// C4
              break; 
              case 'C':
              f2 = 277.18; j2 = -1; // C4#
              break;                             
              case 'd':
              f2 = 293.66; j2 = 1; // D4
              break;             
              case 'D':
              f2 = 311.13; j2 = 2;// D4#
              break;    
// for key3 assign a frequency f3 and a j3 to according to which note within the 4 possible ones is triggered              
              case 'e':
              f3 = 329.63; j3 = -2; // E4
              break; 
              case 'E':
              f3 = 349.23; j3 = -1; // E4# F4
              break;                             
              case 'f':
              f3 = 349.23; j3 = 1; // F4
              break;             
              case 'F':
              f3 = 369.99; j3 = 2; // F4#
              break; 
// for key4 assign a frequency f4 and a j4 to according to which note within the 4 possible ones is triggered          
              case 'g':
              f4 = 392.00; j4 = -2;// G4
              break; 
              case 'G':
              f4 = 415.30; j4 = -1; // G4#
              break;                             
              case 'h':
              f4 = 440; j4 = 1; // A4
              break;             
              case 'H':
              f4 = 466.16; j4 = 2; // A4#
              break; 
// for key5 assign a frequency f5 and a j5 to according to which note within the 4 possible ones is triggered              
              case 'i':
              f5 = 493.88; j5 = -2; // B4
              break; 
              case 'I':
              f5 = 523.25; j5 = -1; // B4# C5
              break;                             
              case 'j':
              f5 = 523.25; j5 = 1;  // C5
              break;             
              case 'J':
              f5 = 554.37; j5 = 2;  // C5#
              break;   
            }
          }        
        println(f1,f2,f3,f4,f5,volume); // print in processing console
      } 
    }
  }
}

void draw() {   
background(0, 0, 0);  // draw black background

    // send the frequencies for 5 keys and the volume to pure data patch
    OscMessage newMessage = new OscMessage("/message"); 
    newMessage.add(f1);
    newMessage.add(f2);
    newMessage.add(f3);  
    newMessage.add(f4); 
    newMessage.add(f5); 
    newMessage.add(volume); 
    gOscController.send(newMessage, gRemoteDestination);
   
// display the name and tips of the project
fill(255);
textFont(f, 28);
text("Cruft project: Squeeze-egg-box, made of egg box and inspired by squeezebox",10,35);
textFont(f, 24);
text("Box opening - trigger notes on the left, volume up",10,60);
text("Box closing - trigger notes on the right, volume down.",10,90);
text("Tip : Notes will be triggered or changed only when box is opening or closing",10,120);

// display the fingering, and the corresponding note when a key is triggered
if(f1 != 0){
drawOpenEgg(400,500); // f1, if key1 is triggered
fill(255); 
textFont(f, 48);
if (j1 == -2){
text("A3", 350, 500); // display the corresponding note within 4 possibilities suggested by the number of j1
}
if (j1 == -1){
text("A3#", 350, 500);
}
if (j1 == 1){
text("B3", 550, 500);
}
if (j1 == 2){
text("B3#", 550, 500);
}
} 
else{
drawEgg(400,500); //if key1 is not triggered
fill(255);
textFont(f, 48);
text("A3", 400, 500); // display the fingering
text("B3", 500, 500);
}

if(j2 != 0){
drawOpenEgg(100,200); //if key2 is triggered
fill(255);
textFont(f, 48);
if (j2 == -2){
text("C4", 50, 200);
}
if (j2 == -1){
text("C4#", 50, 200);
}
if (j2 == 1){
text("D4", 250, 200);
}
if (j2 == 2){
text("D4#", 250, 200);
}
} 
else{
drawEgg(100,200); // if key2 is not triggered
fill(255);
textFont(f, 48);
text("C4", 100, 200); // display the fingering
text("D4", 200, 200);
}


if(f3 != 0){
drawOpenEgg(400,200); // if key3 is triggered
fill(255);
textFont(f, 48);
if (j3 == -2){
text("E4", 350, 200);
}
if (j3 == -1){
text("E4#", 350, 200);
}
if (j3 == 1){
text("F4", 550, 200);
}
if (j3 == 2){
text("F4#", 550, 200);
}
} 
else{
drawEgg(400,200); // if key3 is not triggered
fill(255);
textFont(f, 48);
text("E4", 400, 200); // display the fingering
text("F4", 500, 200);
}

if(f4 != 0){
drawOpenEgg(700,200); // if key4 is triggered
fill(255);
textFont(f, 48);
if (j4 == -2){
text("G4", 650, 200);
}
if (j4 == -1){
text("G4#", 650, 200);
}
if (j4 == 1){
text("A4", 850, 200);
}
if (j4 == 2){
text("A4#", 850, 200);
}
} 
else{
drawEgg(700,200); // if key4 is not triggered
fill(255);
textFont(f, 48);
text("G4", 700, 200); // display the fingering
text("A4", 800, 200);
}

if(f5 != 0){
drawOpenEgg(700,500); // if key5 is triggered
fill(255);
textFont(f, 48);
textFont(f, 48);
if (j5 == -2){
text("B4", 650, 500);
}
if (j5 == -1){
text("B4#", 650, 500);
}
if (j5 == 1){
text("C5", 850, 500);
}
if (j5 == 2){
text("C5#", 850, 500);
}
} 
else{
drawEgg(700,500); // if key5 is not triggered
fill(255);
textFont(f, 48);
text("B4", 700, 500); // display the fingering
text("C5", 800, 500);
}

drawEgg(100,500); // display the fingering for sharp #
fill(255);
textFont(f, 48);
text("#", 100, 500);
text("#", 230, 500);
}


// set up display of a key if it is not trigger: an egg
void drawEgg(float x, float y) {
//outline of the egg
fill(242, 181, 90);
stroke(242, 181, 90);
rect(x+6*l,y+l,4*l,l); 
rect(x+5*l,y+2*l,2*l,l); rect(x+9*l,y+2*l,2*l,l);
rect(x+4*l,y+3*l,2*l,l); rect(x+10*l,y+3*l,2*l,l);
rect(x+3*l,y+4*l,2*l,l); rect(x+11*l,y+4*l,2*l,l);
rect(x+2*l,y+5*l,2*l,l); rect(x+12*l,y+5*l,2*l,l);
rect(x+2*l,y+6*l,l,2*l); rect(x+13*l,y+6*l,l,2*l);
rect(x+1*l,y+8*l,l,5*l); rect(x+14*l,y+8*l,l,5*l);
rect(x+2*l,y+12*l,l,3*l); rect(x+13*l,y+12*l,l,3*l);
rect(x+3*l,y+14*l,l,2*l); rect(x+12*l,y+14*l,l,2*l);
rect(x+4*l,y+15*l,l,l); rect(x+11*l,y+15*l,l,l);
rect(x+4*l,y+16*l,8*l,l);
// sawtooth in the middle
fill(244, 187, 41);
stroke(244, 187, 41);
rect(x+2*l,y+8*l,l,l);rect(x+3*l,y+9*l,l,l);
rect(x+4*l,y+8*l,l,l);rect(x+5*l,y+7*l,l,l);
rect(x+6*l,y+8*l,l,l);rect(x+7*l,y+9*l,l,l);
rect(x+8*l,y+10*l,l,l);rect(x+9*l,y+9*l,l,l);
rect(x+10*l,y+8*l,l,l);rect(x+11*l,y+7*l,l,l);
rect(x+12*l,y+8*l,l,l);rect(x+13*l,y+9*l,l,l);
}

// set up display of a key if it is triggered: an egg with a chicken's head out
void drawOpenEgg(float x, float y) {
// outlines of bottom part
fill(242, 181, 90);
stroke(242, 181, 90);
rect(x+1*l,y+8*l,14*l,l);rect(x+1*l,y+9*l,14*l,l);
rect(x+1*l,y+9*l,14*l,l);rect(x+1*l,y+10*l,14*l,l);
rect(x+1*l,y+11*l,14*l,l);rect(x+2*l,y+12*l,12*l,l);
rect(x+2*l,y+13*l,12*l,l);rect(x+2*l,y+14*l,12*l,l);
rect(x+3*l,y+15*l,10*l,l);rect(x+4*l,y+16*l,8*l,l);
// outlines of upper part
y = y - 5*l;
fill(242, 181, 90);
stroke(242, 181, 90);
rect(x+2*l,y+9*l,12*l,l);rect(x+2*l,y+8*l,12*l,l);
rect(x+2*l,y+7*l,12*l,l);rect(x+2*l,y+6*l,12*l,l);
rect(x+2*l,y+5*l,12*l,l);rect(x+3*l,y+4*l,10*l,l);
rect(x+4*l,y+3*l,8*l,l);rect(x+5*l,y+2*l,6*l,l);
rect(x+6*l,y+1*l,4*l,l);
// wings of chicken
fill(240, 224, 5);
stroke(240, 224, 5);
rect(x+1*l,y+10*l,l,3*l); rect(x+14*l,y+10*l,l,3*l);
rect(x+2*l,y+9*l,l,5*l); rect(x+13*l,y+9*l,l,6*l);
rect(x+1*l,y+9*l,l,2*l); rect(x+14*l,y+9*l,l,2*l);
rect(x+0*l,y+8*l,l,2*l); rect(x+15*l,y+8*l,l,2*l);
rect(x-1*l,y+7*l,l,2*l); rect(x+16*l,y+7*l,l,2*l);
rect(x-2*l,y+6*l,l,2*l); rect(x+17*l,y+6*l,l,2*l);
rect(x-3*l,y+6*l,l,l); rect(x+18*l,y+6*l,l,l);
rect(x-4*l,y+7*l,l,3*l); rect(x+19*l,y+7*l,l,3*l);
rect(x-3*l,y+7*l,l,3*l); rect(x+18*l,y+7*l,l,3*l);
rect(x-2*l,y+8*l,l,3*l); rect(x+17*l,y+8*l,l,3*l);
rect(x-1*l,y+8*l,l,2*l); rect(x+16*l,y+8*l,l,2*l);
rect(x-3*l,y+10*l,4*l,l); rect(x+15*l,y+10*l,4*l,l);
rect(x-1*l,y+11*l,2*l,l); rect(x+15*l,y+11*l,2*l,l);
// body of chicken
rect(x+3*l,y+9*l,l,6*l);
rect(x+4*l,y+8*l,l,6*l);rect(x+5*l,y+7*l,l,6*l);
rect(x+6*l,y+8*l,l,6*l);rect(x+7*l,y+9*l,l,6*l);
rect(x+8*l,y+10*l,l,6*l);rect(x+9*l,y+9*l,l,6*l);
rect(x+10*l,y+8*l,l,6*l);rect(x+11*l,y+7*l,l,6*l);
rect(x+12*l,y+8*l,l,6*l);
// eye of chicken
fill(0);
stroke(0);
rect(x+4*l,y+10*l,2*l,l);rect(x+10*l,y+10*l,2*l,l);
// beak of chicken
fill(122, 30, 23);
stroke(122, 30, 23);
rect(x+7*l,y+12*l,2*l,l);rect(x+7.5*l,y+11*l,l,l);
}
