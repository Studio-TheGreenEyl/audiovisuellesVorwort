class Grid {
  int w;
  int h;
  PGraphics pg;
  
  int state = 0;
  
  static final int PATTERN = 0;
  static final int STEP = 1;
  static final int DEMO2 = 2;
  static final int DEMO3 = 3;
  static final int DEMO4 = 4;
  
  JSONArray patterns;
  JSONObject jsonPattern = null;
  
  int currentPattern = 0;
  int patternIndex = 12;
  IntList patternLinear;
  boolean blackPatterns[][][] = 
    {
      {
        {false, true, false},
        {true, false, true},
        {false, true, false},
        {true, false, true}
      },
      {
        {true, false, true},
        {true, true, false},
        {false, false, true},
        {true, true, false}
      }
    }  
  ;
  
  
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
  
  void initPatternList() {
    patternLinear = new IntList();
    for(int i = 0; i<12; i++) patternLinear.append(i);
    patternLinear.shuffle();
  }
  
  void update() {
    
    switch(state) {
      
      case PATTERN:
        // pick a new pattern
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
            state = PATTERN;
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
            pg.image(tiles.get((int)random(0, tiles.size()-1)).getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
          }
          else {
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
  
}
