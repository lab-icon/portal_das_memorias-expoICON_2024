// controls:
// key 'f' to toggle frame rate
// key 'h' to increase threshold
// key 'b' to decrease threshold
// key 'j' to increase minD
// key 'n' to decrease minD
// key 'k' to increase maxD
// key 'm' to decrease maxD
// key 'g' to increase minPoints
// key 'v' to decrease minPoints
// key 'r' to toggle mask calibration
// key 'e' to increase maskScaleFactor
// key 'q' to decrease maskScaleFactor
// key 'w' to increase maskTranslateY
// key 's' to decrease maskTranslateY
// key 'a' to increase maskTranslateX
// key 'd' to decrease maskTranslateX
// key '0' to save the configuration

// import libraries
import KinectPV2.*;
import gab.opencv.*;

// declare variables
KinectPV2 kinect;
OpenCV opencv;

Star star[];

float maskScaleFactor;
float maskTranslateX;
float maskTranslateY;

PGraphics topLayer, bgLayer;
PGraphics mask;

PImage kinectInput;

//opencv variables
float polygonFactor = 1;
int threshold;
int maxD;
int minD;
int minPoints;
boolean contourBodyIndex = false;

// toggleable variables
boolean toggleFPS = true;
boolean toggleMaskCalibration = false;

// canvas variables
int canvasWidth = 2560/1;
int canvasHeight = 1080/1;

void setup() {
  //  size(3240/2, 720/2, P3D);
  fullScreen(P3D, 2);
  imageMode(CENTER);

  // load configurations
  loadConfig();

  // setup layers
  topLayer = createGraphics(canvasWidth, canvasHeight);  
  
  bgLayer = createGraphics(canvasWidth, canvasHeight);
  
  mask = createGraphics(canvasWidth, canvasHeight);
  mask.imageMode(CENTER);

  // load the stars
  star = new Star[500];
  for (int i = 0; i < star.length; i++) {
    float x = random(0, topLayer.width);
    float y = random(0, topLayer.height);
    star[i] = new Star(x, y, 1, 3);
  }

  // setup kinect
  kinect = new KinectPV2(this);  
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
  kinect.init();

  // setup opencv
  opencv = new OpenCV(this, 512, 424);
}

void loadConfig() {
    JSONObject configJSON = loadJSONObject("data/config.json");
    threshold = configJSON.getInt("threshold");
    maxD = configJSON.getInt("maxD");
    minD = configJSON.getInt("minD");
    minPoints = configJSON.getInt("minPoints");
    maskScaleFactor = configJSON.getFloat("maskScaleFactor");
    maskTranslateX = configJSON.getFloat("maskX");
    maskTranslateY = configJSON.getFloat("maskY");
  }

void saveConfig() {
  JSONObject configJSON = new JSONObject();
  configJSON.setInt("threshold", threshold);
  configJSON.setInt("maxD", maxD);
  configJSON.setInt("minD", minD);
  configJSON.setInt("minPoints", minPoints);
  configJSON.setFloat("maskScaleFactor", maskScaleFactor);
  configJSON.setFloat("maskX", maskTranslateX);
  configJSON.setFloat("maskY", maskTranslateY);
  saveJSONObject(configJSON, "data/config.json");
  println("config saved");
}

void draw() {  
  background(0);

  // top layer
  drawTopLayer();
  
  // mask
  drawOpencvMaskLayer();
  topLayer.mask(mask);

  // background layer
  drawBgLayer();

  // display the layers
  image(bgLayer,width/2,height/2);
  
  // draw the frame rate
  displayFPS(toggleFPS);
}

void displayFPS(boolean showFPS) {
  if (showFPS) {
    fill(255,0,0);
    textSize(60);
    text(frameRate, 100, 90);
  }
}

void opencvContour() {
  opencv.loadImage(kinect.getPointCloudDepthImage());
  opencv.threshold(threshold);

  ArrayList<Contour> contours = opencv.findContours(false, false);

  if (contours.size() > 0) {
    for (Contour contour : contours) {
      contour.setPolygonApproximationFactor(polygonFactor);
      if (contour.numPoints() > minPoints) {
        mask.noStroke();
        mask.fill(0);
        mask.beginShape();
        for (PVector point : contour.getPolygonApproximation().getPoints()) {
          mask.vertex(point.x * -maskScaleFactor + maskTranslateX + 512, point.y * maskScaleFactor + maskTranslateY);
        }
        mask.endShape();
      }
    }
  }
  // comment after threshold callibration
  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
}

void drawTopLayer() {
  topLayer.beginDraw();
  topLayer.background(0);
  for (int i = 0; i < star.length; i++) {
   star[i].blink(0.1);
   star[i].display(topLayer);
  }
  
  if (toggleMaskCalibration) {
    topLayer.noFill();
    topLayer.stroke(0, 255, 0);
    topLayer.strokeWeight(3);
    topLayer.rect(maskTranslateX, maskTranslateY, 512 * maskScaleFactor, 424 * maskScaleFactor);
  }
  topLayer.endDraw();
}

void drawOpencvMaskLayer() {
  mask.beginDraw();
  mask.background(255);
  opencvContour();
  mask.endDraw();
}

void drawBgLayer() {
  bgLayer.beginDraw();
  bgLayer.background(100, 200, 0);
  
  bgLayer.image(topLayer, 0, 0);
  bgLayer.endDraw();
}

// Controls
void keyReleased() {
  if (key == 'f') {
    toggleFPS = !toggleFPS;
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
  if (key == 'q') {
    maskScaleFactor -= 0.05;
    println("maskScaleFactor: " + maskScaleFactor);
  }
  if (key == 'e') {
    maskScaleFactor += 0.05;
    println("maskScaleFactor: " + maskScaleFactor);
  }
  if (key == 'w') {
    maskTranslateY -= 10;
    println("maskTranslateY: " + maskTranslateY);
  } 
  if (key == 's') {
    maskTranslateY += 10;
    println("maskTranslateY: " + maskTranslateY);
  }
  if (key == 'a') {
    maskTranslateX -= 10;
    println("maskTranslateX: " + maskTranslateX);
  }
  if (key == 'd') {
    maskTranslateX += 10;
    println("maskTranslateX: " + maskTranslateX);
  }
  if (key == 'r') {
    toggleMaskCalibration = !toggleMaskCalibration;
  }
  if (key == 'g') {
    minPoints += 10;
    println("minPoints: " + minPoints);
  }
  if (key == 'v') {
    minPoints -= 10;
    println("minPoints: " + minPoints);
  }
  if (key == '0') {
    saveConfig();
  }
}
