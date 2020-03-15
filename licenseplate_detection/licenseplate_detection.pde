PImage img;
PImage img_dilate;
PImage img_erosion;
PImage img_diff;

void setup() {
  size(512, 384);
  
  img = loadImage("license1.png");
  img.filter(GRAY);
  
  img_dilate = img.copy();
  img_diff = img.copy();
  
  int dilation_size = 3;
  
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      for (int y = i-dilation_size; y < i+dilation_size; y++) {
        for (int x = j-dilation_size; x < j+dilation_size; x++) {
          if (y >= 0 && y < img.height && x >= 0 && x < img.width) {
            if (red(img.get(j, i)) > red(img_dilate.get(x, y))) {
               img_dilate.set(x, y, img.get(j, i));
            }
            
          }
        }
      }
    }
  }
  img_erosion = img_dilate.copy();
  for (int a = 0; a < 8; a++) {
    for (int i = 0; i < img.height; i++) {
      for (int j = 0; j < img.width; j++) {
        for (int y = i-dilation_size; y < i+dilation_size; y++) {
          for (int x = j-dilation_size; x < j+dilation_size; x++) {
            if (y >= 0 && y < img.height && x >= 0 && x < img.width) {
              if (red(img.get(j, i)) < red(img_dilate.get(x, y))) {
                 img_erosion.set(x, y, img.get(j, i));
              }
              
            }
          }
        }
      }
    }
  }
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      img_diff.set(j, i, img_erosion.get(j, i) - img.get(j, i)); 
    }
  }
}

void draw() {
  image(img_diff, 0, 0);
}
