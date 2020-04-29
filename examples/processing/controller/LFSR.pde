//-------------LFSR CLASS-------------

class LFSR {
  int reg;
  int rate = 4;
  int tap1 = 31; 
  int tap2 = 30;
  boolean tap1en;
  boolean tap2en;
  boolean mode; // false = recirc only, true = lfsr

  LFSR() {
    reg = 1;
  }

  void update() {
    if (frameCount % rate == 0) {

      if (mode) {
        tap1en = true;
        tap2en = true;
      } else {
        tap1en = true;
        tap2en = false;
      }

      reg = (reg << 1) | (int(tap1en) & (reg >> tap1 & 1)) ^ (int(tap2en) & (reg >> tap2 & 1));
    }
  }

  void incRate() {
    if (rate < 10) rate++;
  }
  void decRate() {
    if (rate > 1) rate--;
  }

  void incTap2() {
    if (tap2 < lightsMax-1) tap2++;
  }
  void decTap2() {
    if (tap2 > 0) tap2--;
  }

  void randomize() {
    for (int i = 0; i < lightsMax; i++) {
      reg |= int(random(2)) << i;
    }
  }

  void setMode(boolean _mode) {
    mode=_mode;
  }

  boolean bit(int _bit) {
    return boolean(reg >> _bit & 1);
  }
}
