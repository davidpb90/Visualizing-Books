class FlowField {

  PVector[][] field;
  int cell, rows, gridSize;
  float theta;
  
  FlowField(int toSquare, int sizetemp) {
    rows = floor(sqrt(toSquare));
    println(rows);
    cell = floor(sizetemp/rows);
    println(cell);
    field = new PVector[rows][rows];
    init();
  }
  
  int centerField() {
    return (displayHeight-(rows * cell))/2;
    // (1050-(212*4))/2
  }
  
  void init() {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < rows; j++) {
        String sentiment = table.getString(i*rows+j, "sentiment");
        // angle degrees in radians - from 0 to TWO_PI
        // sentiment dictionary: https://saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm

        switch(sentiment) {
          case "negative":
            theta = 3*PI/2;
            break;
          case "positive":
            theta = PI/2;
            break;
          case "anger":
            theta = 17*PI/10;
            break;
          case "anticipation":
            theta = 9*PI/10;
            break;
          case "disgust":
            theta = 19*PI/10;
            break;
          case "fear":
            theta = 13*PI/10;
            break;
          case "joy":
            theta = 3*PI/10;
            break;
          case "sadness":
            theta = PI/10;
            break;
          case "surprise":
            theta = 11*PI/10;
            break;
          case "trust":
            theta = 7*PI/10;
            break;
          default:
            theta = 0;
            break;
        }
        field[i][j] = new PVector(cos(theta), sin(theta));
        //field[i][j] = new PVector(i % rows, j / rows);
      }
    }
  }
  
  void display() {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < rows; j++) {
        //pushMatrix();
        drawVector(field[i][j], i*cell, j*cell, cell-2);
        //popMatrix();
      }
    }
  }
  
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    translate(x,y);
    stroke(0);
    strokeWeight(1);
    rotate(v.heading2D());
    float len = v.mag()*scayl;
    line(0, 0, len, 0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }
  
  PVector lookup(PVector lookup) {
    //int resolution = 1;
    //int cols = 1000;
    //int rows = 1000;
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }
}
