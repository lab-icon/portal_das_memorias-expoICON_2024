class Photo {
  float xPosition,
        yPosition;
  PGraphics layer;
  PImage photo;
  Photo(String ulr, float initX, float initY) {
    xPosition = initX;
    yPosition = initY;
    photo = loadImage(ulr);
  }
  
  void display(){ 
   layer.image(photo, xPosition, yPosition);
  }
  
  void getLayer(PGraphics _layer) {
    layer = _layer;
  }
}