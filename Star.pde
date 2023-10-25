class Star {
  float xPosition;
  float yPosition;
  float minimalSize;
  float maximalSize;
  float initialSize;
  float size;
  PShape starShape1;
  PShape starShape2;
  PGraphics layer;
  
  Star(float _xPosition, float _yPosition, float _minSize, float _maxSize) {
    xPosition = _xPosition;
    yPosition = _yPosition;
    minimalSize = _minSize;
    maximalSize = _maxSize;
    initialSize = random(minimalSize, maximalSize);
    size = initialSize;

    // starShape1 = loadShape("star/star1.svg");
    // starShape1.setFill(color(255,0,0));

    // starShape2 = loadShape("star/star1.svg");
    // starShape2.setFill(color(0,255,0));
    // starShape2.rotateZ(PI/4);
  }

  void display() {
    // layer.shape(starShape1, xPosition, yPosition);
    // layer.shape(starShape2, xPosition+50, yPosition);
    layer.fill(255);
    layer.noStroke();
    layer.circle(xPosition, yPosition, size);
  }

  void getLayer(PGraphics _layer) {
    layer = _layer;
  }

  void blink(float _period) {
    float periodOffset = map(initialSize, minimalSize, maximalSize, 0, TWO_PI);
    float period = cos((frameCount * _period) + periodOffset);
    size = map(period, -1, 1, minimalSize, maximalSize);
  }
}
