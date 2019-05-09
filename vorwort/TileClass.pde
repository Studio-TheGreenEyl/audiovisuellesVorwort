class Tile {
  // erweitern um digitale operationen die das original *nicht* kann
  boolean invertColors = false;
  boolean flip = false;
  int rotate = 0;
  
  int id;
  PImage p;
  int x;
  int y;

  String filename;
   
  boolean pulse = false;
  
  long timeout = 0;
  long timeout_interval = 200;
  
  float opacity = 0;
  float increase = 5;

  int faded = 0;

  boolean isBlackTile = false;
  
  Tile(int _id, String _filename) {
    //animate = new Ani(this, 1*FPS, "y", height);
    //animate = new Ani(this, 250, "opacity", 0);
    id = _id;
    p = loadImage(_filename);
    filename = _filename;
    if(filename.equals("assets/blackTile.jpg")) isBlackTile = true;
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

  String getFilename() {
    return filename;
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

  void fade() {
    //movement.to(this, animationLength*FPS, "y", y-getBoxHeight());

    faded++;

    opacity += increase;
    if(opacity > 255) {
      opacity = 255;
    }
    //println("faded= "+ faded + " / " + opacity);
  }

  float getOpacity() {
    return opacity;
  }

  void resetOpacity() {
    faded = 0;
    opacity = 0;
  }
  
} 
