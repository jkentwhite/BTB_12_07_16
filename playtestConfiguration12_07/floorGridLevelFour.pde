//creat local variables for a flying object that must be avoided
//int objectX = 512, objectY = 388;
//PImage redBurst;
//boolean upX = true, upY = true, collisionBurst = false;
//int collisionTimer = 0, collisionDistance = 50, collisionRadius = 10;

void floorGridLevelFour() {

  //println(objectX + ", " + objectY);

  redBurst = loadImage("redBurst.png");
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

  if (collisionBurst) {
    collisionTimer++;
    levelCountdownLevelFour = 100;
    if (collisionTimer >= 30) {
      
      collisionBurst = false;
      collisionTimer = 0;
      levelCountdownLevelFour = 70;

    }
  }



  //start the level  
  if (patternCounter < patternRectsB.length) {
    patternNumber = patternCounter;
  } else {
    patternNumber = 0;
    patternCounter = 0;
  }


  if (!collisionBurst) {
    ////build the pattern for each patternNumber
    for (int i = 0; i < patternRectsB[patternNumber].length; i++) {

      //println(patternRects[0][i]);
      fill(200);
      int rectX = gridSections[patternRectsB[patternNumber][i]][0];
      int rectY = gridSections[patternRectsB[patternNumber][i]][1];
      rectMode(CORNER);
      rect(rectX, rectY, gridX, gridY);
    }
  } else {
    background(0);
  }

  //draw the blobs if they are bigger than 500
  for (Blob b : blobs) {
    if (b.size() > 500) {

      if (collisionBurst) {
        textSize(32);
        fill(255, 0, 0);
        text("AVOID THE RED BURST!\nEACH TIME IT HITS YOU,\nYOU LOSE ONE POINT", width/2, height/3);
      } else {
        b.show();
      }
    }
  }



  //for each blob that exists, let's check it against the grid for that level    
  for (Blob b : blobs) {

    int rectOneX = gridSections[patternRectsB[patternNumber][0]][0];
    int rectOneY = gridSections[patternRectsB[patternNumber][0]][1];
    int rectTwoX = gridSections[patternRectsB[patternNumber][1]][0];
    int rectTwoY = gridSections[patternRectsB[patternNumber][1]][1];
    int rectThreeX = gridSections[patternRectsB[patternNumber][2]][0];
    int rectThreeY = gridSections[patternRectsB[patternNumber][2]][1];
    int rectFourX = gridSections[patternRectsB[patternNumber][3]][0];
    int rectFourY = gridSections[patternRectsB[patternNumber][3]][1];       

    if (b.centerOfBlobX > rectOneX && b.centerOfBlobX < (rectOneX +gridX) && b.centerOfBlobY > rectOneY && b.centerOfBlobY < (rectOneY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectOneX, rectOneY, gridX, gridY);
      spaceCounterOne++;
      if (spaceCounterOne >= 10) {
        rectOneGood = true;
      }
    } 


    if (b.centerOfBlobX > rectTwoX && b.centerOfBlobX < (rectTwoX +gridX) && b.centerOfBlobY > rectTwoY && b.centerOfBlobY < (rectTwoY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectTwoX, rectTwoY, gridX, gridY);
      spaceCounterTwo++;
      if (spaceCounterTwo >= 10) {
        rectTwoGood = true;
      }
    } 


    if (b.centerOfBlobX > rectThreeX && b.centerOfBlobX < (rectThreeX +gridX) && b.centerOfBlobY > rectThreeY && b.centerOfBlobY < (rectThreeY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectThreeX, rectThreeY, gridX, gridY);
      spaceCounterThree++;
      if (spaceCounterThree >= 10) {
        rectThreeGood = true;
      }
    } 


    if (b.centerOfBlobX > rectFourX && b.centerOfBlobX < (rectFourX +gridX) && b.centerOfBlobY > rectFourY && b.centerOfBlobY < (rectFourY + gridY)) {
      rectMode(CORNER);  
      fill(54, 243, 179);
      rect(rectFourX, rectFourY, gridX, gridY);
      spaceCounterFour++;
      if (spaceCounterFour >= 10) {
        rectFourGood = true;
      }
    }
  }

  //draw the blobs if they are bigger than 500
  for (Blob b : blobs) {
    if (b.size() > 500) {

      if (collisionBurst) {
        textSize(32);
        fill(255, 0, 0);
        text("AVOID THE RED BURST!\nEACH TIME IT HITS YOU,\nYOU LOSE ONE POINT", width/2, height/3);
      } else {
        b.show();
      }
    }
  }

  //remember to turn this back on if want timer
  levelCountdownLevelFour--;


  if (rectOneGood && rectTwoGood && rectThreeGood && rectFourGood) {

    chime.trigger();

    numberCorrect++;

    patternCounter++;
    rectOneGood = false;
    rectTwoGood = false;
    rectThreeGood = false;
    rectFourGood = false;

    levelCountdownLevelFour = 70;

    spaceCounterOne = 0;
    spaceCounterTwo = 0;
    spaceCounterThree = 0;
    spaceCounterFour = 0;
  } else if (levelCountdownLevelFour == 0) {
    buzzer2.trigger();
    patternCounter++;
    levelCountdownLevelFour = 70;

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
    floorGridLevelFour = false;
    levelFourPlayed = true;
    floorGridSuccessLvlFourScreen = true;
    countdownFive = 50;
    numberCorrect = 0;
  }
  if (levelCountdownLevelFour < 40) {
    textSize(80);
    fill(255,0,0);
    text(levelCountdownLevelFour/10 + 1, width/2, height/2);
  }  

  //make the red burst appear
  noTint();
  image(redBurst, objectX, objectY);

  //move the burst around and make sure it stays on the screen
  if (objectX < 1000 && upX) {
    objectX+=35;
    if (objectX >= 1000) {
      upX = false;
    }
  } else if (objectX > 10 && !upX) {
    objectX-=35;
    if (objectX <= 10) {
      upX = true;
    }
  }

  if (objectY < 750 && upY) {
    objectY+=35;
    if (objectY >= 750) {
      upY = false;
    }
  } else if (objectY > 10 && !upY) {
    objectY-=35;
    if (objectY <= 10) {
      upY = true;
    }
  }

  //check to see if the burst is close enough to any blob to be considered a collision
  //both collisionRadius and collisionDistance can be changed from the main sketch tab
  for (Blob b : blobs) {
    if ((objectX + collisionRadius) < (b.centerOfBlobX + collisionDistance) && (objectX - collisionRadius) > (b.centerOfBlobX - collisionDistance) && (objectY + collisionRadius) < (b.centerOfBlobY + collisionDistance) && (objectY + collisionRadius) > (b.centerOfBlobY - collisionDistance)) {
      background(0);
      collisionBurst = true;
      buzzer.trigger();
      numberCorrect--;
      patternCounter++;
    }
  }
  
  if(numberCorrect < 0){
    numberCorrect = 0;
  } 
  textSize(64);
  fill(255);
  text("NUMBER CORRECT: " + numberCorrect, width/2, height - 100);

  //to move to the next level press Q
  if (keyPressed) {
    if (key == 'q' || key == 'Q') {
      floorGridLevelFour = false;
      levelFourPlayed = true;
      floorGridSuccessLvlFourScreen = true;
      countdownFive = 50;
      numberCorrect = 0;
    }
  }
  println("pattern number: " + patternNumber);
}