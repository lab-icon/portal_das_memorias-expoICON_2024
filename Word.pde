class Word {
  
  float xPosition,
        yPosition,
        size;
        
  String word;
  
  PGraphics layer;
  
  Word(String _word, float initX, float initY) {
    word = _word;
    xPosition = initX;
    yPosition = initY;
  }
  
  void display() {
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
