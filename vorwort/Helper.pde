void imagesToTiles() {
  for(int i = 0; i<files.size(); i++) tiles.add(new Tile(i, "img/"+ files.get(i)));
}

StringList duplicateList(StringList l) {
  available = new StringList();
  for(int i = 0; i<l.size(); i++) {
    available.append(l.get(i));
  }
  return available;
}

void getNextTile() {
  // run through the arraylist (pool of used images) vs. available images
  // is the new image in the arraylist?
    // yes: skip and get another image
      // in case
    // no: good. add it to the list and display it 
}

void initList() {
  folder = dataFile(path);
  pics = folder.listFiles();
  Arrays.sort(pics);

  filenames = new String[pics.length];
  for (int i = 0; i < pics.length; filenames[i] = pics[i++].getPath());
  
  if(filenames.length > 0) {
    foundFiles = true;
    
    for(int i = 0; i< filenames.length; i++) {
      String[] splitter = split(filenames[i], '.');
      
      if(splitter.length > 1 && (splitter[1].equals("jpg") || splitter[1].equals("JPG") || splitter[1].equals("png") || splitter[1].equals("PNG"))) { 
        String[] absolutePath = split(filenames[i], '/');
        files.append(absolutePath[absolutePath.length-1]);
      }
      
    }
  }
  
  if(foundFiles) {
    for (int i = files.size() - 1; i >= 0; i--) if (files.get(i).equals(".DS_Store")) files.remove(i);
    for (String f : files) l.add(f);
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
