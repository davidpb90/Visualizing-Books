Table table;

Particle[] particle;
FlowField flowfield;

int tableRows;
PGraphics pg;

void setup() {
  size(displayHeight, displayHeight, P2D);
  smooth(12);
  table = loadTable("first_data.csv", "header");
  tableRows = table.getRowCount();
  
  flowfield = new FlowField(tableRows, displayHeight);
}

void draw() {
  background(169);
  translate(flowfield.centerField(), flowfield.centerField());
  flowfield.display();
}

void mousePressed() {
  int d = day();
  int mM = month();
  int y = year();
  int s = second();
  int m = minute();
  int h = hour();
  
  save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/"+y+mM+d+"-"+h+m+s+".png");
}

// SETUP
  //pos_x = new float[tableRows];
  //pos_y = new float[tableRows];
  
  //rows = floor(sqrt(tableRows));
  //cell = floor(gridSize/rows);

// DRAW
  //translate(82,82);
  //for(int i = 0; i < tableRows; i++) {
  //  //TableRow row = table.getRow(i);
  //  //String sentiment = row.getString("genotype");
    
  //  // PSEUDO CODE :: cell(sentiment, pos_x[i], pos_y[i]);
    
  //  //stroke(255, 0, 0, 100);
  //  //strokeWeight(1);
  //  //noFill();
  //  ////fill(255);
  //  //rect(pos_x[i]*cell, pos_y[i]*cell, cell, cell);
  //}
  
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
