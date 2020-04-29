//-------------RING CLASS-------------

class Ring {
  PVector pos;
  float r = 0;
  float rate = 25;

  Ring(float _x, float _y) {
    pos = new PVector(_x, _y);
  }

  Ring(PVector _pos) {
    pos = _pos;
  }

  void update() {
    strokeWeight(2);
    if (!inverted) {
      stroke(255);
    } else {
      stroke(0);
    }
    noFill();
    ellipse(pos.x, pos.y, 2*r, 2*r);
    r+=rate;
  }

  boolean isDone() {
    return (r > sqrt(pow(width, 2)+pow(height, 2)));
  }
}
