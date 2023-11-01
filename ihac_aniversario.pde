// import libraries
import KinectPV2.*;
import gab.opencv.*;

// declare variables
KinectPV2 kinect;
OpenCV opencv;

Word word[];
String[] wordsList;
Star star[];
Photo photo[];

int photoResolution;
int totalOfPhotos;

boolean foundUsers = false;

PGraphics topLayer, bgLayer;
PGraphics mask;

PImage kinectInput;

boolean keepAspectRatio = true;

//opencv variables
float polygonFactor = 1;
int threshold = 80;
int maxD = 1800;
int minD = 1200;
boolean    contourBodyIndex = false;

void setup() {
  size(960*2, 360*2, P3D);
  
  // load the words
  wordsList = loadStrings("data/top_dog_names.txt");
  println("there are " + wordsList.length + " lines");
  word = new Word[50];
  for (int i = 0; i < word.length; i++) {
    float extraRange = 250;
    float verticalMargin = 10;
    float x = random(-extraRange, width);
    float y = random(verticalMargin, height -verticalMargin);
    float z = random(0.5, 1);
    word[i] = new Word(wordsList, x, y, z);
  }

  // load the stars
  star = new Star[500];
  for (int i = 0; i < star.length; i++) {
    float x = random(0, width);
    float y = random(0, height);
    star[i] = new Star(x, y, 1, 3);
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
  // kinect.enableBodyTrackImg(true);
  kinect.enablePointCloud(true);
  kinect.init();

  // setup opencv
  opencv = new OpenCV(this, 512, 424);
  
  // setup layers
  topLayer = createGraphics(width, height);  
  
  bgLayer = createGraphics(width, height);
  
  mask = createGraphics(width,height);
  mask.imageMode(CENTER);
}

void draw() {  
  // top layer
  drawTopLayer();
  
  // mask
  drawMaskLayer();
  topLayer.mask(mask);

  // background layer
  drawBgLayer();

  // display the layers
  image(bgLayer,0,0);
  
  // draw the frame rate
  textSize(60);
  fill(255,0,0);
  text(frameRate, 50, 90);
}

void mousePressed() {
  keepAspectRatio = !keepAspectRatio;
  println(keepAspectRatio);
}

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
          mask.vertex(point.x * 2.5, point.y * 2.5);
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
   star[i].getLayer(topLayer);
   star[i].blink(0.05);
   star[i].display();
  }
  for (int i = 0; i < word.length; i++) {
    word[i].getLayer(topLayer);
    word[i].move(1.2);
    word[i].display();
  }
  topLayer.endDraw();
}

void drawMaskLayer() {
  mask.beginDraw();
  // kinectInput = kinect.getBodyTrackImage();
  // if (keepAspectRatio) {
  //   mask.image(kinectInput, width*0.5, height, width, width*1.2);
  // }
  // else {
  //   mask.image(kinectInput, width*0.5, height*0.5, width, height);
  // }
  
  // mask.image(kinectInput, width/2, height/2);
  mask.background(255);
  opencvContour();
  mask.endDraw();
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