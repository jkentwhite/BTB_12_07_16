// mostly shiffman's code with some manipulation for showing the blobs as representations instead of the blobs that are detected
// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/1scFcY-xMrI

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  
  float centerOfBlobX;
  float centerOfBlobY;

  ArrayList<PVector> points;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }

//function to place a circle where there are bolbs detected
  void show() {
    centerOfBlobX = (maxx - minx)/2 + minx;
    centerOfBlobY = (miny * 2 + maxy * 2)/4;
    
    centerOfBlobX = map(centerOfBlobX, 0, 640, 0, displayWidth);
    centerOfBlobY = map(centerOfBlobY, 0, 480, 0, displayHeight);
    
    //if(laserPuzzle){
    //  noFill();
    //  noStroke();
    //} else {
    stroke(0);
    fill(255);
    strokeWeight(2);
  //}
    rectMode(CORNERS);
    ellipse(centerOfBlobX, centerOfBlobY, 100, 100);
    textSize(32);
    fill(0,255,0);
    if(floorGridPracticeScreen){
      text("PLAYER", centerOfBlobX, centerOfBlobY);
    }
    
  }


  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

//function to determine if the blob detected is far enough away to be a new blob
  boolean isNear(float x, float y) {
    
     float cx = max(min(x, maxx), minx);
     float cy = max(min(y, maxy), miny);
     float d = distSq(cx, cy, x, y);


    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}