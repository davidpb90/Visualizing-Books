Table table;
ColorField colorfield;
int tableRows;

String[] books = new String[5];
int num = 4;

void setup() {
  size(2000, 2000, P2D);
  smooth(12);
  books[0] = "first_data";
  books[1] = "adventures_sherlock";
  books[2] = "flatland";
  books[3] = "kafka";
  books[4] = "kant";

  table = loadTable(books[num]+".csv", "header");
  tableRows = table.getRowCount();
  
  colorfield = new ColorField(tableRows, height);
}

void draw() {
  background(169);
  translate(colorfield.centerField(), colorfield.centerField());
  colorfield.display();
}

void mousePressed() {
  int d = day();
  int mM = month();
  int y = year();
  int s = second();
  int m = minute();
  int h = hour();
  
  save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Color_Sentiment/export/"+books[num]+"-"+y+mM+d+"-"+h+m+s+".png");
}
