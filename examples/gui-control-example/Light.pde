//-------------LIGHT CLASS-------------

class Light {
  PVector pos;
  float r = 50;
  float d = 2*r;
  int id;
  boolean selected = false, toggle = false, logic = false;
  boolean[] member = new boolean[group.length];

  Light(PVector _pos, int _id) {
    pos = _pos;
    id = _id;
  }

  void applyLogic(boolean _logic) {
    logic |= _logic;
  }

  void update() {
    logic = false;
    applyLogic(toggle);
    ringLogic();
    lineLogic();
    groupLogic();
    if (editMode) mouseLogic();
    if (random) randomLogic();
    if (allOn) applyLogic(true);
    if (caOn) applyLogic(ca.cellState(id));
    if (lfsrOn) applyLogic(lfsr.bit(id));
    display();
  }

  void groupLogic() {
    for (int i = 0; i < group.length; i++) {
      applyLogic(member[i] & group[i]);
    }
  }

  void display() {

    color txt, stroke, fill;

    if (!selected) {
      if (isOn()) {
        stroke = 0;
        fill = 255;
        txt = 0;
      } else {
        stroke = 255;
        fill = 0;
        txt = 255;
      }
    } else {
      if (isOn()) {
        stroke = 0;
        fill = 127;
        txt = 0;
      } else {
        stroke = 127;
        fill = 0;
        txt = 127;
      }
    }

    strokeWeight(2);

    stroke(stroke);
    fill(fill);
    ellipse(pos.x, pos.y, d, d);

    fill(txt);
    textAlign(CENTER, CENTER);
    text(id+1, pos.x, pos.y);
  }

  boolean inRadius(PVector _pos) {
    return (PVector.dist(_pos, pos) < r);
  }

  boolean inRadius(float _x, float _y) {
    return (PVector.dist(new PVector(_x, _y), pos) < r);
  }

  boolean isSelected() {
    return selected;
  }

  boolean isOn() {
    return inverted ^ logic;
  }

  boolean memberOf(int _group) {
    return member[_group];
  }


  void ringLogic() {
    for (Ring ring : rings) {
      float dist = PVector.dist(ring.pos, pos);
      applyLogic((dist - ring.r) < r && ring.r < (dist + r));
    }
  }

  void lineLogic() {
    for (Line line : lines) {
      if (line.hv) {
        applyLogic(PVector.dist(new PVector(pos.x, line.pos.y), pos) < r);
      } else {
        applyLogic(PVector.dist(new PVector(line.pos.x, pos.y), pos) < r);
      }
    }
  }

  void mouseLogic() {
    applyLogic(inRadius(mouseX, mouseY));
  }

  void randomLogic() {
    applyLogic(!boolean(int(random(10))));
  }
}
