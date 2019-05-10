class Tile extends DropListener  {
  int id;
  float sx = 0;    // square position
  float sy = 0;
  float sw = 200;    // and dimensions
  float sh = 200;
  
  boolean hit = false;
  
  boolean fill = false;
  
  PImage p;
  
  String filename = "blackTile.jpg";
  
  Tile(int _id, int _x, int _y) {
    id = _id;
    sx = _x;
    sy = _y;
    sw = pic_w;
    sh = pic_h;
    //println(sx +" / " + sy);
    setTargetRect(sx,sy,sw,sh);
  }
  
  void update() {
    int x = (int)id%4;
    int y = (int)id/4;
    int uniDimensional = y*4+x;
    int field = getPatternCell(x, y);
    fill = field==0?true:false;
    hit = pointRect(px,py, sx,sy,sw,sh);
  }
  
  void display() {
    
    
    if (fill) {
     fill(0);
   } else {
      fill(255);
   }
   
   
   noStroke();
   rect(sx,sy, sw,sh);
  
   // draw the point
   stroke(0);
   point(px,py);
   
   if(p != null && !fill) {
     image(p, sx, sy, sw, sh);
   }
  }
  
  void setImage(String s) {
    println("setting image to=" + s);
    p = loadImage(s);
  }
  
  void dropEnter() {
    hit = true;
  }
  
  // if a dragged object leaves the target area.
  // dropLeave is called.
  void dropLeave() {
    hit = false;
  }
  
  void dropEvent(DropEvent theEvent) {
    println("Dropped on MyDropListener id=" + id);
    if(theEvent.isImage() && !fill) {
      setImage(theEvent.toString());
      
    }
  }

  int getPatternCell(int x, int y) {
    JSONArray column = jsonPattern.getJSONArray("c"+x);
    int[] values = column.getIntArray();
    int field = values[y];
    return field;
  }
  
}
