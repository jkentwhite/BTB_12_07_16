void floorGridSuccessLvlTwoScreen() {

  background(0);
  textSize(24);
  fill(255);
  textAlign(CENTER);
  text("play video here", width/2, height/2);

  countdownFive--;
  delay(100);
  if (countdownFive==0) {
    floorGridSuccessLvlTwoScreen = false;
    floorGridStartScreen = true;
    countdownFive = 50;
  }
}