void laserDeactivatedScreen(){
  
  //tell the players that they have completed the laser challenge and to prepare for the floorgrid challenge
  textAlign(CENTER);
  text("LASERS DEACTIVATED! \nPREPARE FOR FLOOR GRID CHALLENGE", width/2, height/2);

  //as each frame passes reduce the countdownFive variable to create a statuc screen for 5 seconds or so
  countdownFive--;
  delay(100);
  
  //once the countdownFive has reached zero, move to the floorgrid instruction screen and reset the countdown 
  if(countdownFive==0){
      laserDeactivatedScreen = false;
      floorGridInstScreen = true;
      countdownFive = 50;
    }
    
   //override the countdown to move to the floorgrid instruction screen
    if(keyPressed){
      if(key == ' '){
      laserDeactivatedScreen = false;
      floorGridInstScreen = true;
      countdownFive = 50;
      }
    }
}