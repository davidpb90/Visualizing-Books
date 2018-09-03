Table table;

//float inc = 0.1;
int xScale, yScale;
int rows;

float[] pos_x;
float[] pos_y;

void setup() {
  size(800, 800, P2D);
  
  table = loadTable("first_data.csv", "header");
  rows = table.getRowCount();
  //println(rows);
  
  pos_x = new float[rows];
  pos_y = new float[rows];
  
  assignValues();
}

void assignValues() {
  for(int i = 0; i < rows; i++) {
    pos_x[i] = (i % width);
    pos_y[i] = (i / width);
  }
}

void draw() {
  background(0);

  for(int i = 0; i < rows; i++) {
    //TableRow row = table.getRow(i);
    //String sentiment = row.getString("genotype");
    
    // PSEUDO CODE :: cell(sentiment, pos_x[i], pos_y[i]);
    
    stroke(255, 0, 0, 100);
    strokeWeight(1);
    noFill();
    //fill(255);
    rect(pos_x[i], pos_y[i], 5, 5);
  }
  
  //float yoff = 0;
  //for(int y = 0; y < rows; y++) {
  //  float xoff = 0;
  //  for(int x = 0; x < cols; x++) {
  //    //int index = x + y * width;
      
  //    float r = noise(xoff, yoff)*255;
  //    xoff += inc;
      
  //    fill(r);
  //    noStroke();
  //    rect(x * _Scale, y * _Scale, _Scale, _Scale);
  //  }
  //  yoff += inc;
  //}
}
