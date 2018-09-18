class FlowField {

  PVector[][] field;
  PVector[][] colorfield;
  int cell, rows, gridSize;
  float theta, _sentimentRed, _sentimentGreen, _sentimentBlue;
  
  FlowField(int toSquare, int sizetemp) {
    gridSize = sizetemp;
    
    rows = floor(sqrt(toSquare));
    cell = floor(sizetemp/rows);

    field = new PVector[rows][rows];
    colorfield = new PVector[rows][rows];
    
    init();
  }
  
  int centerField() {
    return (height-(rows * cell))/2;
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
            _sentimentRed = 0;
            _sentimentGreen = 0;
            _sentimentBlue = 0;
            break;
          case "positive":
            theta = PI/2;
            _sentimentRed = 255;
            _sentimentGreen = 255;
            _sentimentBlue = 255;
            break;
          case "anger":
            theta = 17*PI/10;
            _sentimentRed = 228;
            _sentimentGreen = 36;
            _sentimentBlue = 38;
            break;
          case "anticipation":
            theta = 9*PI/10;
            _sentimentRed = 240;
            _sentimentGreen = 210;
            _sentimentBlue = 160;
            break;
          case "disgust":
            theta = 19*PI/10;
            _sentimentRed = 202;
            _sentimentGreen = 157;
            _sentimentBlue = 43;
            break;
          case "fear":
            theta = 13*PI/10;
            _sentimentRed = 195;
            _sentimentGreen = 30;
            _sentimentBlue = 127;
            break;
          case "joy":
            theta = 3*PI/10;
            _sentimentRed = 255;
            _sentimentGreen = 230;
            _sentimentBlue = 0;
            break;
          case "sadness":
            theta = PI/10;
            _sentimentRed = 10;
            _sentimentGreen = 90;
            _sentimentBlue = 200;
            break;
          case "surprise":
            theta = 11*PI/10;
            _sentimentRed = 255;
            _sentimentGreen = 110;
            _sentimentBlue = 20;
            break;
          case "trust":
            theta = 7*PI/10;
            _sentimentRed = 0;
            _sentimentGreen = 160;
            _sentimentBlue = 50;
            break;
          default:
            theta = 0;
            _sentimentRed = 169;
            _sentimentGreen = 169;
            _sentimentBlue = 169;
            break;
        }
        
        field[i][j] = new PVector(cos(theta), sin(theta));
        colorfield[i][j] = new PVector(_sentimentRed, _sentimentGreen, _sentimentBlue);

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
    
      float len = v.mag()*scayl;

      translate(x,y);
      rotate(v.heading2D());

      stroke(255);
      strokeWeight(1);
      
      line(0, 0, len, 0);
    
    popMatrix();
  }
  
  // Function that takes a position and returns a vector cell position
  PVector lookup(PVector lookup) {
    int lookRow = int(constrain(lookup.x / cell, 0, rows-1));
    int lookCol = int(constrain(lookup.y / cell, 0, rows-1));

    return field[lookRow][lookCol].get();
  }
  
  // Function that takes a position and returns the color associated with that position according to which vector cell there is located  
  PVector lookupColor(PVector lookup) {
    int lookRow = int(constrain(lookup.x / cell, 0, rows-1));
    int lookCol = int(constrain(lookup.y / cell, 0, rows-1));

    return colorfield[lookRow][lookCol].get();
  }
}
