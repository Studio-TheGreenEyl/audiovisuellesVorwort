class Tile {
  int id;
  PGraphics pg;
  int x;
  int y;
   
  boolean pulse = false;
  boolean big = false;
  
  int bigPosition = 0; // 0 = links-oben, 1 = rechts-oben, 2 = links-untem, 3 = rechts-unten
  
  long timeout;
  long timeout_interval = 200;
  
  PImage p;
  
  Tile(int _id, int _x, int _y) {
    id = _id;
    x = _x;
    y = _y;
  }
  
  void update() {     
    if(pulse) {
      // change picture or stuff
      float random = random(0, 60);
      if(random >= 35 && !big) p = null;
      else p = loadImage("/Volumes/Work/175 documenta archiv/17501 bauhaus documenta/_Ausführung AS Grafik/Raum 1/1.2 Audiovisuelles Vorwort/Bilddaten/avv_sans_comics/sans/img"+ (int)random(1, 644) +".jpg");
      pulse = false;
    }
  }
  
  void display() {
    if(p != null) {
      if(!big) {
        image(p, x*pic_w, y*pic_h);
      } else {
        switch(bigPosition) {
          case 0:
            image(p, 0*pic_w, 0*pic_h, pic_w*2, pic_h*2);
          break;
          case 1:
            image(p, 2*pic_w, 0*pic_h, pic_w*2, pic_h*2);
          break;
          case 2:
            image(p, 0*pic_w, 2*pic_h, pic_w*2, pic_h*2);
          break;
          case 3:
            image(p, 2*pic_w, 2*pic_h, pic_w*2, pic_h*2);
          break;
        }
      }
    }
    fill(255);
    
    text(getTime(), (x*pic_w)+pic_w/2, (y*pic_h)-pic_h/2);
    
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
  
  void big() {
    big = true;
    bigPosition = (int)random(4);
  }
  
  void small() {
    big = false;
  }
  
  
} 
