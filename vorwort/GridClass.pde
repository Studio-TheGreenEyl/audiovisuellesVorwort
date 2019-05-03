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
  
  public Grid(int _w, int _h) {
    initPatternList();
    w = _w;
    h = _h;
    pg = createGraphics(w, h);
    pg.beginDraw();
    pg.background(255);
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
        if(patternIndex >= patternLinear.size()) {
          patternIndex = 0;
          currentPattern = (int)random(0, blackPatterns.length);
          initPatternList();
          pg.beginDraw();
          pg.background(0);
          pg.endDraw();
        }
        state = STEP;
      break;
      
      case STEP:
        if(patternIndex >= patternLinear.size()) {
          state = PATTERN;
          break;
        }
        int step = patternLinear.get(patternIndex);
        int x = (int)step%4;
        int y = (int)step/4;
        
        //println("x= "+ x +" | y=" + y);
        boolean empty = blackPatterns[currentPattern][x][y];
        pg.beginDraw();
        if(!empty) pg.image(tiles.get((int)random(0, tiles.size()-1)).getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
        pg.endDraw();
        patternIndex++;
        
      break;
      
      
    }
  }
  
  void display() {
    pg.beginDraw();
    for(int x = 1; x<=4; x++) pg.line(x*pic_w, 0, x*pic_w, height);
    for(int y = 1; y<=3; y++) pg.line(0, y*pic_h, width, y*pic_h);
    
    //pg.image(tiles.get(0).getDisplay(), 0, 0, pic_w*1, pic_h*1);
    pg.endDraw();
    image(pg, 0, 0);
  }
  
}
