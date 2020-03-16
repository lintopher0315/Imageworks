PImage img;
PImage img_dilate;
PImage img_erosion;
PImage img_diff;
PImage img_orig;

void setup() {
  //size(512, 384);
  //size(1000, 400);
  size(770, 433);
  //size(1024, 683);
  
  //img = loadImage("license1.png");
  //img = loadImage("license2.jpg");
  img = loadImage("license3.jpg");
  //img = loadImage("license4.jpg");
  img_orig = img.copy();
  img.filter(GRAY);
  
  img_dilate = img.copy();
  img_diff = img.copy();
  
  int dilation_size = 6;
  
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      for (int y = i-dilation_size; y <= i+dilation_size; y++) {
        for (int x = j-dilation_size; x <= j+dilation_size; x++) {
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
  PImage temp = img_erosion.copy();
  boolean idempotence = false;
  while (!idempotence) {
    for (int i = 0; i < img.height; i++) {
      for (int j = 0; j < img.width; j++) {
        float min = red(img_erosion.get(j, i));
        for (int y = i-1; y <= i+1; y++) {
          for (int x = j-1; x <= j+1; x++) {
            if (y >= 0 && y < img.height && x >= 0 && x < img.width) {
              if (red(temp.get(x, y)) < min && red(temp.get(x, y)) > red(img.get(j, i))) {
                min = red(temp.get(x, y)); 
              }
            }
          }
        }
        img_erosion.set(j, i, color(min, min, min));
      }
    }
    boolean isSame = true;
    outer:
    for (int i = 0; i < img.height; i++) {
      for (int j = 0; j < img.width; j++) {
         if (red(img_erosion.get(j, i)) != red(temp.get(j, i))) {
           isSame = false;
           break outer;
         }
      }
    }
    if (isSame) {
      idempotence = true; 
    }
    temp = img_erosion.copy();
  }
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      img_diff.set(j, i, img_erosion.get(j, i) - img.get(j, i)); 
    }
  }
  img_diff.filter(THRESHOLD);
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      if (red(img_diff.get(j, i)) == 255) {
        boolean surr = true;
        outer:
        for (int y = i-1; y <= i+1; y++) {
          for (int x = j-1; x <= j+1; x++) {
            if (y >= 0 && y < img.height && x >= 0 && x < img.width && (y != i && x != j) && red(img_diff.get(x, y)) == 255) {
              surr = false;
              break outer;
            }
          }
        }
        if (surr) {
          img_diff.set(j, i, color(0, 0, 0)); 
        }
      }
    }
  }
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      if (red(img_diff.get(j, i)) == 255) {
        img_orig.set(j, i, color(255, 0, 0)); 
      }
    }
  }
}

void draw() {
  image(img_orig, 0, 0);
}
