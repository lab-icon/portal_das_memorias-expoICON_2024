class Star {
  float xPosition;
  float yPosition;
  float minimalSize;
  float maximalSize;
  float initialSize;
  float size;

  
  Star(float _xPosition, float _yPosition, float _minSize, float _maxSize) {
    xPosition = _xPosition;
    yPosition = _yPosition;
    minimalSize = _minSize;
    maximalSize = _maxSize;
    initialSize = random(minimalSize, maximalSize);
    size = initialSize;
  }

  void display(PGraphics layer) {
    layer.fill(255);
    layer.noStroke();
    layer.circle(xPosition, yPosition, size);
  }

  void blink(float _period) {
    float periodOffset = map(initialSize, minimalSize, maximalSize, 0, TWO_PI);
    float period = cos((frameCount * _period) + periodOffset);
    size = map(period, -1, 1, minimalSize, maximalSize);
  }
}
