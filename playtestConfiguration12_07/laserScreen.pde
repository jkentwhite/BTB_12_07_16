
//create local variables for:

//setting the threshold for the amount of light to trigger the lasers
int lightReceptorThreshold = 100;

//counting the number of lasers hit
int hitLaserCounter = 0;
int oneHitCounter = 0;

int laserStatus, prevLaser, currentLaser;

int numberOfLasers = 10;

boolean audioSamplePlayed = false;
boolean audioMusicPlayed = false;

//create an array of booleans for the listed number of lasers
boolean [] lasers = new boolean[numberOfLasers];


void laserScreen(){
  background(0);
  
  //check if audio has been played and if not, play it
  //if(!audioSamplePlayed){
  //  laserMusic.play();
  //  laserActivate.play();
  //  if(laserActivate.isPlaying()){
  //    audioSamplePlayed = false;
  //    } else {
  // audioSamplePlayed = true;
  //}  
  
  //provide instructions to the players on a projected screen
  textAlign(CENTER);
  textSize(24);
  text("Each player must move through the lasers to the opposite wall", width/2, height/5);
  text("You have hit " + hitLaserCounter + " lasers!", width/2, height/5*4);
   
   
    ////activate the lasers by turning the laserConfigOne to HIGH
    ////arduino.digitalWrite(laserConfigOne, Arduino.HIGH);
    //delay(100);
    
    //while this function is running, check through designated numberOfLasers to see if the respective light receptor is being interrupted
    for(int i = 0; i < numberOfLasers; i++){
    laserStatus = arduino.analogRead(i);
    
      //if the laserStatus(i.e. amount of light hitting the receptor from the laser) is less lightReceptorThreshold then make that receptor boolean true
      //meaning it has been interrupted
      if (laserStatus < lightReceptorThreshold && i != 4){
        
        //set the boolean true for the current laser being tripped
        lasers[i] = true;
        
        //store the current laser for comparison to eliminate multiple triggers for the same laser being tripped at once
        currentLaser = i;
        
        //console print out which laser is being tripped
        println("laser " + i + "being trippped");
        
      } else {
        //if the receptor/laser is not being triggered set the boolean for that laser to FALSE
        lasers[i] = false;
      }
      
      //check the array of booleans for all lasers/receptor and if it is TRUE and has not been counted yet, then add one to the hitLaserCounter and the oneHitCounter 
      if(lasers[currentLaser] && oneHitCounter < 1){
         hitLaserCounter++;
         oneHitCounter++;
         buzzer2.trigger();
      }
      
      //if the current laser is not being triggered anymore, i.e. FALSE, and the oneHitCounter has been counted then reset the oneHitCounter
      if(!lasers[currentLaser] && oneHitCounter > 0){
        oneHitCounter = 0;
      }
    }
    
    
    ////to move on to the next phase in the experience press 1 for now, we will determine how to integrate this more into the experience 
    //if(keyPressed){
    //  if(key == '1'){
    //    //set booleans to change screens and move from lasers to the deactivation screen
    //    //turn the lasers off when the laser level is complete
    //    arduino.digitalWrite(laserConfigOne, Arduino.LOW);
    //    laserScreen = false;
    //    laserDeactivatedScreen = true;
    //    //stop music before moving on
    //    laserMusic.stop();
    //    }
    //  }
      
    //  //print in the console the word lasers to indicate that the laser screen is running
    //  println("lasers");
    //  //print in the console how many times the hitLaserCounter has tallied hits
    //  println("number of lasers hit: " + hitLaserCounter);
}