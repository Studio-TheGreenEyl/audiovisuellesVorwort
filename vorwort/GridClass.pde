class Grid {
  ArrayList<Tile> tiles = new ArrayList<Tile>();
  ArrayList<Composition> compositions = new ArrayList<Composition>();
  int w;
  int h;
  PGraphics pg;
  
  int state = CHANCE;
  
  static final int RANDOM_PATTERN = 0;
  static final int STEP = 1;
  static final int CHANCE = 2;
  static final int RANDOM_COMPOSITION = 3;
  static final int COMPOSITION = 4;
  
  JSONArray patterns;
  JSONObject jsonPattern = null;

  StringList files = new StringList();
  StringList sets = new StringList();
  
  int currentPattern = 0;
  Tile currentTile = null;
  Tile blackTile = null;
  int patternIndex = 12;
  IntList patternLinear;

  Composition currentComposition = null;
  
  long timestamp = 0;
  long interval = 2000;

  int compositionCounter = 0;
  int chanceMaximum = 4;
  int chanceCounter = chanceMaximum; // 20% anfangschance

  boolean nextImage = true;

  
  public Grid(int _w, int _h) {
    patterns = loadJSONArray("data/patterns.json");
    initPatternList();
    w = _w;
    h = _h;
    pg = createGraphics(w, h);
    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
    blackTile = new Tile(9999999, "assets/blackTile.jpg");
  }
    
  void update() {
    
    switch(state) {
      
      case CHANCE:
        if(millis() - timestamp < interval) return;
        timestamp = millis();
        int random = (int)random(0, chanceCounter);
        if(debug) print("chanceCounter=" + chanceCounter + " / random= "+ random + " / ");
        chanceCounter--;

        if(random == 0) {
          chanceCounter = chanceMaximum;
          state = RANDOM_COMPOSITION;
          break;
        } else {
          if(debug) println("random");
        }

        if(chanceCounter < 0) {
          chanceCounter = chanceMaximum;
          if(debug) println();
          
        }
        state = RANDOM_PATTERN;
      break;
      
      case RANDOM_PATTERN:
        // pick a new (random) pattern
        // shuffles the order on how the images are displayed
        if(millis() - timestamp < interval) return;
        timestamp = millis();

        if(patternIndex >= patternLinear.size()) {
          patternIndex = 0;
          currentPattern = (int)random(0, patterns.size()-1);
           
          jsonPattern = patterns.getJSONObject(currentPattern); 
          initPatternList();
        }
        state = STEP;
      break;
      
      case STEP:
        if(patternIndex >= patternLinear.size()) {
          state = CHANCE;
          break;
        }
      
        int step = patternLinear.get(patternIndex);
        int x = (int)step%4;
        int y = (int)step/4;

        int field = getPatternCell(x, y);
        pg.beginDraw();
        
        // invert black pattern
        //field = (int)map(field, 0, 1, 1, 0);
        
        if(field == 1) {
          if(currentTile == null) {
            PImage n = getNextTile();
            if(n == null) {
              if(debug) {
                println();
                println("# tiles empty. refill pool.");
              }
              filesToTiles();
              n = getNextTile();
            }
          }

          if(currentTile != null) {
            currentTile.fade();
            float opacity = currentTile.getOpacity();
            pg.tint(255, opacity);
            pg.image(currentTile.getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
            
            if(opacity >= 255) {
              nextImage = true;
            }
          }
          
        } else {
          blackTile.fade();
          float opacity = blackTile.getOpacity();
          pg.tint(255, opacity);
          pg.image(blackTile.getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
          
          if(opacity >= 255) {
            nextImage = true;
          }
        }
        
        pg.endDraw();
        if(nextImage) {
          patternIndex++;
          nextImage = false;
          blackTile.resetOpacity();
          currentTile = null;
        }        
      break;

      case RANDOM_COMPOSITION:
        // pick a new (random) composition
        if(debug) println("pick a new (random) composition");
        if(millis() - timestamp < interval) return;
        timestamp = millis();

        if(compositionCounter <= 0) {
          filesToCompositions();
        }
        currentComposition = getNextComposition();
        if(debug) {
          println("compCounter= " + compositionCounter);
          println("compsSize= "+ compositions.size());
          println("comp_id= " + currentComposition.getID());
        }
        state = COMPOSITION;
      break;

      case COMPOSITION:
        if(currentComposition == null) {
          state = RANDOM_COMPOSITION;
          break;
        }
        //println("updating");
        currentComposition.update();
        if(currentComposition.isFinished()) {
          compositionCounter--;
          state = CHANCE;
          break;
        }
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

  int getPatternCell(int x, int y) {
    JSONArray column = jsonPattern.getJSONArray("c"+x);
    int[] values = column.getIntArray();
    int field = values[y];
    return field;
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
    compositionCounter = sets.size();
    compositions = new ArrayList<Composition>();
    for(int i = 0; i<sets.size(); i++) compositions.add(new Composition(i, "sets/"+ sets.get(i), patterns, pg));
  }

  void init(String path0, String filetypes0, String path1, String filetypes1) {
    files = grid.initList(path0, filetypes0);
    sets = grid.initList(path1, filetypes1);
    if(files == null) { println("ERROR= no images found. please check /data/img"); exit(); }
    if(sets == null) { println("ERROR= no sets found. please check /data/sets"); exit(); }

    filesToTiles();
    filesToCompositions();
  }

  PImage getNextTile() {
    PImage p = null;
    if(tiles.size() >= 2) { // wenn eine kleinste zufällige auswahl noch möglich ist
      int randomTile = (int)random(0, tiles.size()-1);
      if(debug) {
        print("available= "+ tiles.size() + " / ");
        println("random= "+ randomTile);
      }
      currentTile = tiles.get(randomTile);
      p = currentTile.getDisplay();

      tiles.remove(randomTile);
    }
    return p;
  }

  Composition getNextComposition() {
    Composition comp = null;
    if(sets.size() == 1 || compositions.size() == 1) {
      // anscheinend gibt es nur eine datei. diese benutzen wir dann
      comp = compositions.get(0);
    } else if(compositions.size() >= 2) { // wenn eine kleinste zufällige auswahl noch möglich ist
      int randomComp = (int)random(0, compositions.size()-1);
      if(debug) {
        print("available= "+ compositions.size() + " / ");
        println("random= "+ randomComp);
        println();
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

  int getTilesSize() {
    return tiles.size();
  }
  
}
