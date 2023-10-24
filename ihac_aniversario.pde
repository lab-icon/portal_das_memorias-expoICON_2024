import KinectPV2.*;
import spout.*;

KinectPV2 kinect;
Word word[];

boolean foundUsers = false;

PGraphics topLayer, bgLayer;
PGraphics mask;

PImage[] shiba;
PImage kinectInput;

String[] wordsList;
//PImage[] shibas;

boolean keepAspectRatio = true;

Spout spout;

void setup() {
  size(960, 360, P3D);
  textureMode(NORMAL);
  
  wordsList = loadStrings("data/top_dog_names.txt");
  println("there are " + wordsList.length + " lines");
  word = new Word[wordsList.length];
  for (int i = 0; i < wordsList.length; i++) {
    word[i] = new Word(wordsList[i], random(-250, width + 250), random(20, height - 20));
  }
  
  kinect = new KinectPV2(this);  
  kinect.enableBodyTrackImg(true);  
  kinect.init();
  
  topLayer = createGraphics(width, height);  
  
  bgLayer = createGraphics(width, height);
  
  mask = createGraphics(width,height);
  mask.imageMode(CENTER);
  
  shiba = new PImage[40];
  for (int i = 0; i < shiba.length; i++) {
   shiba[i] = loadImage("photos/shiba_90x90.jpg"); 
  }
  //shiba.resize(0, height);
  
  spout = new Spout(this);
  spout.setSenderName("spoutIcon");
}

void draw() {  
  background(0);
  
  topLayer.beginDraw();
  topLayer.background(0);
  for (int i = 0; i < wordsList.length; i++) {
    word[i].getLayer(topLayer);
    word[i].move(1);
    word[i].display();
  }
  topLayer.endDraw();

  mask.beginDraw();
  kinectInput = kinect.getBodyTrackImage();
  
  if (keepAspectRatio)
    mask.image(kinectInput, width*0.5, height, width, width*1.2);
  else
    mask.image(kinectInput, width*0.5, height*0.5, width, height);
  mask.endDraw();
  
  topLayer.mask(mask);
  
  bgLayer.beginDraw();
  bgLayer.background(100, 200, 0);
  for (int i = 0; i < shiba.length; i++) {
    bgLayer.image(shiba[i], width/2, height/2);
  }
  bgLayer.image(topLayer, 0, 0);
  bgLayer.endDraw();
  
  image(bgLayer,0,0);
  
  //image(topLayer,0,0);
  
  spout.sendTexture(bgLayer);
  
  push();
  textSize(60);
  fill(255,0,0);
  text(frameRate, 50, 90);
  pop();
}

void mousePressed() {
  keepAspectRatio = !keepAspectRatio;
  println(keepAspectRatio);
}
