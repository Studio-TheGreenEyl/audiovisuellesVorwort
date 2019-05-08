class Composition {
	
	ArrayList<Tile> tiles = new ArrayList<Tile>();
	JSONObject data;
	JSONObject jsonPattern = null;
	Tile currentTile = null;
	Tile blackTile = null;

	int patternIndex = 0;
  	IntList patternLinear;
  	PGraphics pg;

	int id;
	int pattern;
	int bigImg;
	int bigFactor;
	boolean hasBig = false;
	
	boolean imagesLoaded = false;

	long timestamp = 0;
	long interval = 250;

	boolean finished = false;
	boolean nextImage = true;

	int avoid_x_start = 0;
	int avoid_y_start = 0;
	int avoid_x_end = 0;
	int avoid_y_end = 0;
	


	Composition(int _id, String file, JSONArray patterns, PGraphics _pg) {
		id = _id;
		pg = _pg;
		data = loadJSONObject(file);
		pattern = data.getInt("pattern");
		jsonPattern = patterns.getJSONObject(pattern);
		bigImg = data.getInt("bigImg");
		bigFactor = data.getInt("bigFactor");
		hasBig = data.getBoolean("hasBig");
		if(hasBig) {
			int step = bigImg;
			int x = (int)step%4;
			int y = (int)step/4;
			avoid_x_start = x*pic_w;
			avoid_y_start = y*pic_h;
			avoid_x_end = pic_w*bigFactor;
			avoid_y_end = pic_h*bigFactor;
		}
		if(debug) {
			println(jsonPattern);
			println(data);
		}
		initPatternList();
		blackTile = new Tile(9999999, "assets/blackTile.jpg");
	}

	void update() {
		if(!imagesLoaded) {
			loadImages();
			imagesLoaded = true;
		}
		if(patternIndex >= patternLinear.size()) {
			finished = true;
		} else {
			int step = patternLinear.get(patternIndex);
			int x = (int)step%4;
			int y = (int)step/4;
			int uniDimensional = y*4+x;
			int field = getPatternCell(x, y);

			pg.beginDraw();
			if(field == 1) {
				if(currentTile == null) {
					currentTile = tiles.get(uniDimensional);
				}
				if(currentTile != null) {
					currentTile.fade();
		            float opacity = currentTile.getOpacity();
		            pg.tint(255, opacity);
		            if(hasBig) {
		            	if(bigImg == currentTile.getID()) {
		            		pg.image(currentTile.getDisplay(), x*pic_w, y*pic_h, pic_w*bigFactor, pic_h*bigFactor);	
		            	} else {
		            		if( !rectRect(avoid_x_start, avoid_y_start, avoid_x_end, avoid_y_end, x*pic_w, y*pic_h, pic_w*1, pic_h*1) ) {
		            			pg.image(currentTile.getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
		            		} else nextImage = true;
		            	}
		            } else {
		            	pg.image(currentTile.getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
		            }

		            if(opacity >= 255) {
				        nextImage = true;
        			}
				}
			} else {
			  blackTile.fade();
	          float opacity = blackTile.getOpacity();
	          pg.tint(255, opacity);
	          if(hasBig) {
	          	if( !rectRect(avoid_x_start, avoid_y_start, avoid_x_end, avoid_y_end, x*pic_w, y*pic_h, pic_w*1, pic_h*1) ) {
	          		pg.image(blackTile.getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
	          	} else {
	          		nextImage = true;
	          	}
	          } else {
	          	pg.image(blackTile.getDisplay(), x*pic_w, y*pic_h, pic_w*1, pic_h*1);
	          }
	          
	          if(opacity >= 255) {
	            nextImage = true;
	          }		
			}
			pg.endDraw();

			if(nextImage) {
      			patternIndex++;
      			nextImage = false;
      			currentTile = null;
      			blackTile.resetOpacity();
    		}        
        }
	}

	void display() {
	}

	int getID() {
		return id;
	}

	void loadImages() {
		for(int i = 0; i<12; i++) {
			String s = data.getString("img"+i);
			tiles.add(new Tile(i, "img/"+ s));
		}
	}

	boolean isFinished() {
		return finished;
	}

	void initPatternList() {
	    patternLinear = new IntList();
	    for(int i = 0; i<12; i++) patternLinear.append(i);
	    patternLinear.shuffle();
	}

  	int getPatternCell(int x, int y) {
	    JSONArray column = jsonPattern.getJSONArray("c"+x);
	    int[] values = column.getIntArray();
	    int field = values[y];
	    return field;
  	}

  	// http://www.jeffreythompson.org/collision-detection/rect-rect.php
  	boolean rectRect(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
		// are the sides of one rectangle touching the other?
	  	if (r1x + r1w > r2x &&    // r1 right edge past r2 left
	      r1x < r2x + r2w &&    // r1 left edge past r2 right
	      r1y + r1h > r2y &&    // r1 top edge past r2 bottom
	      r1y < r2y + r2h) {    // r1 bottom edge past r2 top
	      return true;
	  }
	  return false;
	}
}