Table table;

FlowField flowfield;
ArrayList<Particle> particles;

int tableRows;
PGraphics pg;

boolean showFlowfield = false;

String[] books = new String[6];
int num_book = 5;

int time = millis();
PFont mono;

void setup() {
  size(800, 800);
  //smooth(6);
  noCursor();
  mono = createFont("DINPro-Bold.otf", 12);
  textFont(mono);
  
  books[0] = "first_data";
  books[1] = "adventures_sherlock";
  books[2] = "flatland";
  books[3] = "kafka";
  books[4] = "kant";
  books[5] = "around_with_sentiments_topics";

  table = loadTable(books[num_book]+".csv", "header");
  tableRows = table.getRowCount();
  
  flowfield = new FlowField(tableRows, height);
  particles = new ArrayList<Particle>();
  
  for(int i = 0; i < (50); i++) {
    particles.add(new Particle(new PVector(random(width),random(height)), random(1,4), random(0.01,0.5)));
  }
  background(0);
}

void draw() {
  background(0);
  //noStroke();
  //fill(0, 10);
  //rect(0, 0, width, height);
  
  translate(flowfield.centerField(), flowfield.centerField());
  
  if(showFlowfield) flowfield.display();
  
  for (Particle p : particles) {
    p.follow(flowfield);
    p.run(flowfield);
  }
  
  // Saving a frame after a certain determined time 
  // so that every frame we save from each book has had the same time to develop
  //if (millis() > time + 20000) { 
  //  save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/"+books[num]+"-"+frameCount.png");
  //} 
  
  // For saving every frame to create a movie
  // save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/first-data frames/"+books[num]+"-"+frameCount+".png");

}

void keyPressed() {
  if(key == ' ') {
    showFlowfield = !showFlowfield;
  }
}

void mousePressed() {
  int d = day();
  int mM = month();
  int y = year();
  int s = second();
  int m = minute();
  int h = hour();
  
  //save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/"+books[num_book]+"-"+y+mM+d+"-"+h+m+s+".png");
  save("export/"+books[num_book]+"-"+y+mM+d+"-"+h+m+s+".png");
}
