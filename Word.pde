class Word {
  
  float xPosition,
        yPosition,
        zPosition,
        size;
        
  String word;
  String[] wordsList;
  
  PGraphics layer;
  
  Word(String[] _wordsList, float initX, float initY, float initZ) {
    wordsList = _wordsList;
    word = wordsList[int(random(wordsList.length))];
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
    
    if (xPosition > layer.width + 250) {
      xPosition = -250;
      yPosition = random(20, layer.height - 20);
      word = wordsList[int(random(wordsList.length))];
    }
  }
  
  void getLayer(PGraphics _layer) {
    layer = _layer;
  }
  
}
