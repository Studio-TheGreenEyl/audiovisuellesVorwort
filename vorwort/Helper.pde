void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      // something
    } else if (keyCode == DOWN) {
      // something else
    }
  } else {
    if (key == 'd' || key == 'D') {
        debug = !debug;
    } else if (key == ' ') {
        play = !play;
    } else if (key == 'r' || key == 'R') {
      record = !record;
    } else if (key == 'p' || key == 'P') {
        drawOnScreen = !drawOnScreen;
        println("drawOnScreen= " + drawOnScreen);
    }
  }
}