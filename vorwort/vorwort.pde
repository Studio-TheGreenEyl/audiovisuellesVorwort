import java.util.*;
import de.looksgood.ani.*;


ArrayList<Tile> tiles = new ArrayList<Tile>();
ArrayList<Composition> compositions = new ArrayList<Composition>();
Grid grid;

int timestamps[] = new int[12];

int pic_w = 480;
int pic_h = 320;

long timestamp = 0;

StringList files = new StringList();
StringList sets = new StringList();

boolean debug = true;


void setup() {
  size(1920, 960);



  background(0);
  grid = new Grid(width, height);
  
  pic_w = width/4;
  pic_h = height/3;
  
  files = grid.initList("img", "jpg,JPG,png,PNG,tif");
  sets = grid.initList("sets", "json");
  if(files == null) { println("ERROR= no images found. please check /data/img"); exit(); }
  if(sets == null) { println("ERROR= no sets found. please check /data/sets"); exit(); }
  grid.filesToTiles();
  grid.filesToCompositions();

  Ani.init(this);  
}

void draw() {
  grid.update();
  grid.display();

  // debug info
  if(debug) {
    push();
    fill(0);
    rect(0, 0, 200, 30);
    fill(255);
    text("available=" + tiles.size(), 10, 10);
    text("state=" + grid.getState(), 10, 20);


    pop();
  }

}
