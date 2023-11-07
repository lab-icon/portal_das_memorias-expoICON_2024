class Word {
  
  float xPosition,
        yPosition,
        zPosition,
        size;

  float diraction;

  String word;
  
  PGraphics layer;
  
  Word(String firstWord, float initX, float initY, float initZ, float _direction, PGraphics _layer) {
    word = firstWord;
    xPosition = initX;
    yPosition = initY;
    zPosition = initZ;
    size = 24 * zPosition;
    diraction = _direction;
    layer = _layer;
  }

  void display() {
    if (word != null) {
      layer.textSize(size);
      layer.text(word, xPosition, yPosition);
    }
  }
  
  boolean move(float speed) {
    xPosition += (speed / (zPosition * 2)) * diraction;
    return diraction == 1 && xPosition > layer.width + 250 || diraction == -1 && xPosition < -250;
  }

  void resetPosition (String newWord) {
    diraction = random(1) > 0.5 ? 1 : -1;
    if (diraction == 1) {
      xPosition = -250;
    } else {
      xPosition = layer.width + 250;
    }
    yPosition = random(20, layer.height - 20);
    word = newWord;
  } 
  
}
