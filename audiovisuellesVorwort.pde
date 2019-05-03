ArrayList<Tile> tiles = new ArrayList<Tile>();
int timestamps[] = new int[12];

int pic_w = 480;
int pic_h = 320;

long timestamp = 0;
long random_interval = 1000;
float random_display = random(1, 6);

long big_timestamp = 0;
long big_interval = 5000;

void setup() {
  size(1920, 960);

  int id = 0;
  for(int x = 0; x<4; x++) {
    for(int y = 0; y<3; y++) {
      //println(x + ", " + y);
      tiles.add(new Tile(id, x, y));
      id++;
    }
  }  
}

void draw() {
  background(0);
  
  if(millis() - timestamp > random_interval) {
    timestamp = millis();
    random_display = random(1, 6);
    
    for(int i = 0; i<random_display; i++) {
      if(millis() - big_timestamp > big_interval) {
        println("make big");
        big_timestamp = millis();
        tiles.get((int)random(0, 12)).big();
      }
      tiles.get((int)random(0, 12)).pulse();  
    }
  }
  
  for(int i = 0; i < tiles.size(); i++) {
    Tile tile = tiles.get(i);
    tile.update();
    tile.display();
  }
  
  fill(255);
  rect(0, 0, 40, 40);
  fill(0);
  text((int)random_display, 20, 20);
}
