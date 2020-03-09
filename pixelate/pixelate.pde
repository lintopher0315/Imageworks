PImage[] imgArray;
HScrollbar hs;

void setup() {
  size(640, 336);
  
  imgArray = new PImage[10];
  imgArray[0] = loadImage("greenpath.jpg");
  
  for (int a = 1; a < 10; a++) {
    imgArray[a] = imgArray[0].copy();
    for (int y = 0; y < imgArray[a].height; y+=2*a) {
      for (int x = 0; x < imgArray[a].width; x+=2*a) {
        int r = 0;
        int g = 0;
        int b = 0;
        int num = 0;
        for (int i = y-a; i < y+a; i++) {
          for (int j = x-a; j < x+a; j++) {
            if (i >= 0 && i < imgArray[a].height && j >= 0 && j < imgArray[a].width) {
              r += red(imgArray[0].get(j, i));
              g += green(imgArray[0].get(j, i));
              b += blue(imgArray[0].get(j, i));
              num++;
            }
          }
        }
        r /= num;
        g /= num;
        b /= num;
        for (int i = y-a; i < y+a; i++) {
          for (int j = x-a; j < x+a; j++) {
            if (i >= 0 && i < imgArray[a].height && j >= 0 && j < imgArray[a].width) {
              imgArray[a].set(j, i, color(r, g, b));
            }
          }
        }
        if (x+2*a >= imgArray[a].width) {
          for (int i = y-a; i < y+a; i++) {
            for (int j = x; j < imgArray[a].width; j++) {
              if (i >= 0 && i < imgArray[a].height && j >= 0 && j < imgArray[a].width) {
                imgArray[a].set(j, i, color(r, g, b));
              }
            }
          }
        }
      }
    }
    imgArray[a].updatePixels();
  }
  
  hs = new HScrollbar(0, 8, width, 16, 2);
}

void draw() {
  hs.update();
  hs.display();
  
  image(imgArray[floor(hs.getPos() / 64)], 0, 16);
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
