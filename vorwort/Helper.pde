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
    }
  }
}

/*
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
*/
