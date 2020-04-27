//-------------CA CLASS-------------
class CA {
  int reg = 1;
  byte rules = 0;
  int bitDepth = lightsMax;
  int rate = 4;

  CA() {
    randomizeRules();
  }

  void randomizeRules() {
    rules = byte(int(random(pow(2, 8))));
  }

  void randomizeRegister() {
    reg = int(random(pow(2, bitDepth)));
  }

  void update() { 
    if (frameCount % rate == 0) reg = applyRules();
  }

  void incRate() {
    if (rate < 10) rate++;
  }
  void decRate() {
    if (rate > 1) rate--;
  }


  int applyRules() {
    int result = 0;
    for (int i = 0; i < bitDepth; i++) {
      int state = 0;
      for (int n = 0; n < 3; n++) {
        int coord = ((i + bitDepth + (n-1)) % bitDepth);
        state |= (reg >> coord & 1) << (2-n);
      }  
      result |= ((rules >> state) & 1) << i;
    }
    return result;
  }

  boolean cellState(int _cell) {
    return boolean(reg >> _cell & 1);
  }
}
