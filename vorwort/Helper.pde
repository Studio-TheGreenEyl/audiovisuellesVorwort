void imagesToTiles() {
  for(int i = 0; i<files.size(); i++) tiles.add(new Tile(i, "img/"+ files.get(i)));
}

// not used
/*
StringList duplicateList(StringList l) {
  available = new StringList();
  for(int i = 0; i<l.size(); i++) {
    available.append(l.get(i));
    println(l.get(i));
  }
  return available;
}
*/

PImage getNextTile() {
  PImage p = null;
  if(tiles.size() >= 2) { // wenn eine kleinste zufällige auswahl noch möglich ist

    int randomTile = (int)random(0, tiles.size()-1);
    //int id = tiles.get(randomTile).getID();
    print("available= "+ tiles.size() + " / ");
    //println("random= "+ randomTile + " / id= " + id);
    println("random= "+ randomTile);

    p = tiles.get(randomTile).getDisplay();
    tiles.remove(randomTile);
  }
  return p;
  
  // run through the arraylist (pool of used images) vs. available images
  // is the new image in the arraylist?
    // yes: skip and get another image
      // in case
    // no: good. add it to the list and display it 
}

// liste von dateien 
StringList initList(String path, String filetypes) {
  StringList list = new StringList();
  folder = dataFile(path);
  pics = folder.listFiles();
  Arrays.sort(pics);

  String[] types = split(filetypes, ",");
  if(types.length < 1) return null;

  filenames = new String[pics.length];
  for (int i = 0; i < pics.length; filenames[i] = pics[i++].getPath());
  
  if(filenames.length > 0) {
    foundFiles = true;
    
    for(int i = 0; i< filenames.length; i++) {
      String[] splitter = split(filenames[i], '.');
      boolean correctType = false;

      for(int j = 0; j<types.length; j++) {
        if(splitter.length > 1 && splitter[1].equals(types[j])) {
          correctType = true;
          break;
        }
      }

      //if(splitter.length > 1 && (splitter[1].equals("jpg") || splitter[1].equals("JPG") || splitter[1].equals("png") || splitter[1].equals("PNG"))) { 
      if(correctType) { 
        String[] absolutePath = split(filenames[i], '/');
        list.append(absolutePath[absolutePath.length-1]);
      }
      
    }
  }

  // remove block?
  if(foundFiles) {
    for (int i = list.size() - 1; i >= 0; i--) if (list.get(i).equals(".DS_Store")) list.remove(i);
    for (String f : files) l.add(f);
  }

  return list;
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
