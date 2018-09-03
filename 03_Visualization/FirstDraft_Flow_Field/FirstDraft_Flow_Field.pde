float inc = 0.1;
int _Scale = 5;
int cols, rows;

void setup() {
  size(800, 600);
  cols = floor(width / _Scale);
  rows = floor(height / _Scale);
}

void draw() {
  float yoff = 0;
  for(int y = 0; y < rows; y++) {
    float xoff = 0;
    for(int x = 0; x < cols; x++) {
      int index = x + y * width;
      
      float r = noise(xoff, yoff)*255;
      xoff += inc;
      
      fill(r);
      noStroke();
      rect(x * _Scale, y * _Scale, _Scale, _Scale);
    }
    yoff += inc;
  }
}
