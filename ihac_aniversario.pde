// import libraries
import KinectPV2.*;
import gab.opencv.*;

// declare variables
KinectPV2 kinect;
OpenCV opencv;

String[] wordList;
Word word[];
Star star[];
Photo photo[];

int photoResolution;
int totalOfPhotos;

float maskScaleFactor = 2.5;
boolean foundUsers = false;

PGraphics topLayer, bgLayer;
PGraphics mask;

PImage kinectInput;

//opencv variables
float polygonFactor = 1;
int threshold = 30;
int maxD = 1800;
int minD = 1200;
boolean    contourBodyIndex = false;

// toggleable variables
boolean toggleFPS = true;
boolean keepAspectRatio = true;
boolean toggleOpencv = true;

void setup() {
  size(960*2, 360*2, P3D);

  // setup layers
  topLayer = createGraphics(width, height);  
  
  bgLayer = createGraphics(width, height);
  
  mask = createGraphics(width,height);
  mask.imageMode(CENTER);
  
  // load the words
  loadJSON();
  println("there are " + wordList.length + " lines");
  word = new Word[50];
  for (int i = 0; i < word.length; i++) {
    float extraRange = 250;
    float verticalMargin = 10;
    float x = random(-extraRange, width);
    float y = random(verticalMargin, height -verticalMargin);
    float z = random(0.5, 1.5);
    String firstWord = wordList[int(random(wordList.length))];
    word[i] = new Word(firstWord, x, y, z);
  }

  // load the stars
  star = new Star[500];
  for (int i = 0; i < star.length; i++) {
    float x = random(0, width);
    float y = random(0, height);
    star[i] = new Star(x, y, 1, 3);
    star[i].getLayer(topLayer);
  }

  // load the photos
  photoResolution = 45;
  totalOfPhotos = 669;
  int photoClumns = width / photoResolution + 1;
  int photoRows = height / photoResolution;
  int displayedPhotos = photoClumns * photoRows;
  photo = new Photo[displayedPhotos];
  for (int i = 0; i < photo.length; i++) {
    int x = floor(i / photoRows) * photoResolution;
    int y = floor(i % photoRows) * photoResolution;
    photo[i] = new Photo("fotos_escolhidas_"+photoResolution+"x"+photoResolution+"/foto"+int(random(totalOfPhotos))+".jpg", x, y);
  }
  
  // setup kinect
  kinect = new KinectPV2(this);  
  kinect.enableDepthImg(true);
  kinect.enableBodyTrackImg(true);
  kinect.enablePointCloud(true);
  kinect.init();

  // setup opencv
  opencv = new OpenCV(this, 512, 424);
}

void loadJSON() {
  JSONArray wordJSON = loadJSONArray("data/wordList.json");
  wordList = new String[wordJSON.size()];
  for (int i = 0; i < wordJSON.size(); i++) {
    JSONObject word = wordJSON.getJSONObject(i);
    String wordText = word.getString("word");
    wordList[i] = wordText;
  }
}

void draw() {  
  // top layer
  drawTopLayer();
  
  // mask
  drawMaskLayer(!toggleOpencv);
  drawOpencvMaskLayer(toggleOpencv);
  topLayer.mask(mask);

  // background layer
  drawBgLayer();

  // display the layers
  image(bgLayer,0,0);
  
  // draw the frame rate
  displayFPS(toggleFPS);
}

void keyReleased() {
  if (key == 'f') {
    toggleFPS = !toggleFPS;
  }
  if (key == '0') {
    keepAspectRatio = !keepAspectRatio;
  }
  if (key == '1') {
    toggleOpencv = !toggleOpencv;
  
  }
  if (key == 'h') {
    threshold += 10;
    println("threshold: " + threshold);
  }
  if (key == 'b') {
    threshold -= 10;
    println("threshold: " + threshold);
  }
  if (key == 'j') {
    minD += 10;
    println("minD: " + minD);
  }
  if (key == 'n') {
    minD -= 10;
    println("minD: " + minD);
  }
  if (key == 'k') {
    maxD += 10;
    println("maxD: " + maxD);
  }
  if (key == 'm') {
    maxD -= 10;
    println("maxD: " + maxD);
  }
  if (key == 'g') {
    maskScaleFactor += 0.1;
    println("maskScaleFactor: " + maskScaleFactor);
  }
  if (key == 'v') {
    maskScaleFactor -= 0.1;
    println("maskScaleFactor: " + maskScaleFactor);
  }
}

void displayFPS(boolean showFPS) {
  if (showFPS) {
    fill(255,0,0);
    textSize(60);
    text(frameRate, 50, 90);
  }
}

// void mousePressed() {
//   keepAspectRatio = !keepAspectRatio;
//   println(keepAspectRatio);
// }

void opencvContour() {
  noFill();
  strokeWeight(3);
  if (contourBodyIndex) {
    opencv.loadImage(kinect.getBodyTrackImage());
    opencv.gray();
    opencv.threshold(threshold);
    PImage dst = opencv.getOutput();
  } else {
    opencv.loadImage(kinect.getPointCloudDepthImage());
    opencv.gray();
    opencv.threshold(threshold);
    PImage dst = opencv.getOutput();
  }

  ArrayList<Contour> contours = opencv.findContours(false, false);

  if (contours.size() > 0) {
    for (Contour contour : contours) {

      contour.setPolygonApproximationFactor(polygonFactor);
      if (contour.numPoints() > 50) {
        mask.noStroke();
        mask.fill(0);
        mask.beginShape();

        for (PVector point : contour.getPolygonApproximation ().getPoints()) {
          mask.vertex(point.x * maskScaleFactor, point.y * maskScaleFactor);
        }
        mask.endShape();
      }
    }
  }
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
}

void drawTopLayer() {
  topLayer.beginDraw();
  topLayer.background(0);
  for (int i = 0; i < star.length; i++) {
   star[i].blink(0.05);
   star[i].display();
  }
  for (int i = 0; i < word.length; i++) {
    if (word[i].move(1.2)) {
      String nextWord = wordList[int(random(wordList.length))];
      word[i].resetPosition(nextWord, topLayer.height);
    }
    word[i].display(topLayer);
  }
  topLayer.endDraw();
}

void drawMaskLayer(boolean useKinect) {
  if (useKinect) {
    mask.beginDraw();
    kinectInput = kinect.getBodyTrackImage();
    if (keepAspectRatio) {
      mask.image(kinectInput, width*0.5, height, width, width*1.2);
    }
    else {
      mask.image(kinectInput, width*0.5, height*0.5, width, height);
    }
    // mask.image(kinectInput, width/2, height/2);
    mask.endDraw();
  }
}

void drawOpencvMaskLayer(boolean useOpencv) {
  if (useOpencv) {
    mask.beginDraw();
    mask.background(255);
    opencvContour();
    mask.endDraw();
  }
}

void drawBgLayer() {
  bgLayer.beginDraw();
  bgLayer.background(100, 200, 0);
  if (random(1) < 0.6) {
    photo[int(random(photo.length))].changePhoto("fotos_escolhidas_"+photoResolution+"x"+photoResolution+"/foto"+int(random(totalOfPhotos))+".jpg");
  }
  for (int i = 0; i < photo.length; i++) {
    photo[i].getLayer(bgLayer);
    photo[i].display();
  }
  bgLayer.image(topLayer, 0, 0);
  bgLayer.endDraw();
}