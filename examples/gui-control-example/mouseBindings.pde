void mousePressed() {

  PVector mouse = new PVector(mouseX, mouseY);

  if (editMode) { // logic for edit mode interaction with Light objects
    if (keyPressed && keyCode == ALT) { // logic for adding a Light 
      boolean lightClicked = false;
      for (Light light : lights) {
        lightClicked |= light.inRadius(mouse);
      } 
      if (!lightClicked && lightCount<32) { // don't add a new Light on top of an old one 
        lights.add(new Light(mouse, lightCount));
        lightCount++;
      }
    } else if (keyPressed && keyCode == CONTROL) { //logic for adding a Group
      boolean clicked = false;
      for (Group group : groups) {
        clicked |= group.inRadius(mouse);
      } 
      if (!clicked && groupCount<5) { // don't add a new Group on top of an old one 
        groups.add(new Group(mouse, groupNames[groupCount]));
        groupCount++;
      }
    } else if (keyPressed && (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6')) {
      int keyNumber=0;
      switch (key) {
      case '1':
        keyNumber=1;
        break;
      case '2':
        keyNumber=2;
        break;
      case '3':
        keyNumber=3;
        break;
      case '4':
        keyNumber=4;
        break;
      case '5':
        keyNumber=5;
        break;
      case '6':
        keyNumber=6;
        break;
      }
      for (Light light : lights) {
        if (light.inRadius(mouse)) {
          light.member[keyNumber-1] = !light.member[keyNumber-1];
          light.selected = light.member[keyNumber-1];
        }
      }
    } else if (!keyPressed) { // logic for toggling Light objects on and off
      for (Light light : lights) {
        if (light.inRadius(mouse)) light.toggle = !light.toggle;
      }
    }
  } else {
    rings.add(new Ring(mouse));
  }
} // mousePressed

void mouseMoved() {

  //logic for selecting/deselecting Light objects
  if (editMode && keyPressed && keyCode == SHIFT) {
    for (Light light : lights) {
      light.selected = light.inRadius(mouseX, mouseY);
    }
    for (Group group : groups) {
      group.selected = group.inRadius(mouseX, mouseY);
    }
  }
} // mouseMoved

void mouseDragged() {

  //logic for moving Light objects that have been selected
  if (editMode) {
    for (Light light : lights) {
      if (light.isSelected()) {
        light.pos.x+=mouseX-pmouseX;
        light.pos.y+=mouseY-pmouseY;
      }
    }
    for (Group group : groups) {
      if (group.isSelected()) {
        group.pos.x+=mouseX-pmouseX;
        group.pos.y+=mouseY-pmouseY;
      }
    }
  }
} // mouseDragged
