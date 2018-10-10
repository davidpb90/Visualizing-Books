class FlowField {

  PVector[][] field;
  int cell, rows, gridSize;
  float theta;
  float[][] mass;
  
  FlowField(int toSquare, int sizetemp) {
    gridSize = sizetemp;
    
    rows = floor(sqrt(toSquare));
    cell = floor(sizetemp/rows);

    field = new PVector[rows][rows];
    mass = new float[rows][rows];
    
    init();
  }
  
  int centerField() {
    return (height-(rows * cell))/2;
  }
  
  void init() {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < rows; j++) {
        
        String sentiment = table.getString(i*rows+j, "sentiment");
        float current_mass = Float.valueOf(table.getString(i*rows+j, "freq_book"));
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
        mass[i][j] = current_mass;
      }
    }
  }
  
  void display() {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < rows; j++) {
        if(field[i][j].x != 0 && field[i][j].y != 0) drawVector(field[i][j], i*cell, j*cell, 3);
      }
    }
  }
  
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    
      float arrowsize = 4;
      float len = v.mag()*scayl;

      translate(x,y);
      rotate(v.heading2D());

      stroke(255);
      strokeWeight(1);
      
      line(0, 0, len, 0);
    
    popMatrix();
  }
  
  PVector lookup_position(PVector lookup) {
    int lookRow = int(constrain(lookup.x / cell, 0, rows-1));
    int lookCol = int(constrain(lookup.y / cell, 0, rows-1));
    //int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[lookRow][lookCol].get();
  }
  
  float lookup_mass(PVector lookup) {
    int lookRow = int(constrain(lookup.x / cell, 0, rows-1));
    int lookCol = int(constrain(lookup.y / cell, 0, rows-1));
    //int row = int(constrain(lookup.y/resolution,0,rows-1));
    return mass[lookRow][lookCol];
  }
}
