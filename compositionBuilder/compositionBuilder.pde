import drop.*;
SDrop drop;
PFont font;  
  
int pic_w = 480;
int pic_h = 320;

float px = 0;      // point position (move with mouse)
float py = 0;

ArrayList<Tile> tiles = new ArrayList<Tile>();

boolean debug = true;

int currentPattern = 0;
JSONArray patterns;
JSONObject jsonPattern = null;

void setup() {
  size(1920, 1080);
  
  drop = new SDrop(this);
  
  pic_w = width/4;
  pic_h = height/3;
  
  for(int i = 0; i<12; i++) {
    int x = (int)i%4;
    int y = (int)i/4;
    tiles.add(new Tile(i, x*pic_w, y*pic_h));
    drop.addDropListener(tiles.get(i));
  }
  
  font = loadFont("fonts/Iosevka-Term-11.vlw");
  textFont(font, 11);
  
  patterns = loadJSONArray("data/patterns.json");
  jsonPattern = patterns.getJSONObject(currentPattern); 
}

void draw() {
 background(255);
 px = mouseX;
 py = mouseY;
 
  for (Tile tile : tiles) {
   tile.update();
   tile.display();
  }
  
  for(int x = 1; x<=4; x++) line(x*pic_w, 0, x*pic_w, height);
  for(int y = 1; y<=3; y++) line(0, y*pic_h, width, y*pic_h);
  
  if(debug) {
    push();
    noStroke();
    fill(255, 255, 0);
    rect(0, 0, 120, 40);
    fill(0);
    text("currentPattern=" + currentPattern, 10, 20);
    //text("state=", 10, 30);
    pop();
  }
}

void export() {
  println("# Export");
}

boolean pointRect(float px, float py, float rx, float ry, float rw, float rh) {

  // is the point inside the rectangle's bounds?
  if (px >= rx &&        // right of the left edge AND
      px <= rx + rw &&   // left of the right edge AND
      py >= ry &&        // below the top AND
      py <= ry + rh) {   // above the bottom
        return true;
  }
  return false;
}

void dropEvent(DropEvent theDropEvent) {}
