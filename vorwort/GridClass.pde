class Grid {
  int w;
  int h;
  PGraphics pg;
  
  int state = 3;
  
  static final int RANDOM_PATTERN = 0;
  static final int STEP = 1;
  static final int CHANCE = 2;
  static final int RANDOM_COMPOSITION = 3;
  static final int COMPOSITION = 4;
  
  JSONArray patterns;
  JSONObject jsonPattern = null;
  
  int currentPattern = 0;
  int patternIndex = 12;
  IntList patternLinear;

  Composition currentComposition = null;
  
  long timestamp = 0;
  long interval = 250;


  
  public Grid(int _w, int _h) {
    patterns = loadJSONArray("data/patterns.json");
    initPatternList();
    w = _w;
    h = _h;
    pg = createGraphics(w, h);
    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
  }
    
  void update() {
    
    switch(state) {
      
      case CHANCE:
        // 50:50 chance entweder in ein zufälliges pattern zu steuern oder ein set zu bekommen
        /*
          route 1: zufall
          - random_pattern
          - step /finite pool of images
          - chance
        */

        /*
          route 2: compositions
          - random_composition /finite pool of sets
          - composition
        */

      break;
      
      case RANDOM_PATTERN:
        // pick a new (random) pattern
        // shuffles the order on how the images are displayed
        delay(1000);
        if(patternIndex >= patternLinear.size()) {
          patternIndex = 0;
          currentPattern = (int)random(0, patterns.size()-1);
           
          jsonPattern = patterns.getJSONObject(currentPattern); 
          initPatternList();
        }
        state = STEP;
      break;
      
      case STEP:
        if(millis() - timestamp > interval) {
          if(patternIndex >= patternLinear.size()) {
            state = RANDOM_PATTERN;
            break;
          }
        
          timestamp = millis();
          int step = patternLinear.get(patternIndex);
          int x = (int)step%4;
          int y = (int)step/4;
          
          JSONArray column = jsonPattern.getJSONArray("c"+x);
          int[] values = column.getIntArray();
          int field = values[y];
         
          pg.beginDraw();
          
          // invert black pattern
          //field = (int)map(field, 0, 1, 1, 0);
          
          if(field == 1) {
            PImage n = getNextTile();
            if(n == null) {
              if(debug) {
                println();
                println("# tiles empty. refill pool.");
              }
              filesToTiles();
              n = getNextTile();

            }
            pg.image(n, x*pic_w, y*pic_h, pic_w*1, pic_h*1);
          } else {
            pg.push();
            pg.fill(0);
            pg.noStroke();
            pg.rect(x*pic_w, y*pic_h, pic_w*1, pic_h*1);
            pg.pop();
          }
          
          pg.endDraw();
          patternIndex++;
        }
        
        
      break;

      case RANDOM_COMPOSITION:
        // pick a new (random) composition
        getNextComposition();
        println("comps= "+ compositions.size());
        state = COMPOSITION;
      break;

      case COMPOSITION:
      break;
      
      
    }
  }
  
  void display() {
    pg.beginDraw();
    //for(int x = 1; x<=4; x++) pg.line(x*pic_w, 0, x*pic_w, height);
    //for(int y = 1; y<=3; y++) pg.line(0, y*pic_h, width, y*pic_h);
    
    //pg.image(tiles.get(0).getDisplay(), 0, 0, pic_w*1, pic_h*1);
    pg.endDraw();
    image(pg, 0, 0);
  }
  
  // shuffles the pattern so we can walk through it
  void initPatternList() {
    patternLinear = new IntList();
    for(int i = 0; i<12; i++) patternLinear.append(i);
    patternLinear.shuffle();
  }

  int getState() {
    return state;
  }

  void filesToTiles() {
    for(int i = 0; i<files.size(); i++) tiles.add(new Tile(i, "img/"+ files.get(i)));
  }

  void filesToCompositions() {
    for(int i = 0; i<sets.size(); i++) compositions.add(new Composition(i, "sets/"+ sets.get(i), patterns));
  }

PImage getNextTile() {
  PImage p = null;
  if(tiles.size() >= 2) { // wenn eine kleinste zufällige auswahl noch möglich ist
    int randomTile = (int)random(0, tiles.size()-1);
    if(debug) {
      print("available= "+ tiles.size() + " / ");
      println("random= "+ randomTile);
    }
    p = tiles.get(randomTile).getDisplay();
    tiles.remove(randomTile);
  }
  return p;
}

Composition getNextComposition() {
  Composition comp = null;
  if(compositions.size() >= 2) { // wenn eine kleinste zufällige auswahl noch möglich ist
    int randomComp = (int)random(0, compositions.size()-1);
    if(debug) {
      print("available= "+ compositions.size() + " / ");
      println("random= "+ randomComp);
    }
    comp = compositions.get(randomComp);
    compositions.remove(randomComp);
  }
  return comp;
}

// liste von dateien 
StringList initList(String path, String filetypes) {
  StringList list = new StringList();
  File folder = dataFile(path);
  File[] pics = folder.listFiles();
  Arrays.sort(pics);

  String[] types = split(filetypes, ",");
  if(types.length < 1) return null;

  String[] filenames = new String[pics.length];
  for (int i = 0; i < pics.length; filenames[i] = pics[i++].getPath());
  
  if(filenames.length > 0) {
    for(int i = 0; i< filenames.length; i++) {
      String[] splitter = split(filenames[i], '.');
      boolean correctType = false;
      for(int j = 0; j<types.length; j++) {
        if(splitter.length > 1 && splitter[1].equals(types[j])) {
          correctType = true;
          break;
        }
      }
      if(correctType) { 
        String[] absolutePath = split(filenames[i], '/');
        list.append(absolutePath[absolutePath.length-1]);
      }
    }
  }

  return list;
}
  
}
