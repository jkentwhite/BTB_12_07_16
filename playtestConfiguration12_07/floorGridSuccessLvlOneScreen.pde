void floorGridSuccessLvlOneScreen() {

  background(0);
  textSize(24);
  fill(255);
  textAlign(CENTER);
  
  text("do something here", width/2, height/2);
  
  countdownFive--;
  delay(100);
    if(countdownFive==0){
      floorGridSuccessLvlOneScreen = false;
      floorGridStartScreen = true;
      countdownFive = 50;
    }
}