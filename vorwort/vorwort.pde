import java.util.*;

Grid grid;
PFont font;

int pic_w = 480;
int pic_h = 320;

long timestamp = 0;
boolean debug = true;
boolean play = true;
boolean record = true;


void setup() {
  size(1920, 1080);
  background(0);

  font = loadFont("fonts/Iosevka-Term-11.vlw");
  textFont(font, 11);

  grid = new Grid(width, height);
  
  pic_w = width/4;
  pic_h = height/3;
  
  grid.init("img", "jpg,JPG,png,PNG,tif", "sets", "json");
}

void draw() {
  grid.update();
  grid.display();

  if(record) {
      saveFrame("data/export/e-######.png");
  }

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
