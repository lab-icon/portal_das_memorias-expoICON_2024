// import libraries
import KinectPV2.*;

// declare variables
KinectPV2 kinect;
Word word[];
String[] wordsList;
Star star[];
Photo photo[];

int photoResolution;

boolean foundUsers = false;

PGraphics topLayer, bgLayer;
PGraphics mask;

PImage kinectInput;

boolean keepAspectRatio = true;

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

  photoResolution = 45;
  int photoClumns = width / photoResolution + 1;
  int photoRows = height / photoResolution;
  int photoAmount = photoClumns * photoRows;
  photo = new Photo[photoAmount];
  for (int i = 0; i < photo.length; i++) {
    int x = floor(i / photoRows) * photoResolution;
    int y = floor(i % photoRows) * photoResolution;
    photo[i] = new Photo("fotos_escolhidas_"+photoResolution+"x"+photoResolution+"/foto"+int(random(755))+".jpg", x, y);
  }
  
  // setup kinect
  kinect = new KinectPV2(this);  
  kinect.enableBodyTrackImg(true);  
  kinect.init();
  
  // setup layers
  topLayer = createGraphics(width, height);  
  
  bgLayer = createGraphics(width, height);
  
  mask = createGraphics(width,height);
  mask.imageMode(CENTER);
}

void draw() {  
  // top layer
  topLayer.beginDraw();
  topLayer.background(0);
  for (int i = 0; i < star.length; i++) {
   star[i].getLayer(topLayer);
   star[i].blink(0.05);
   star[i].display();
  }
  for (int i = 0; i < word.length; i++) {
    word[i].getLayer(topLayer);
    word[i].move(1);
    word[i].display();
  }
  topLayer.endDraw();

  // mask
  mask.beginDraw();
  kinectInput = kinect.getBodyTrackImage();
  if (keepAspectRatio) {
    mask.image(kinectInput, width*0.5, height, width, width*1.2);
  }
  else {
    mask.image(kinectInput, width*0.5, height*0.5, width, height);
  }
  mask.endDraw();

  topLayer.mask(mask);
  
  // background layer
  bgLayer.beginDraw();
  bgLayer.background(100, 200, 0);
  if (random(1) < 0.2) {
    photo[int(random(photo.length))].changePhoto("fotos_escolhidas_"+photoResolution+"x"+photoResolution+"/foto"+int(random(755))+".jpg");
  }
  for (int i = 0; i < photo.length; i++) {
    photo[i].getLayer(bgLayer);
    photo[i].display();
  }
  bgLayer.image(topLayer, 0, 0);
  bgLayer.endDraw();
  
  // draw the layers
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
