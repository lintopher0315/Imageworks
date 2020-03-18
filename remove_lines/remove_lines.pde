PImage img;
PImage img_xKernel;
PImage img_yKernel;
PImage img_edge;

void setup() {
  size(640, 480);
  
  img = loadImage("writing1.JPG");
  img.filter(GRAY);
  
  img_xKernel = img.copy();
  img_yKernel = img.copy();
  img_edge = img.copy();
  
  for (int i = 1; i < img.height - 1; i++) {
    for (int j = 1; j < img.width - 1; j++) {
      float edgeValue = 0;
      for (int y = i-1; y <= i+1; y++) {
        if (y == i) {
           edgeValue -= red(img.get(j-1, y));
        }
        edgeValue -= red(img.get(j-1, y));
      }
      for (int y = i-1; y <= i+1; y++) {
        if (y == i) {
           edgeValue += red(img.get(j+1, y));
        }
        edgeValue += red(img.get(j+1, y));
      }
      if (Math.abs(edgeValue) > 100) {
        img_xKernel.set(j, i, color(255, 255, 255));
      }
    }
  }
  for (int i = 1; i < img.height - 1; i++) {
    for (int j = 1; j < img.width - 1; j++) {
      float edgeValue = 0;
      for (int x = j-1; x <= j+1; x++) {
        if (x == j) {
           edgeValue -= red(img.get(x, i-1));
        }
        edgeValue -= red(img.get(x, i-1));
      }
      for (int x = j-1; x <= j+1; x++) {
        if (x == j) {
           edgeValue += red(img.get(x, i+1));
        }
        edgeValue += red(img.get(x, i+1));
      }
      if (Math.abs(edgeValue) > 100) {
        img_yKernel.set(j, i, color(255, 255, 255));
      }
    }
  }
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      if (red(img_xKernel.get(j, i)) == 255 || red(img_yKernel.get(j, i)) == 255) {
        img_edge.set(j, i, color(255, 255, 255)); 
      }
      else {
        img_edge.set(j, i, color(0, 0, 0)); 
      }
    }
  }
}

void draw() {
  image(img_edge, 0, 0);
}
