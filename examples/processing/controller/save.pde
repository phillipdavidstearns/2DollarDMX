// output positions of lights to settings.csv
void saveSettings() {
  Table settings = new Table();

  //save lights
  settings.addColumn("id");
  settings.addColumn("x");
  settings.addColumn("y");
  for (int i = 0; i < group.length; i++) {
    settings.addColumn("group"+(i+1));
  }


  for (Light light : lights) {
    TableRow newRow = settings.addRow();
    newRow.setInt("id", light.id);
    newRow.setFloat("x", light.pos.x);
    newRow.setFloat("y", light.pos.y);
    for (int i = 0; i < group.length; i++) {
      newRow.setInt("group"+(i+1), int(light.memberOf(i)));
    }
  }
  saveTable(settings, "./data/lights.csv");

  //save groups
  settings = new Table();
  settings.addColumn("name");
  settings.addColumn("x");
  settings.addColumn("y");

  for (Group group : groups) {
    TableRow newRow = settings.addRow();
    newRow.setString("name", group.name);
    newRow.setFloat("x", group.pos.x);
    newRow.setFloat("y", group.pos.y);
  }
  saveTable(settings, "./data/groups.csv");
}

//load positions of lights into ArrayList
void loadSettings() {
  Table settings = loadTable("./data/lights.csv", "header");
  if (settings != null) {
    //initialize ArrayList
    lights = new ArrayList<Light>();
    lightCount=0;

    for (int i = 0; i < settings.getRowCount(); i++) {
      TableRow row = settings.getRow(i);
      lights.add(new Light(new PVector(row.getFloat("x"), row.getFloat("y")), row.getInt("id")));
      for (int j = 0; j < group.length; j++) {
        lights.get(i).member[j] = boolean(row.getInt("group"+(j+1)));
      }
      lightCount++;
    }
  } else {
    println("Couldn't load light presets from file.");
  }

  if (settings != null) {
    groups = new ArrayList<Group>();
    groupCount=0;

    settings = loadTable("./data/groups.csv", "header");

    for (TableRow row : settings.rows()) {
      groups.add(new Group(new PVector(row.getFloat("x"), row.getFloat("y")), row.getString("name")));
      groupCount++;
    }
  } else {
    println("Couldn't load group presets from file.");
  }
}
