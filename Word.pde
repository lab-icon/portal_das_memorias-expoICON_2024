class Word {
  
  float xPosition,
        yPosition,
        zPosition,
        size;
        
  String word;
  // String[] wordsList;
  
  Word(String firstWord, float initX, float initY, float initZ) {
    word = firstWord;
    xPosition = initX;
    yPosition = initY;
    zPosition = initZ;
    size = 24 * zPosition;
  }

  void display(PGraphics layer) {
    layer.textSize(size);
    layer.text(word, xPosition, yPosition);
  }
  
  boolean move(float speed) {
    xPosition += speed / (zPosition * 2);
    if (xPosition > width) {
      return true;
    } else {
      return false;
    }
  }

  void resetPosition (String newWord, int layerHeight) {
    xPosition = -250;
    yPosition = random(20, layerHeight - 20);
    word = newWord;
  }
  
}
