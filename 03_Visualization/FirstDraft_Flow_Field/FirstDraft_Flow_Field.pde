Table table;

FlowField flowfield;
ArrayList<Particle> particles;

int tableRows;
PGraphics pg;

boolean showFlowfield = false;

void setup() {
  size(2000, 2000, P2D);
  smooth(12);
  table = loadTable("first_data.csv", "header");
  tableRows = table.getRowCount();
  
  flowfield = new FlowField(tableRows, height);
  particles = new ArrayList<Particle>();
  
  for(int i = 0; i < (tableRows/4); i++) {
    particles.add(new Particle(new PVector(random(height), random(height)), random(1, 4), random(0.1, 0.7)));
  }
  background(0);
}

void draw() {
  //background(169);
  noStroke();
  fill(0, 0);
  rect(0, 0, width, height);
  
  translate(flowfield.centerField(), flowfield.centerField());
  
  if(showFlowfield) flowfield.display();
  
  for (Particle p : particles) {
    p.follow(flowfield);
    p.run();
  }
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
  
  save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/"+y+mM+d+"-"+h+m+s+".png");
}
