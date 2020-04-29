//-------------LINE CLASS-------------

class Line {
  PVector pos = new PVector(0, 0);
  float rate = 25;
  boolean hv;  // horizontal or vertical orientation, true = horizontal, false = vertical
  boolean dir; // direction of movement, true left to right / top to bottom, false right to left / bottom to top

  Line(boolean _hv, boolean _dir) {
    hv = _hv;
    dir = _dir;

    if (hv && dir || !hv && dir) {
      pos.y = 0;
      pos.x = 0;
    } else if (hv && !dir) {
      pos.y = height-1;
      pos.x = 0;
    } else if (!hv && !dir) {
      pos.y = 0;
      pos.x = width-1;
    }
  }

  void update() {
    strokeWeight(2);
    if (!inverted) {
      stroke(255);
    } else {
      stroke(0);
    }
    noFill();

    if (hv && dir || !hv && dir) {
      pos.y += rate;
      pos.x += rate;
    } else if (hv && !dir) {
      pos.y -= rate;
      pos.x = 0;
    } else if (!hv && !dir) {
      pos.y = 0;
      pos.x -= rate;
    }

    if (hv) {
      line(0, pos.y, width-1, pos.y);
    } else {
      line(pos.x, 0, pos.x, height-1);
    }
  }

  boolean isDone() {
    if (hv && dir) {
      return pos.y >= height-1;
    } else if (hv && !dir) {
      return pos.y <= 0;
    } else if (!hv && dir) {
      return pos.x >= width-1;
    } else if (!hv && !dir) {
      return pos.x <= 0;
    } else {
      return true;
    }
  }
}
