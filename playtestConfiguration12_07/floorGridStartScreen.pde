void floorGridStartScreen(){
  
    //clear the screen
    background(0);
    
    //draw grid
    for(int i = 0; i < 16; i++){
      rectMode(CORNER);
      noFill();
      stroke(255,105,180);
      rect(gridSections[i][0], gridSections[i][1], gridX, gridY);
    
      }
      
      textSize(64);
      fill(255);
      if(!levelOnePlayed){
        text("WAY TO GO! \nNOW YOU ARE READY!\n\nPREPARE FOR LEVEL ONE", width/2, height/4);
      } else if(!levelTwoPlayed){
        text("WAY TO GO! \nYOU PASSED LEVEL ONE!\n\nPREPARE FOR LEVEL TWO", width/2, height/4);
      } else if(!levelThreePlayed){
        text("WAY TO GO! \nYOU PASSED LEVEL TWO!\n\nPREPARE FOR LEVEL THREE", width/2, height/4);
      } else {
        text("WAY TO GO! \nYOU PASSED LEVEL THREE THREE!\n\nPREPARE FOR LEVEL FOUR", width/2, height/4);
      }
     

    
      textSize(64);
      fill(255);
      text(countdownFive/10, width/2, height/2);
      countdownFive--;
      delay(100);
      if(countdownFive==0){
        floorGridStartScreen = false;
        if(!levelOnePlayed){
          floorGridLevelOne = true;
        } else if(!levelTwoPlayed){
          //patternCounter = 0;
          floorGridLevelTwo = true;
        } else if(!levelThreePlayed){
          //patternCounter = 0;
          floorGridLevelThree = true;
        } else {
          //patternCounter = 0;
          floorGridLevelFour = true;
        }
      }
    
}