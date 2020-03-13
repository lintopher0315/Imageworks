PImage img;

void setup() {
  size(940, 665);
  
  img = loadImage("urban4.png");
  
  int length = 5;
  double maxLength = Math.sqrt(Math.pow(length, 2) * 2);
  
  for (int i = 0; i < img.height; i++) {
    for (int j = 0; j < img.width; j++) {
      int avg_r = 0;
      int avg_g = 0;
      int avg_b = 0;
      int numPixels = 0;
      for (int y = i-length; y < i+length; y++) {
        for (int x = j-length; x < j+length; x++) {
           if (y >= 0 && y < img.height && x >= 0 && x < img.width) {
             double modDist = (Math.sqrt(Math.pow(Math.abs(y-i), 2) + Math.pow(Math.abs(x-j), 2)) / maxLength) + 0.5;
             avg_r += red(img.get(x, y)) * modDist;
             avg_g += green(img.get(x, y)) * modDist;
             avg_b += blue(img.get(x, y)) * modDist;
             numPixels++;
           }
        }
      }
      avg_r /= numPixels;
      avg_g /= numPixels;
      avg_b /= numPixels;
      
      double variance = 0.0;
      for (int y = i-length; y < i+length; y++) {
        for (int x = j-length; x < j+length; x++) {
          if (y >= 0 && y < img.height && x >= 0 && x < img.width && (y != i && x != j)) {
            int avg_color_diff = 0;
            avg_color_diff += Math.abs(red(img.get(x, y)) - avg_r);
            avg_color_diff += Math.abs(green(img.get(x, y)) - avg_g);
            avg_color_diff += Math.abs(blue(img.get(x, y)) - avg_b);
            avg_color_diff /= 3;
           
            double dist = Math.sqrt(Math.pow(Math.abs(y-i), 2) + Math.pow(Math.abs(x-j), 2));
            variance += Math.pow(avg_color_diff / dist, 2);
          }
        }
      }
      variance /= numPixels;
      if (variance > 230) {
        img.set(j, i, color(255, 0, 0)); 
      }
    }
  }
}

void draw() {
  image(img, 0, 0);
}
