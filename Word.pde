class Word {
  
  float xPosition,
        yPosition,
        zPosition,
        size;
        
  String word;
  // String[] wordsList;
  
  PGraphics layer;
  
  Word(String firstWord, float initX, float initY, float initZ) {
    word = firstWord;
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
    xPosition += speed / (zPosition * 2);
  }

  void resetPosition (String newWord) {
    if (xPosition > layer.width) {
      xPosition = -250;
      yPosition = random(20, layer.height - 20);
      word = newWord;
    }
  }
  
  void getLayer(PGraphics _layer) {
    layer = _layer;
  }
  
}
