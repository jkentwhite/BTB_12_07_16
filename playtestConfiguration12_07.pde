/* NOTES FOR RUNNING THE SKETCH:
Upon starting the sketch, a blank screen will be displayed and when everything is running, 'ready' will appear in the console log.
PRESS SPACEBAR to move to the laser gate puzzle.

Once the laser gates are up and running, 
PRESS 1 to register that the first task has been completed simulating RFID #1 complete. 
PRESS 2 to turn the lasers off simulating RFID #2 complete.
PRESS 9 to move to floor grid.

Floor grid is fairly automated and will move from one level to the next through four levels and then end with an intro screen to gas attack then turn to black.
At anytime during floorgrid on any level, 
PRESS Q to move to the next level.
*/


//import libraries for serial reading/writing and arduino
import processing.serial.*;
import cc.arduino.*;

//import libraries for kinect and sound
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;
import ddf.minim.*;
import processing.sound.*;


//create variables for arduino, kinect and audio(minim)
Arduino arduino;
Kinect kinect;
Minim minim;

//create variables for sound effects
AudioSample chime, buzzer, patternSuccess, patternFail, buzzer2;

//create variables for music
SoundFile laserActivate, laserMusic, floorGridMusic;

//create variables for game states
boolean blackScreenIntro;
boolean floorGridPracticeScreen;
boolean laserScreen;
boolean laserPuzzle;
boolean laserDeactivatedScreen;
boolean floorGridInstScreen;
boolean floorGridStartScreen;
boolean floorGridLevelOne;
boolean levelOnePlayed = false;
boolean floorGridLevelTwo;
boolean levelTwoPlayed = false;
boolean floorGridLevelThree;
boolean levelThreePlayed = false;
boolean floorGridLevelFour;
boolean levelFourPlayed = false;
boolean floorGridSuccessLvlOneScreen;
boolean floorGridSuccessLvlTwoScreen;
boolean floorGridSuccessLvlThreeScreen;
boolean floorGridSuccessLvlFourScreen; 
boolean floorGridComplete;
boolean gasAttackScreen;
boolean allChallengesCompleteScreen;

//create variables for kinect depth threshold
int minTreshold = 940;
int maxThreshold =    950;

// variable for laser configuration
int laser1 = 0;
int laser2 = 1;
int laser3 = 2;
int laser4 = 3;
int laser5 = 4;
int laser6 = 5;
int laser7 = 6;
int laser8 = 7;
int laser9 = 8;
int laser10 = 9;
int laser11 = 10;
int laser12 = 11;

// laserConfigOne is hooked up to PIN 3 on the arduino board
//int laserConfigOne = 3; 

// irSensor is hooked up to PIN 2 on the arduino board
//int irSensor = 2;

//create variables for timers
int countdownFive = 50;
int levelCountdownLevelFour = 70;
int levelCountdownLevelThree = 70;
int levelCountdownLevelTwo = 70;
int levelCountdownLevelOne = 70;

//counter for the patterns on floorgrid
int patternCounter = 0;

//create variable for tracking the pattern number for each level on floorgrid
int patternNumber = 0;

//create variable for counting the number of patterns correct in floorgrid
int numberCorrect= 0;

//create variable for determining the number of correct patterns to move to the next level in floorgrid
int targetPatternNumber = 5;

//create boolean variables for if the player is in the correct rectangle on the pattern
boolean rectOneGood, rectTwoGood, rectThreeGood, rectFourGood;

//create variable for the distance threshold between blobs to be recognized
float distThreshold = 50;

//create array for storing blobs that have been created based on depth info from kinect
ArrayList<Blob> blobs = new ArrayList<Blob>();

//create variables for image display
PImage imgVideo, img;

//create variables for the size of the grid rectangles for floorgrid
int gridX = 256;
int gridY = 192;

//create gridsection array for 640x480 res based on gridX = 160, gridY = 120
int [] [] gridSectionsSmall = {
    {0,0},
    {160, 0},
    {320, 0},
    {480, 0},
    {0,120},
    {160, 120},
    {320, 120},
    {480, 120},
    {0,240},
    {160, 240},
    {320, 240},
    {480, 240},
    {0,360},
    {160, 360},
    {320, 360},
    {480, 360}   
  };
 
 //create gridsection array for 1280x800 res based on gridX = 320, gridY = 200
 int [] [] gridSectionsLarge = {
    {0,0},
    {320, 0},
    {640, 0},
    {960, 0},
    {0,200},
    {320, 200},
    {640, 200},
    {960, 200},
    {0,400},
    {320, 400},
    {640, 400},
    {960, 400},
    {0,600},
    {320, 600},
    {640, 600},
    {960, 600}   
  };
  
 //create gridsection array for 1024x768 res based on gridX = 256, gridY = 192
  int [] [] gridSections = {
    {0,0},
    {256, 0},
    {512, 0},
    {768, 0},
    {0,192},
    {256, 192},
    {512, 192},
    {768, 192},
    {0,384},
    {256, 384},
    {512, 384},
    {768, 384},
    {0,576},
    {256, 576},
    {512, 576},
    {768, 576}   
  };
  
  
//create arrays for patterns on floorgrid  where each number in the array is a rectangle in the 4x4 grid starting with 0 and ending with 15
int [] [] patternRects = {

  {0,3,12,15},
  {1,2,13,14},
  {5,6,9,10},
  {12,13,14,15},
  {5,7,8,10},
  {3,4,11,12},
  {0,7,8,15},
  {4,6,9,11},
  {0,1,2,3},
  {4,7,8,11},
  {3,6,9,12},
  {0,1,10,11},
  {2,5,10,12},
  {7,8,13,15},
  {0,1,4,5},
  {3,7,9,14},
  {1,6,11,12},
  {3,4,8,15},
  {2,10,12,13},
  {1,4,7,14},
  {2,3,8,9},
  {1,6,14,15},
  {4,5,7,13},
  {0,8,10,11},
  {4,5,6,7},
  {1,3,13,15},
  {0,4,8,12},
  {1,7,10,13},
  {6,10,11,12},
  {2,4,8,14},
  {1,7,9,12},
  {2,8,11,13},
  {0,1,6,8},
  {2,4,9,13},
  {0,3,9,15},
  {0,1,6,8},
  {2,4,9,13},
  {0,7,11,14},
  {3,5,6,8},
  {1,9,12,15},
  {0,3,4,10},
  {5,7,8,13},
  {0,6,10,15},
  {4,9,12,14},
  {0,2,5,11},
  {1,3,13,14},
  {4,9,11,15},
  {0,1,8,10},
  {3,11,12,14},
  {4,9,10,15}
  
};

//alternate aray of patterns for floorgrid where each number in the array is a rectangle in the 4x4 grid starting with 0 and ending with 15
int [] [] patternRectsB = {

  {4,5,6,7},
  {1,3,13,15},
  {0,4,8,12},
  {1,7,10,13},
  {6,10,11,12},
  {2,4,8,14},
  {1,7,9,12},
  {2,8,11,13},
  {0,1,6,8},
  {2,4,9,13},
  {0,3,9,15},
  {0,1,6,8},
  {2,4,9,13},
  {0,7,11,14},
  {3,5,6,8},
  {1,9,12,15},
  {0,3,4,10},
  {5,7,8,13},
  {0,6,10,15},
  {4,9,12,14},
  {0,2,5,11},
  {1,3,13,14},
  {4,9,11,15},
  {0,1,8,10},
  {3,11,12,14},
  {4,9,10,15},
  {0,3,12,15},
  {1,2,13,14},
  {5,6,9,10},
  {12,13,14,15},
  {5,7,8,10},
  {3,4,11,12},
  {0,7,8,15},
  {4,6,9,11},
  {0,1,2,3},
  {4,7,8,11},
  {3,6,9,12},
  {0,1,10,11},
  {2,5,10,12},
  {7,8,13,15},
  {0,1,4,5},
  {3,7,9,14},
  {1,6,11,12},
  {3,4,8,15},
  {2,10,12,13},
  {1,4,7,14},
  {2,3,8,9},
  {1,6,14,15},
  {4,5,7,13},
  {0,8,10,11}
  
};

void setup()
{
  //size(1024, 768);
  fullScreen();
  //size(displayWidth, displayHeight);
  background(0);
  
  //set booleans for starting the experience making the intro TRUE and all other states FALSE
  blackScreenIntro = true;
  laserPuzzle = false;
  laserScreen = false;
  laserDeactivatedScreen = false;
  floorGridInstScreen = false;
  floorGridPracticeScreen = false;
  floorGridStartScreen = false;
  floorGridLevelOne = false;
  floorGridLevelTwo = false;
  floorGridLevelThree = false;
  floorGridLevelFour = false;
  floorGridSuccessLvlOneScreen = false;
  floorGridSuccessLvlTwoScreen = false;
  floorGridSuccessLvlThreeScreen = false;
  floorGridSuccessLvlFourScreen = false;
  floorGridComplete = false;
  gasAttackScreen = false;
  allChallengesCompleteScreen = false;
  
  //initialize arduino and configure port
  arduino = new Arduino(this, Arduino.list()[4], 57600);
  //designate the laserConfigOne as an OUTPUT for turning the lasers on and off
  //arduino.pinMode(laserConfigOne, Arduino.OUTPUT);
  arduino.pinMode(laser1, Arduino.OUTPUT);
  arduino.pinMode(laser2, Arduino.OUTPUT);
  arduino.pinMode(laser3, Arduino.OUTPUT);
  arduino.pinMode(laser4, Arduino.OUTPUT);
  arduino.pinMode(laser5, Arduino.OUTPUT);
  arduino.pinMode(laser6, Arduino.OUTPUT);
  arduino.pinMode(laser7, Arduino.OUTPUT);
  arduino.pinMode(laser8, Arduino.OUTPUT);
  arduino.pinMode(laser9, Arduino.OUTPUT);
  arduino.pinMode(laser10, Arduino.OUTPUT);
  arduino.pinMode(laser11, Arduino.OUTPUT);
  arduino.pinMode(laser12, Arduino.OUTPUT);

  //initialize the minim files
  minim = new Minim(this);
  
  //designate the files for the minim and soundfile files
  chime = minim.loadSample("chime.wav", 2048);
  buzzer = minim.loadSample("WrongOption2.wav", 2048);
  buzzer2 = minim.loadSample("buzzer.wav", 2048);
  patternSuccess = minim.loadSample("PatternRecognized.mp3", 2048);
  patternFail = minim.loadSample("InvalidPattern_Mix_v1.mp3", 2048);
  laserActivate = new SoundFile(this, "layzuhhr.wav");
  laserMusic = new SoundFile(this, "LasersOnMixv1.wav");
  floorGridMusic =new SoundFile(this, "umami.mp3");
  
  //intitalize the Kinect depth and IR data
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableIR(true);  
  kinect.initVideo();
  
  img = createImage(kinect.width, kinect.height, RGB);

}

//this is the main draw function for the experience
//it is dependent on the state of the booleans to determine which class is being run (i.e. blackScreenIntro = TRUE so blackScreenIntro() is triggered)
void draw()
{
  background(0);
  if(blackScreenIntro){
    blackScreenIntro(); 
  } else if(laserPuzzle){
    laserPuzzle();
  } else if(laserDeactivatedScreen){
    laserDeactivatedScreen();
  } else if(floorGridInstScreen){
    floorGridInstScreen(); 
  } else if(floorGridPracticeScreen){
    floorGridPracticeScreen();
  } else if(floorGridStartScreen){
    floorGridStartScreen();
  } else if(floorGridLevelOne){
    floorGridLevelOne();
  } else if(floorGridSuccessLvlOneScreen){
    floorGridSuccessLvlOneScreen();
  } else if(floorGridLevelTwo){
    floorGridLevelTwo();
  } else if(floorGridSuccessLvlTwoScreen){
    floorGridSuccessLvlTwoScreen();
  } else if(floorGridLevelThree){
    floorGridLevelThree();
  } else if(floorGridSuccessLvlThreeScreen){
    floorGridSuccessLvlThreeScreen();
  } else if(floorGridLevelFour){
    floorGridLevelFour();
  } else if(floorGridSuccessLvlFourScreen){
    floorGridSuccessLvlFourScreen();
  } else if(floorGridComplete){
    floorGridCompleteScreen();
  }
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}