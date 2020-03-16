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
  PImage temp = img_erosion.copy();
  boolean idempotence = false;
  while (!idempotence) {
    for (int i = 0; i < img.height; i++) {
      for (int j = 0; j < img.width; j++) {
        float min = red(img_erosion.get(j, i));
        for (int y = i-1; y < i+1; y++) {
          for (int x = j-1; x < j+1; x++) {
            if (y >= 0 && y < img.height && x >= 0 && x < img.width) {
              /*if (red(img_erosion.get(j, i)) > red(temp.get(x, y)) && red(temp.get(x, y)) > red(img.get(j, i))) {
                 img_erosion.set(j, i, temp.get(x, y));
              }*/
              /*if (red(temp.get(j, i)) < red(img_erosion.get(x, y)) && red(temp.get(j, i)) > red(img.get(x, y))) {
                 img_erosion.set(x, y, temp.get(j, i));
              }*/
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
}

void draw() {
  image(img_diff, 0, 0);
}
