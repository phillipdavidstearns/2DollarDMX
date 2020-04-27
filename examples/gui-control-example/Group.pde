//-------------GROUP CLASS-------------

class Group {
  PVector pos;
  float r = 80;
  float d = 2*r;
  String name;
  boolean selected = false;

  Group(PVector _pos, String _name) {
    pos = _pos;
    name = _name;
  }

  void update() {
    display();
  }

  void display() {

    color txt, stroke, fill;

    if (!selected) {
      stroke = 127;
      fill = 0;
      txt = 255;
    } else {
      stroke = 127;
      fill = 63;
      txt = 127;
    }


    strokeWeight(2);

    stroke(stroke);
    fill(fill);
    ellipse(pos.x, pos.y, d, d);

    fill(txt);
    textAlign(CENTER, CENTER);
    text(name, pos.x, pos.y);
  }

  boolean isSelected() {
    return selected;
  }

  boolean inRadius(PVector _pos) {
    return (PVector.dist(_pos, pos) < r);
  }

  boolean inRadius(float _x, float _y) {
    return (PVector.dist(new PVector(_x, _y), pos) < r);
  }
}
