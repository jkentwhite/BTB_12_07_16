// players must navigate the lasers while the lasers change
// configurations depending on where the players are in 
// the space.

//booleans to determine the location of players in the grid
boolean emptySpace = true;
boolean rowOne = false;
boolean rowTwo = false;
boolean rowThree = false;
boolean rowFour = false;

//only for debug readout to see what lasers are ON or OFF
String readLaser1;
String readLaser2;
String readLaser3;
String readLaser4;
String readLaser5;
String readLaser6;
String readLaser7;
String readLaser8;
String readLaser9;
String readLaser10;
String readLaser11;
String readLaser12;

//to determine if rfid tasks have been completed
boolean rfidOneTriggered = false;
boolean rfidTwoTriggered = false;

//variable to guide which part of the activeReceptors array to access
int gateState = 0;

//a timer to turn on all gates when a player hits a laser
int gateTimer = 0;

//to determine if a laser has been hit
boolean hitLaser = false;

//an array of gateState(s) to determine which analog pins will be read to see if a laser is being tripped
int [] [] activeReceptors = {

  {0,1,2,3},                    //0
  {0,1,3,4,5},                  //1
  {0,1,3,4,5},                  //2
  {0,1,2,3,4,6,7,8},            //3
  {0,1,3,4,5,6,7,8},            //4
  {0,1,2,3,4,5,7,8,9,10,11},    //5
  {0,1,2,3,4,5,7,8,9,10,11},    //6
  {0,1,2,3,4,5,6,7,8,9,10,11},  //7
  {0,1,3,4,5,6,7,8,9,10,11},    //8
  {0,1,3,4,5,6,7,8,9,10,11},    //9
  {0,1,2,3,4,5,6,7,8,9,11},     //10
  {0,1,2,3,4,5,7,8,9,10,11},    //11
  {0,1,2,3,4,7,8,9,10,11},      //12
  {0,1,3,4,7,8,9,11},           //13
  {0,1,2,3,4,5,6,7,8,9,10,11}   //14
};

void laserPuzzle(){


background(0);

if(keyPressed){
  if(key == '1'){
    rfidOneTriggered = true;
  }
  if(key == '2'){
    rfidTwoTriggered = true;
  }
  if(key == '9'){
    laserPuzzle = false;
    laserDeactivatedScreen = true;
  }
}
        
// if neither rfid tag has been triggered look for players in the space
// and determine which row they are in currrently 
if(!rfidOneTriggered && !rfidTwoTriggered){
        //load images from camera
        img.loadPixels();
        imgVideo = kinect.getVideoImage();
  
        //clear blobs arraylist
        blobs.clear();
  
        //get depth info from kinect
        int[] depth = kinect.getRawDepth();
  
        for(int x = 30; x < kinect.width-30; x++){
          for(int y = 0; y < kinect.height; y++) {
            int offset = x + y * img.width;
            int d = depth[offset];
        
          //set the depth for the sensor to pick up players
          if(d > 940 && d < 975){
            //see if the pixels in the range of the sensor are already part of a blob
            boolean found = false;
            for (Blob b : blobs) {
              //if the pixel is close enough it will become part of a previously defined blob
              if (b.isNear(x, y)) {
                b.add(x, y);
                found = true;
                break;
              }
            }
            //if there are no blobs or the pixel is far enough away, start a new blob
            if (!found) {
              Blob b = new Blob(x, y);
              blobs.add(b);
            }
          }
         }
       }
    
      //update the image from camera
      img.updatePixels();
      imageMode(CENTER);
      image(imgVideo,width/2,height/2, displayWidth, displayHeight);
      tint(255,128);
      image(img,width/2,height/2, displayWidth, displayHeight);
  
    
      //draw the blobs if they are bigger than 500
      for (Blob b : blobs) {
        if (b.size() > 500) {
          b.show();
        } 
      }
      
      
      //check to see if there are blobs present and if so, where are they in relation to the Y axis
      for (Blob b : blobs) {

          if(b == null || b.centerOfBlobY < 10 || b.centerOfBlobY > 758){
            emptySpace = true;
            } else {
              emptySpace = false;
            }
          if(b.centerOfBlobY > 10 && b.centerOfBlobY < 185){
            rowOne = true;
          } else {
            rowOne = false;
          }
          if(b.centerOfBlobY > 195 && b.centerOfBlobY < 380){
            rowTwo = true;
          } else {
            rowTwo = false;
          }
          if(b.centerOfBlobY > 390 && b.centerOfBlobY < 570){
            rowThree = true;
          } else {
            rowThree = false;
          }
          if(b.centerOfBlobY > 580 && b.centerOfBlobY < 758){
            rowFour = true;
          } else {
            rowFour = false;
          }
        }


  
// if no players in the space:
 if(emptySpace && !rowOne && !rowTwo && !rowThree && !rowFour && !hitLaser){ 
   
   //set the gateState to determine which receptors to read through the activeReceptors array
   gateState = 0;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);    
    readLaser4 = "ON";
// laser5: OFF
    arduino.digitalWrite(laser5, Arduino.LOW);
    readLaser5 = "OFF";
// laser6: OFF
    arduino.digitalWrite(laser6, Arduino.LOW);
    readLaser6 = "OFF";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: OFF
    arduino.digitalWrite(laser8, Arduino.LOW);
    readLaser8 = "OFF";
// laser9: OFF
    arduino.digitalWrite(laser9, Arduino.LOW);
    readLaser9 = "OFF";
// laser10: OFF
    arduino.digitalWrite(laser10, Arduino.LOW);
    readLaser10 = "OFF";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: OFF
    arduino.digitalWrite(laser12, Arduino.LOW);
    readLaser12 = "OFF";
 }

//with one player in the first row:
if(!emptySpace && rowOne && !rowTwo && !rowThree && !rowFour && !hitLaser){
  
  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 1;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: OFF
    arduino.digitalWrite(laser8, Arduino.LOW);
    readLaser8 = "OFF";
// laser9: OFF
    arduino.digitalWrite(laser9, Arduino.LOW);
    readLaser9 = "OFF";
// laser10: OFF
    arduino.digitalWrite(laser10, Arduino.LOW);
    readLaser10 = "OFF";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: OFF
    arduino.digitalWrite(laser12, Arduino.LOW);
    readLaser12 = "OFF";
}

//with one player in the second row:
if(!emptySpace && !rowOne && rowTwo && !rowThree && !rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array  
  gateState = 2;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: OFF
    arduino.digitalWrite(laser8, Arduino.LOW);
    readLaser8 = "OFF";
// laser9: OFF
    arduino.digitalWrite(laser9, Arduino.LOW);
    readLaser9 = "OFF";
// laser10: OFF
    arduino.digitalWrite(laser10, Arduino.LOW);
    readLaser10 = "OFF";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: OFF
    arduino.digitalWrite(laser12, Arduino.LOW);
    readLaser12 = "OFF";
}


//with one player in the second row
//and one player in first row:
if(!emptySpace && rowOne && rowTwo && !rowThree && !rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 3;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: OFF
    arduino.digitalWrite(laser6, Arduino.LOW);
    readLaser6 = "OFF";
// laser7: ON
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: OFF
    arduino.digitalWrite(laser10, Arduino.LOW);
    readLaser10 = "OFF";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: OFF
    arduino.digitalWrite(laser12, Arduino.LOW);
    readLaser12 = "OFF";
}


//with one player in the third row 
//and one player in first row:
if(!emptySpace && rowOne && !rowTwo && rowThree && !rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 4;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: ON
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: OFF
    arduino.digitalWrite(laser10, Arduino.LOW);
    readLaser10 = "OFF";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: OFF
    arduino.digitalWrite(laser12, Arduino.LOW);
    readLaser12 = "OFF";
}


//with one player in the second row 
//and one player in third row:
if(!emptySpace && !rowOne && rowTwo && rowThree && !rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 5;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: ON
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player in fourth row
//and one player in second row:
if(!emptySpace && !rowOne && rowTwo && !rowThree && rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 6;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: OFF
    arduino.digitalWrite(laser6, Arduino.LOW);
    readLaser6 = "OFF";
// laser7: ON
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: ON
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player in fourth row
//and one player in third row
if(!emptySpace && !rowOne && !rowTwo && rowThree && rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 7;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: ON
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player in fourth row
//and one player in third row
//and one player in first row
if(!emptySpace && rowOne && !rowTwo && rowThree && rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 8;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: ON
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player in fourth row
//and one player in third row
//and one player in second row
if(!emptySpace && !rowOne && rowTwo && rowThree && rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 9;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: ON
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player in fourth row
//and one player in third row
//and one player in second row
//and one player in first row
if(!emptySpace && rowOne && rowTwo && rowThree && rowFour && !hitLaser){

  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 10;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: ON
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player exited
//and one player in third row
//and one player in second row
//and one player in first row
if(!emptySpace && rowOne && rowTwo && rowThree && !rowFour && !hitLaser){
 
  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 11;

// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


//with one player exited
//and one player in fourth row
//and one player in second row
//and one player in first row
if(!emptySpace && rowOne && rowTwo && !rowThree && rowFour && !hitLaser){
  
  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 12;


// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: OFF
    arduino.digitalWrite(laser6, Arduino.LOW);
    readLaser6 = "OFF";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: ON
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}
}


//when first RFID has been triggered
 else if(rfidOneTriggered && !rfidTwoTriggered && !hitLaser){
   
   //set the gateState to determine which receptors to read through the activeReceptors array
   gateState = 13;

  
//when first RFID has been triggered
// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: OFF
    arduino.digitalWrite(laser6, Arduino.LOW);
    readLaser6 = "OFF";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";



//when second RFID has been triggered
} else if(rfidOneTriggered && rfidTwoTriggered){
  
  //set the gateState to determine which receptors to read through the activeReceptors array
  gateState = 15;

  
// laser1: OFF
    arduino.digitalWrite(laser1, Arduino.LOW);
    readLaser1 = "OFF";
// laser2: OFF
    arduino.digitalWrite(laser2, Arduino.LOW);
    readLaser2 = "OFF";
// laser3: OFF
    arduino.digitalWrite(laser3, Arduino.LOW);
    readLaser3 = "OFF";
// laser4: OFF
    arduino.digitalWrite(laser4, Arduino.LOW);
    readLaser4 = "OFF";
// laser5: OFF
    arduino.digitalWrite(laser5, Arduino.LOW);
    readLaser5 = "OFF";
// laser6: OFF
    arduino.digitalWrite(laser6, Arduino.LOW);
    readLaser6 = "OFF";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.LOW);
    readLaser7 = "OFF";
// laser8: OFF
    arduino.digitalWrite(laser8, Arduino.LOW);
    readLaser8 = "OFF";
// laser9: OFF
    arduino.digitalWrite(laser9, Arduino.LOW);
    readLaser9 = "OFF";
// laser10: OFF
    arduino.digitalWrite(laser10, Arduino.LOW);
    readLaser10 = "OFF";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.LOW);
    readLaser11 = "OFF";
// laser12: OFF
    arduino.digitalWrite(laser12, Arduino.LOW);
    readLaser12 = "OFF";
}

//if player hits a laser:
//gateState = 14;
if(gateState == 14){
// all lasers on for 3 seconds
// laser1: ON
    arduino.digitalWrite(laser1, Arduino.HIGH);
    readLaser1 = "ON";
// laser2: ON
    arduino.digitalWrite(laser2, Arduino.HIGH);
    readLaser2 = "ON";
// laser3: ON
    arduino.digitalWrite(laser3, Arduino.HIGH);
    readLaser3 = "ON";
// laser4: ON
    arduino.digitalWrite(laser4, Arduino.HIGH);
    readLaser4 = "ON";
// laser5: ON
    arduino.digitalWrite(laser5, Arduino.HIGH);
    readLaser5 = "ON";
// laser6: ON
    arduino.digitalWrite(laser6, Arduino.HIGH);
    readLaser6 = "ON";
// laser7: OFF
    arduino.digitalWrite(laser7, Arduino.HIGH);
    readLaser7 = "ON";
// laser8: ON
    arduino.digitalWrite(laser8, Arduino.HIGH);
    readLaser8 = "ON";
// laser9: ON
    arduino.digitalWrite(laser9, Arduino.HIGH);
    readLaser9 = "ON";
// laser10: ON
    arduino.digitalWrite(laser10, Arduino.HIGH);
    readLaser10 = "ON";
// laser11: OFF
    arduino.digitalWrite(laser11, Arduino.HIGH);
    readLaser11 = "ON";
// laser12: ON
    arduino.digitalWrite(laser12, Arduino.HIGH);
    readLaser12 = "ON";
}


    if(gateState != 15){
    for(int i = 0; i < activeReceptors[gateState].length; i++){
      laserStatus = arduino.analogRead(activeReceptors[gateState][i]);
    
      //if the laserStatus(i.e. amount of light hitting the receptor from the laser) is less lightReceptorThreshold then make that receptor boolean true
      //meaning it has been interrupted
      if (laserStatus < lightReceptorThreshold){
        
        //set the boolean true for the current laser being tripped
        lasers[(activeReceptors[gateState][i])] = true;
        
        //store the current laser for comparison to eliminate multiple triggers for the same laser being tripped at once
        currentLaser = (activeReceptors[gateState][i]);
        
        //console print out which laser is being tripped
        println("laser " + i + "being trippped");
        
      } else {
        //if the receptor/laser is not being triggered set the boolean for that laser to FALSE
        lasers[(activeReceptors[gateState][i])] = false;
      }
      
      //check the array of booleans for all lasers/receptor and if it is TRUE and has not been counted yet, then add one to the hitLaserCounter and the oneHitCounter 
      if(lasers[currentLaser] && oneHitCounter < 1){
         hitLaserCounter++;
         oneHitCounter++;
         buzzer2.trigger();
         hitLaser = true;
         
      }
      
      //if the current laser is not being triggered anymore, i.e. FALSE, and the oneHitCounter has been counted then reset the oneHitCounter
      if(!lasers[currentLaser] && oneHitCounter > 0){
        oneHitCounter = 0;
      }
      
      if(hitLaser){
        gateState = 14;
        gateTimer++;
        if(gateTimer >= 30){
          hitLaser = false;
          gateTimer = 0;
        }
      }
    }
   }

println("row 1: " + rowOne);
println("row 2: " + rowTwo);
println("row 3: " + rowThree);
println("row 4: " + rowFour);

textSize(32);
fill(0,255,0);
text("laser 1: " + readLaser1, width/2, height/13);
text("laser 2: " + readLaser2, width/2, height/13*2);
text("laser 3: " + readLaser3, width/2, height/13*3);
text("laser 4: " + readLaser4, width/2, height/13*4);
text("laser 5: " + readLaser5, width/2, height/13*5);
text("laser 6: " + readLaser6, width/2, height/13*6);
text("laser 7: " + readLaser7, width/2, height/13*7);
text("laser 8: " + readLaser8, width/2, height/13*8);
text("laser 9: " + readLaser9, width/2, height/13*9);
text("laser 10: " + readLaser10, width/2, height/13*10);
text("laser 11: " + readLaser11, width/2, height/13*11);
text("laser 12: " + readLaser12, width/2, height/13*12);

//text("rfidOneTriggered: " + rfidOneTriggered, width/3, height/3);
//text("rfidTwoTriggered: " + rfidTwoTriggered, width/3, height/3*2);



}