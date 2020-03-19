import java.util.LinkedList;

PImage img;
PImage img_xKernel;
PImage img_yKernel;
PImage img_edge;
PImage img_orig;
int[][] accumulator;
LinkedList<double[]> lines;

void setup() {
  size(1023, 805);
  
  img = loadImage("lines1.jpg");
  img_orig = img.copy();
  img.filter(GRAY);
  
  img_xKernel = img.copy();
  img_yKernel = img.copy();
  img_edge = img.copy();
  
  int diagonal = (int)Math.sqrt(Math.pow(img.height, 2) + Math.pow(img.width, 2));
  
  accumulator = new int[360][2 * diagonal];
  lines = new LinkedList<double[]>();
  
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
        for (int theta = 0; theta < 360; theta++) {
          int rho = (int)Math.round(j * Math.cos(Math.toRadians(theta)) + i * Math.sin(Math.toRadians(theta))) + diagonal; 
          accumulator[theta][rho]++;
        }
      }
      else {
        img_edge.set(j, i, color(0, 0, 0)); 
      }
    }
  }
  for (int i = 0; i < accumulator.length; i++) {
    for (int j = 0; j < accumulator[0].length; j++) {
      if (accumulator[i][j] > 300) {
        double y;
        double x;
        if (j < diagonal) {
          int new_theta = i;
          if (new_theta > 180) {
            new_theta -= 180; 
          }
          else {
            new_theta += 180; 
          }
          int new_rho = diagonal - j;
          y = (new_rho)*Math.sin(Math.toRadians(new_theta));
          x = (new_rho)*Math.cos(Math.toRadians(new_theta));
        }
        else {
          y = (j-diagonal)*Math.sin(Math.toRadians(i));
          x = (j-diagonal)*Math.cos(Math.toRadians(i));
        }
        double slope = y / x;
        if (y == 0) {
          lines.add(new double[]{x, 0, x, 1000});
          continue;
        }
        double perp = -1 / slope;
        double b = y - (x * perp);
        lines.add(new double[]{0, b, 1000, 1000 * perp + b});
      }
    }
  }
}

void draw() {
  image(img_orig, 0, 0);
  for (int i = 0; i < lines.size(); i++) {
    stroke(248, 246, 247);
    line((float)lines.get(i)[0], (float)lines.get(i)[1], (float)lines.get(i)[2], (float)lines.get(i)[3]);
  }
}
