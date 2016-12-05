


void floorGridLevelThree() {

  //load images from camera
  img.loadPixels();
  imgVideo = kinect.getVideoImage();

  //clear blobs arraylist
  blobs.clear();

  //get depth info from kinect
  int[] depth = kinect.getRawDepth();

  for (int x = 10; x < kinect.width-10; x++) {
    for (int y = 0; y < kinect.height; y++) {
      int offset = x + y * img.width;
      int d = depth[offset];

      //set the depth for the sensor to pick up players
      if (d > minTreshold && d < maxThreshold) {
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
  //image(imgVideo,width/2,height/2, displayWidth, displayHeight);
  tint(255, 128);
  image(img, width/2, height/2, displayWidth, displayHeight);

  //draw the grid
  for (int i = 0; i < 16; i++) {
    rectMode(CORNER);
    noFill();
    stroke(255, 105, 180);
    rect(gridSections[i][0], gridSections[i][1], gridX, gridY);
  }  

  //draw the blobs if they are bigger than 500
  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }

  //start the level  
  if (patternCounter < patternRects.length) {
    patternNumber = patternCounter;
  } else {
    patternNumber = 0;
    patternCounter = 0;
  }


  ////build the pattern for level one
  for (int i = 0; i < patternRects[patternNumber].length; i++) {

    //println(patternRects[0][i]);
    fill(200);
    int rectX = gridSections[patternRects[patternNumber][i]][0];
    int rectY = gridSections[patternRects[patternNumber][i]][1];
    rectMode(CORNER);
    rect(rectX, rectY, gridX, gridY);
  } 



  //for each blob that exists, let's check it against the grid for that level    
  for (Blob b : blobs) {

    int rectOneX = gridSections[patternRects[patternNumber][0]][0];
    int rectOneY = gridSections[patternRects[patternNumber][0]][1];
    int rectTwoX = gridSections[patternRects[patternNumber][1]][0];
    int rectTwoY = gridSections[patternRects[patternNumber][1]][1];
    int rectThreeX = gridSections[patternRects[patternNumber][2]][0];
    int rectThreeY = gridSections[patternRects[patternNumber][2]][1];
    int rectFourX = gridSections[patternRects[patternNumber][3]][0];
    int rectFourY = gridSections[patternRects[patternNumber][3]][1];       

    //check if each of the blobs are in the designated rectangle and count to ten before registering TRUE
    if (b.centerOfBlobX > rectOneX && b.centerOfBlobX < (rectOneX +gridX) && b.centerOfBlobY > rectOneY && b.centerOfBlobY < (rectOneY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectOneX, rectOneY, gridX, gridY);
      spaceCounterOne++;
      
    } 
    if (spaceCounterOne >= 10) {
        rectOneGood = true;
        rectMode(CORNER);  
        fill(54, 243, 179);
        rect(rectOneX, rectOneY, gridX, gridY);
      }


    if (b.centerOfBlobX > rectTwoX && b.centerOfBlobX < (rectTwoX +gridX) && b.centerOfBlobY > rectTwoY && b.centerOfBlobY < (rectTwoY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectTwoX, rectTwoY, gridX, gridY);
      spaceCounterTwo++;
      
    } 
    if (spaceCounterTwo >= 10) {
        rectTwoGood = true;
        rectMode(CORNER);  
        fill(54, 243, 179);
        rect(rectTwoX, rectTwoY, gridX, gridY);
      }


    if (b.centerOfBlobX > rectThreeX && b.centerOfBlobX < (rectThreeX +gridX) && b.centerOfBlobY > rectThreeY && b.centerOfBlobY < (rectThreeY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectThreeX, rectThreeY, gridX, gridY);
      spaceCounterThree++;
      
    } 
    if (spaceCounterThree >= 10) {
        rectThreeGood = true;
        rectMode(CORNER);  
        fill(54, 243, 179);
        rect(rectThreeX, rectThreeY, gridX, gridY);
      }


    if (b.centerOfBlobX > rectFourX && b.centerOfBlobX < (rectFourX +gridX) && b.centerOfBlobY > rectFourY && b.centerOfBlobY < (rectFourY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectFourX, rectFourY, gridX, gridY);
      spaceCounterFour++;
      
    }
    if (spaceCounterFour >= 10) {
        rectFourGood = true;
        rectMode(CORNER);  
        fill(54, 243, 179);
        rect(rectFourX, rectFourY, gridX, gridY);
      }
  }
  
  //draw the blobs if they are bigger than 500
  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }


  levelCountdownLevelThree--;


  if (rectOneGood && rectTwoGood && rectThreeGood && rectFourGood) {

    chime.trigger();

    numberCorrect++;

    patternCounter++;
    rectOneGood = false;
    rectTwoGood = false;
    rectThreeGood = false;
    rectFourGood = false;

    levelCountdownLevelThree = 70;

    spaceCounterOne = 0;
    spaceCounterTwo = 0;
    spaceCounterThree = 0;
    spaceCounterFour = 0;
  } else 
  if (levelCountdownLevelThree == 0) {
    buzzer2.trigger();
    patternCounter++;
    levelCountdownLevelThree = 70;
    rectOneGood = false;
    rectTwoGood = false;
    rectThreeGood = false;
    rectFourGood = false; 

    spaceCounterOne = 0;
    spaceCounterTwo = 0;
    spaceCounterThree = 0;
    spaceCounterFour = 0;
  }



  if (numberCorrect >= targetPatternNumber) {
    floorGridLevelThree = false;
    levelThreePlayed = true;
    floorGridStartScreen = true;
    countdownFive = 50;
    numberCorrect = 0;
  }
  if (levelCountdownLevelThree < 40) {
    textAlign(CENTER);
    textSize(80);
    fill(255,0,0);
    text(levelCountdownLevelThree/10 + 1, width/2, height/2);
  }  


  textSize(64);
  fill(255);
  text("NUMBER CORRECT: " + numberCorrect, width/2, height - 100);

  if (keyPressed) {
    if (key == 'q') {
      floorGridLevelThree = false;
      levelThreePlayed = true;
      floorGridStartScreen = true;
      countdownFive = 50;
      numberCorrect = 0;
      
      rectOneGood = false;
      rectTwoGood = false;
      rectThreeGood = false;
      rectFourGood = false;

      spaceCounterOne = 0;
      spaceCounterTwo = 0;
      spaceCounterThree = 0;
      spaceCounterFour = 0;
    }
  }
  println(patternNumber);
}