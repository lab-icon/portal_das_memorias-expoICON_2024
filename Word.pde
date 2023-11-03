class Word {
  
  float xPosition,
        yPosition,
        zPosition,
        size;

  float diraction;

  String word;
  
  Word(String firstWord, float initX, float initY, float initZ, float _direction) {
    word = firstWord;
    xPosition = initX;
    yPosition = initY;
    zPosition = initZ;
    size = 24 * zPosition;
    diraction = _direction;
  }

  void display(PGraphics layer) {
    layer.textSize(size);
    layer.text(word, xPosition, yPosition);
  }
  
  boolean move(float speed) {
    xPosition += (speed / (zPosition * 2)) * diraction;
    if (diraction == 1 && xPosition > width + 250 || diraction == -1 && xPosition < -250) {
      return true;
    } else {
      return false;
    }
  }

  void resetPosition (String newWord, int layerHeight) {
    diraction = random(1) > 0.5 ? 1 : -1;
    if (diraction == 1) {
      xPosition = -250;
    } else {
      xPosition = width + 250;
    }
    // xPosition =  * diraction;
    yPosition = random(20, layerHeight - 20);
    word = newWord;
  } 
  
}
