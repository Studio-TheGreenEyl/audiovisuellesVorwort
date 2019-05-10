void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP || keyCode == RIGHT) {
      currentPattern++;
      currentPattern %= patterns.size();
      jsonPattern = patterns.getJSONObject(currentPattern);
    } else if (keyCode == DOWN || keyCode == LEFT) {
      currentPattern--;
      if(currentPattern < 0) currentPattern = patterns.size()-1;
      jsonPattern = patterns.getJSONObject(currentPattern);
    }
  } else {
    if (key == 'd' || key == 'D') {
        debug = !debug;
    } else if (key == 'e' || key == 'E') {
        export();
    }
  }
}
