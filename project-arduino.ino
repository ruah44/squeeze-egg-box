// Sketch: Final Project
// Student: Qinyi Chen
// QMUL email: q.chen@se21.qmul.ac.uk
// Student ID: 210672569

// Pins setup:
// set up a flex sensor to track the opening and closing of box
const int flexPin = 0; // Flex sensor to analog 1
// set up 5 FSR sensor as 5 touch keys
const int fsrPin1 = 1; // Key2 to analog 1
const int fsrPin2 = 2; // Key2 to analog 2
const int fsrPin3 = 3; // Key4 to analog 3
const int fsrPin4 = 4; // Key6 to analog 4
const int fsrPin5 = 5; // Key2 to analog 5
// set up a touch sensor as an extra touch key
const int touchPin6 = 6; // Key3 to digital 6


void setup() {
  Serial.begin(9600);
  pinMode(flexPin, INPUT);
  pinMode(fsrPin1, INPUT);
  pinMode(fsrPin2, INPUT);
  pinMode(fsrPin3, INPUT);
  pinMode(fsrPin4, INPUT);
  pinMode(fsrPin5, INPUT);
  pinMode(touchPin6, INPUT);
}

// Constants
const int fsrLimit = 1; // the minimum value of fsr analog inputs that is considered as "touching" state
//const int flexMin = 70; // the approximate minimum flexValue when flex sensor is very folded to make the box closed
//const int bendingLimit = 10; 

// Variables
int flexValue; int flexLevel; int lastflexLevel = 0;
int fsrValue1; int fsrValue2; int fsrValue3; int fsrValue4; int fsrValue5;
int touchState6;

void loop() {
  flexValue = analogRead(flexPin); //Read and save analog value from flex sensor
  fsrValue1 = analogRead(fsrPin1);
  fsrValue2 = analogRead(fsrPin2);
  fsrValue3 = analogRead(fsrPin3);
  fsrValue4 = analogRead(fsrPin4);
  fsrValue5 = analogRead(fsrPin5);
  touchState6 = digitalRead(touchPin6);
  
  // calculate flex sensor  
  if (flexValue < 140){
    flexLevel = map(flexValue, 70, 140, 1, 5); //Map value to 1-9(10 level)
    }
  if (flexValue > 140){
    flexLevel = map(flexValue, 140, 190, 5 , 8); //Map value to 1-9(10 level)
    } 
  if (flexLevel < 1){
    flexLevel = 1;
    }
  if (flexLevel > 8){
    flexLevel = 9;
    }
// if (lastflexLevel != flexLevel){
// //refine flexValue from 70(white-in) 100 100 240(plain) 290(brown-in) 
//  Serial.println("flexValue: " + String(flexValue) + "flexLevel: " + String(flexLevel));                
//  }
    
  if (flexLevel > lastflexLevel){
    Serial.print(String(flexLevel));
    if (touchState6 == LOW){
       if(fsrValue1 > fsrLimit){
        Serial.print("a");
        }
      if(fsrValue2 > fsrLimit){
        Serial.print("c");
        }
      if(fsrValue3 > fsrLimit){
        Serial.print("e");
        }
      if(fsrValue4 > fsrLimit){
        Serial.print("g");
        } 
      if(fsrValue5 > fsrLimit){
        Serial.print("i");
        }  
      }
    if(touchState6 == HIGH){
       if(fsrValue1 > fsrLimit){
        Serial.print("A");
        }
      if(fsrValue2 > fsrLimit){
        Serial.print("C");
        }
      if(fsrValue3 > fsrLimit){
        Serial.print("E");
        }
      if(fsrValue4 > fsrLimit){
        Serial.print("G");
        } 
      if(fsrValue5 > fsrLimit){
        Serial.print("I");
        }  
    }
  Serial.print("\n");
  } 

  
  if (flexLevel < lastflexLevel){
    Serial.print(String(flexLevel));
    if(touchState6 == LOW){
      if(fsrValue1 > fsrLimit){
        Serial.print("b");
        }
      if(fsrValue2 > fsrLimit){
        Serial.print("d");
        }
      if(fsrValue3 > fsrLimit){
        Serial.print("f");
        }
      if(fsrValue4 > fsrLimit){
        Serial.print("h");
        } 
      if(fsrValue5 > fsrLimit){
        Serial.print("j");
        }   
    }
    if(touchState6 == HIGH){
      if(fsrValue1 > fsrLimit){
        Serial.print("B");
        }
      if(fsrValue2 > fsrLimit){
        Serial.print("D");
        }
      if(fsrValue3 > fsrLimit){
        Serial.print("F");
        }
      if(fsrValue4 > fsrLimit){
        Serial.print("H");
        } 
      if(fsrValue5 > fsrLimit){
        Serial.print("J");
        }   
    }
  Serial.print("\n");  //a mark for processing sketch to read with division between loops
  }
  lastflexLevel = flexLevel;  
  delay(100);
}
