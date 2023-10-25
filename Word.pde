class Word {
  
  float xPosition,
        yPosition,
        zPosition,
        size;
        
  String word;
  
  PGraphics layer;
  
  Word(String _word, float initX, float initY, float initZ) {
    word = _word;
    xPosition = initX;
    yPosition = initY;
    zPosition = initZ;
    size = 24 * zPosition;
  }

  void display() {
    layer.textSize(size);
    layer.text(word, xPosition, yPosition);
  }
  
  void move(float speed) {
    xPosition += speed;
    
    if (xPosition > layer.width + 250) {
      xPosition = -250;
      yPosition = random(20, layer.height - 20);
    }
  }
  
  void getLayer(PGraphics _layer) {
    layer = _layer;
  }
  
}
