import java.util.*;
import de.looksgood.ani.*;



Grid grid;
PFont font;

int timestamps[] = new int[12];

int pic_w = 480;
int pic_h = 320;

long timestamp = 0;



boolean debug = true;


void setup() {
  size(1920, 960);
  background(0);
  Ani.init(this);

  font = loadFont("fonts/Iosevka-Term-11.vlw");
  textFont(font, 11);


  grid = new Grid(width, height);
  
  pic_w = width/4;
  pic_h = height/3;
  
  grid.init("img", "jpg,JPG,png,PNG,tif", "sets", "json");
  
  //Ani.setDefaultTimeMode(Ani.FRAMES);
}

void draw() {
  grid.update();
  grid.display();

  // debug info
  if(debug) {
    push();
    fill(0);
    rect(0, 0, 100, 40);
    fill(255);
    text("available=" + grid.getTilesSize(), 10, 20);
    text("state=" + grid.getState(), 10, 30);
    pop();
  }

}
