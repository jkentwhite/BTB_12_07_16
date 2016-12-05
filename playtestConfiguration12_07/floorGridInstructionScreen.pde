
void floorGridInstScreen() {

  background(0);

  //draw grid
  for (int i = 0; i < 16; i++) {
    rectMode(CORNER);
    noFill();
    stroke(255, 105, 180);
    rect(gridSections[i][0], gridSections[i][1], gridX, gridY);
  }

  //provide instructions
  textSize(24);
  fill(255);
  textAlign(CENTER);
  text("Move into the designated \n spaces on the grid \n to complete each level", width/2, height/3);
  text("Recreate 5 patterns correctly for each level\nComplete 4 levels to pass this challenge ", width/2, height/2);
  //text("Press space to start", width/4*3, height/3 * 2);


  //countdown to move from instructions to start screen
  countdownFive--;
  delay(100);
  if (countdownFive==0) {
    floorGridInstScreen = false;
    floorGridPracticeScreen = true;
    countdownFive = 50;
  }
}