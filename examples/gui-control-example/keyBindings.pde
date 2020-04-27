void halp   () {
  /*
Key Mappings:
   
   E                    toggle edit/performance mode
   h                    toggle help overlay ** not yet made!!! ***
   
   *** Edit Mode
   
   ALT+Click            Add a Light to lights
   SHIFT+Click+Drag     Move selected Light(s) 
   DELETE or BACKSPACE  Remove Light in reverse order of placement
   S                    Save positions of lights to settings.csv
   L                    Clears current light configuration and loads lights from settings.csv
   
   *** Perfomance Mode ***
   
   r                    Creates a Ring that expands outwards to trigger lights
   UP                   Creates a Line that moves from bottom to top of screen to trigger lights
   DOWN                 Creates a Line that moves from top to bottom of screen to trigger lights
   LEFT                 Creates a Line that moves from left to right of screen to trigger lights 
   RIGHT                Creates a Line that moves from right to left of screen to trigger lights
   z                    Turns random light flickering on and off (temporary)
   x                    Turns random light toggle switches on and off (holds after press)
   c                    Clears light toggles
   i                    Inverts all light states
   SPACE                Turns all light toggles on/off
   
   *** Cellular Autoamta (CA) Mode *** 
   
   a                    Toggle cellular automata (CA) mode
   s                    Randomizes CA rules
   d                    Randomizes the cell states
   f                    Reset cell states to 1
   ,                    Increase the rate of the CA evolution
   .                    Decrese the rate of CA evolution
   
   *** Linear Feedback Shift Register(LFSR) Mode ***
   
   l                    Toggle Linear Feedback Shift Register(LFSR) Mode
   k                    Toggle recirculation
   j                    Randomize the register
   J                    Set register to 1
   '                    Increase speed
   ;                    Decrese speed
   "                    Increment Tap 2
   ;                    Decrement Tap 2
   
   */
  /*
  case 'l':
   lfsrOn = !lfsrOn;
   break;
   case 'k': //toggle recirculation vs linear feedback shift register mode
   lfsr.mode = !lfsr.mode;
   break;
   case 'j':
   lfsr.randomize();
   break;
   case 'J':
   lfsr.reg = 1;
   break;
   case ';': // slow it down
   lfsr.incRate();
   break;
   case ''': // speed it up
   lfsr.decRate();
   break;
   case ':':
   lfsr.decTap2();
   break;
   case '"':
   lfsr.incTap2();
   break;
   */
}

void keyPressed() {
  if (key == '\\') manual = !manual;

  if (manual) {
    switch(key) {
    case '1': // Save position of lights into settings.csv
      lights.get(0).toggle = true;
      break;
    case '2': // Save position of lights into settings.csv
      lights.get(1).toggle = true;
      break;
    case '3': // Save position of lights into settings.csv
      lights.get(2).toggle = true;
      break;
    case '4': // Save position of lights into settings.csv
      lights.get(3).toggle = true;
      break;
    case '5': // Save position of lights into settings.csv
      lights.get(4).toggle = true;
      break;
    case '6': // Save position of lights into settings.csv
      lights.get(5).toggle = true;
      break;
    case '7': // Save position of lights into settings.csv
      lights.get(6).toggle = true;
      break;
    case '8': // Save position of lights into settings.csv
      lights.get(7).toggle = true;
      break;

    case 'q': // Save position of lights into settings.csv
      lights.get(8).toggle = true;
      break;
    case 'w': // Save position of lights into settings.csv
      lights.get(9).toggle = true;
      break;
    case 'e': // Save position of lights into settings.csv
      lights.get(10).toggle = true;
      break;
    case 'r': // Save position of lights into settings.csv
      lights.get(11).toggle = true;
      break;
    case 't': // Save position of lights into settings.csv
      lights.get(12).toggle = true;
      break;
    case 'y': // Save position of lights into settings.csv
      lights.get(13).toggle = true;
      break;
    case 'u': // Save position of lights into settings.csv
      lights.get(14).toggle = true;
      break;
    case 'i': // Save position of lights into settings.csv
      lights.get(15).toggle = true;
      break;

    case 'a': // Save position of lights into settings.csv
      lights.get(16).toggle = true;
      break;
    case 's': // Save position of lights into settings.csv
      lights.get(17).toggle = true;
      break;
    case 'd': // Save position of lights into settings.csv
      lights.get(18).toggle = true;
      break;
    case 'f': // Save position of lights into settings.csv
      lights.get(19).toggle = true;
      break;
    case 'g': // Save position of lights into settings.csv
      lights.get(20).toggle = true;
      break;
    case 'h': // Save position of lights into settings.csv
      lights.get(21).toggle = true;
      break;
    case 'j': // Save position of lights into settings.csv
      lights.get(22).toggle = true;
      break;
    case 'k': // Save position of lights into settings.csv
      lights.get(23).toggle = true;
      break;

    case 'z': // Save position of lights into settings.csv
      lights.get(24).toggle = true;
      break;
    case 'x': // Save position of lights into settings.csv
      lights.get(25).toggle = true;
      break;
    case 'c': // Save position of lights into settings.csv
      lights.get(26).toggle = true;
      break;
    case 'v': // Save position of lights into settings.csv
      lights.get(27).toggle = true;
      break;
    case 'b': // Save position of lights into settings.csv
      lights.get(28).toggle = true;
      break;
    case 'n': // Save position of lights into settings.csv
      lights.get(29).toggle = true;
      break;
    case 'm': // Save position of lights into settings.csv
      lights.get(30).toggle = true;
      break;
    case ',': // Save position of lights into settings.csv
      lights.get(31).toggle = true;
      break;
    }
  } else {

    switch(key) {

    case 'S': // Save position of lights into settings.csv
      saveSettings();
      break;
    case 'L':
      if (editMode)loadSettings();
      break;
    case 'E': // TOGGLE EDITMODE
      editMode = !editMode;
      println("Edit mode: "+editMode);
      break;
    case 'r': //ADD A RING
      rings.add(new Ring(mouseX, mouseY));
      break;
    case 'z': // sparkle mode!
      random=!random;
      break;
    case 'x': // turns on a random selection of lights
      for (Light light : lights) {
        light.toggle=!boolean(int(random(10)));
      }
      break;
    case 'c': // turns off all lights!
      allOn=false;
      for (Light light : lights) {
        light.toggle=false;
      }
      for (int i  = 0; i < group.length; i++) {
        group[i]=false;
      }
      break;
    case 'i': // inverts the state of all lights
      inverted = !inverted;
      break;

      //cellular automata interaction  
    case 'a': // toggle cellular automata display
      caOn = !caOn; 
      break;
    case 's':
      ca.randomizeRules();
      break;
    case 'd':
      ca.randomizeRegister();
      break;
    case 'f':
      ca.reg=1;
      break;
    case ',': // slows down movement of CA animation
      ca.incRate();
      break;
    case '.': // speeds up movement of CA animation
      ca.decRate();
      break;

      //lfsr rules
    case 'l':
      lfsrOn = !lfsrOn;
      break;
    case 'k': //toggle recirculation vs linear feedback shift register mode
      lfsr.mode = !lfsr.mode;
      break;
    case 'j':
      lfsr.randomize();
      break;
    case 'J':
      lfsr.reg = 1;
      break;
    case ';': // slow it down
      lfsr.incRate();
      break;
    case '\'': // speed it up
      lfsr.decRate();
      break;
    case ':':
      lfsr.decTap2();
      break;
    case '"':
      lfsr.incTap2();
      break;
    }

    if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
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
      if (editMode) {
        for (Light light : lights) {
          light.selected = light.memberOf(keyNumber-1);
        }
      } else {
        group[keyNumber-1]=!group[keyNumber-1];
      }
    } else if (key == '!' || key == '@' || key == '#' || key == '$' || key == '%' || key == '^') {
      int keyNumber=0;
      switch (key) {
      case '!':
        keyNumber=1;
        break;
      case '@':
        keyNumber=2;
        break;
      case '#':
        keyNumber=3;
        break;
      case '$':
        keyNumber=4;
        break;
      case '%':
        keyNumber=5;
        break;
      case '^':
        keyNumber=6;
        break;
      }
      if (editMode) {
        for (Light light : lights) {
          light.member[keyNumber-1] = false;
        }
      } else {
        group[keyNumber-1]=!group[keyNumber-1];
      }
    }
  }

  // FOR ADDING LINES 
  switch(keyCode) {
  case UP:
    lines.add(new Line(true, false));
    break;
  case DOWN:
    lines.add(new Line(true, true));
    break;
  case LEFT:
    lines.add(new Line(false, false));
    break;
  case RIGHT:
    lines.add(new Line(false, true));
    break;

    // turning all lights on - to turn all on and off, press SPACE then 'c'  
  case 32:
    allOn=true;
    break;
  }


  if (editMode) {

    //Use DELETE or BACKSPACE key's to delete the last light added
    if (key == DELETE || key == BACKSPACE && lightCount > 0) {
      lights.remove(lightCount-1);
      lightCount--;
    }

    //logic for selecting/deselecting Light objects
    if (keyCode == SHIFT) {
      for (Light light : lights) {
        light.selected = light.inRadius(mouseX, mouseY);
      }
      for (Group group : groups) {
        group.selected = group.inRadius(mouseX, mouseY);
      }
    }
  }
} // keyPressed

void keyReleased() {

  if (manual) {
    switch(key) {
    case '1': // Save position of lights into settings.csv
      lights.get(0).toggle = false;
      break;
    case '2': // Save position of lights into settings.csv
      lights.get(1).toggle = false;
      break;
    case '3': // Save position of lights into settings.csv
      lights.get(2).toggle = false;
      break;
    case '4': // Save position of lights into settings.csv
      lights.get(3).toggle = false;
      break;
    case '5': // Save position of lights into settings.csv
      lights.get(4).toggle = false;
      break;
    case '6': // Save position of lights into settings.csv
      lights.get(5).toggle = false;
      break;
    case '7': // Save position of lights into settings.csv
      lights.get(6).toggle = false;
      break;
    case '8': // Save position of lights into settings.csv
      lights.get(7).toggle = false;
      break;

    case 'q': // Save position of lights into settings.csv
      lights.get(8).toggle = false;
      break;
    case 'w': // Save position of lights into settings.csv
      lights.get(9).toggle = false;
      break;
    case 'e': // Save position of lights into settings.csv
      lights.get(10).toggle = false;
      break;
    case 'r': // Save position of lights into settings.csv
      lights.get(11).toggle = false;
      break;
    case 't': // Save position of lights into settings.csv
      lights.get(12).toggle = false;
      break;
    case 'y': // Save position of lights into settings.csv
      lights.get(13).toggle = false;
      break;
    case 'u': // Save position of lights into settings.csv
      lights.get(14).toggle = false;
      break;
    case 'i': // Save position of lights into settings.csv
      lights.get(15).toggle = false;
      break;

    case 'a': // Save position of lights into settings.csv
      lights.get(16).toggle = false;
      break;
    case 's': // Save position of lights into settings.csv
      lights.get(17).toggle = false;
      break;
    case 'd': // Save position of lights into settings.csv
      lights.get(18).toggle = false;
      break;
    case 'f': // Save position of lights into settings.csv
      lights.get(19).toggle = false;
      break;
    case 'g': // Save position of lights into settings.csv
      lights.get(20).toggle = false;
      break;
    case 'h': // Save position of lights into settings.csv
      lights.get(21).toggle = false;
      break;
    case 'j': // Save position of lights into settings.csv
      lights.get(22).toggle = false;
      break;
    case 'k': // Save position of lights into settings.csv
      lights.get(23).toggle = false;
      break;

    case 'z': // Save position of lights into settings.csv
      lights.get(24).toggle = false;
      break;
    case 'x': // Save position of lights into settings.csv
      lights.get(25).toggle = false;
      break;
    case 'c': // Save position of lights into settings.csv
      lights.get(26).toggle = false;
      break;
    case 'v': // Save position of lights into settings.csv
      lights.get(27).toggle = false;
      break;
    case 'b': // Save position of lights into settings.csv
      lights.get(28).toggle = false;
      break;
    case 'n': // Save position of lights into settings.csv
      lights.get(29).toggle = false;
      break;
    case 'm': // Save position of lights into settings.csv
      lights.get(30).toggle = false;
      break;
    case ',': // Save position of lights into settings.csv
      lights.get(31).toggle = false;
      break;
    }
  } else {
    PVector mouse = new PVector(mouseX, mouseY);
    //logic for selecting/deselecting Light objects
    if (editMode && keyCode == SHIFT || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
      for (Light light : lights) {
        if (light.isSelected() || light.inRadius(mouse)) {
          light.selected = false;
        }
      }
      for (Group group : groups) {
        if (group.isSelected() || group.inRadius(mouse)) {
          group.selected = false;
        }
      }
    } else if (keyCode == 32) {
      allOn=false;
    }

    switch(key) {
    case '1': //KEYS
      if (editMode) { // displays which lights are assigned to group
        for (Light light : lights) {
          light.selected = false;
        }
      } else { // turns on lights assigned to group
        group[0]=false;
      }
      break;
    case '2': //DRUMS
      if (editMode) {
        for (Light light : lights) {
          light.selected = false;
        }
      } else {
        group[1]=false;
      }
      break;
    case '3': //VOCALS
      if (editMode) {
        for (Light light : lights) {
          light.selected = false;
        }
      } else {  
        group[2]=false;
      }
      break;
    case '4': //GUITAR
      if (editMode) {
        for (Light light : lights) {
          light.selected = false;
        }
      } else {  
        group[3]=false;
      }
      break;
    case '5': //BASS
      if (editMode) {
        for (Light light : lights) {
          light.selected = false;
        }
      } else {  
        group[4]=false;
      }
      break;
    case '6': //Between Songs
      if (editMode) {
        for (Light light : lights) {
          light.selected = false;
        }
      } else {  
        group[5]=false;
      }
      break;
    }
  }
} // keyReleased
