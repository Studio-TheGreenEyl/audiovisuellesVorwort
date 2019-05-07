class Composition {
	
	ArrayList<Tile> tiles = new ArrayList<Tile>();
	JSONObject data;
	JSONObject jsonPattern = null;

	int id;
	int pattern;
	int bigImg;
	int bigFactor;
	
	boolean imagesLoaded = false;


	Composition(int _id, String file, JSONArray patterns) {
		id = _id;
		data = loadJSONObject(file);
		pattern = data.getInt("pattern");
		jsonPattern = patterns.getJSONObject(pattern);
		bigImg = data.getInt("bigImg");
		bigFactor = data.getInt("bigFactor");
		if(debug) {
			println(jsonPattern);
			println(data);
		}
	}

	void update() {
	}

	void display() {

	}

	void loadImages() {
		// before the first display, the images have to be loaded
		// not loading all images at once otherwise we would run into a buffer overflow
		// loads images into the tiles arrayList
	}

	void isFinished() {

	}
}