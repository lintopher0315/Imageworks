PImage img;
PImage imgCopy;
HScrollbar hs;

void setup() {
  size(640, 336);
  
  img = loadImage("greenpath.jpg");
  imgCopy = loadImage("greenpath.jpg");
  
  hs = new HScrollbar(0, 8, width, 16, 2);
}

void draw() {
  img.loadPixels();
  imgCopy.loadPixels();
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      imgCopy.set(x, y, img.get(x, y)); 
    }
  }
  imgCopy.updatePixels();
  
  hs.update();
  hs.display();
  
  int nearest = 2;
  for (int y = 0; y < imgCopy.height-1; y+=1) {
    for (int x = 0; x < imgCopy.width-1; x+=1) {
        int r = 0;
        int g = 0;
        int b = 0;
        for (int i = y; i < y+2; i++) {
          for (int j = x; j < x+2; j++) {
            r += red(imgCopy.get(j, i));
            g += green(imgCopy.get(j, i));
            b += blue(imgCopy.get(j, i));
          }
        }
        r /= 4;
        g /= 4;
        b /= 4;
        for (int i = y; i < y+2; i++) {
          for (int j = x; j < x+2; j++) {
            imgCopy.set(j, i, color(r, g, b));
          }
        }
    }
  }
  imgCopy.updatePixels();
  
  image(imgCopy, 0, 16);
}

class HScrollbar {
  int swidth, sheight;
  float xpos, ypos;
  float spos, newspos;
  float sposMin, sposMax;
  int loose;
  boolean over;
  boolean locked;
  float ratio;
  
  HScrollbar(float xp, float yp, int sw, int sh, int l) {
     swidth = sw;
     sheight = sh;
     int widthtoheight = sw - sh;
     ratio = (float)sw / (float)widthtoheight;
     xpos = xp;
     ypos = yp-sheight/2;
     spos = 0;
     newspos = spos;
     sposMin = xpos;
     sposMax = xpos + swidth - sheight;
     loose = l;
  }
  
  void update() {
    if (overEvent()) {
      over = true;
    }
    else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv); 
  }
  
  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;    
    }
    return false;
  }
  
  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    return spos * ratio;
  }
}
