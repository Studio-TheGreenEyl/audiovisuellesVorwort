class Tile {
  // digitale operationen die das original *nicht* kann
  boolean invertColors = false;
  boolean flip = false;
  int rotate = 0;
  
  int id;
  PImage p;
  int x;
  int y;
   
  boolean pulse = false;
  
  long timeout = 0;
  long timeout_interval = 200;
  
  Tile(int _id, String filename) {
    id = _id;
    p = loadImage(filename);
  }
  
  void update() {     
    if(pulse) {
      // change picture or stuff
      pulse = false;
    }
  }
  
  void position(int _x, int _y) {
    x = _x;
    y = _y;
  }
  
  void display() {
    if(p != null) {
      image(p, x*pic_w, y*pic_h);
    }
    fill(255);
    
    text(getTime(), (x*pic_w)+pic_w/2, (y*pic_h)-pic_h/2);
    
  }
  
  PImage getDisplay() {
    return p;
  }
  
  int getID() {
    return id;
  }
  
  void pulse() {
    if(millis() - timeout > timeout_interval) {
      //println("pulse on= "+ id);
      timeout = millis();
      pulse = true;
    }
  }
  
  int getTime() {
    return (millis()-(int)timeout)/1000;
  }
  
} 
