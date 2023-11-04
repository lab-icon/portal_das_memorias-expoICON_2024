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
  
  void display(PGraphics layer){
    if (photo != null) {
      layer.image(photo, xPosition, yPosition);
    }
  }

  void changePhoto(String url) {
    if (url != null) {
      photo = loadImage(url);
    }
  }
}