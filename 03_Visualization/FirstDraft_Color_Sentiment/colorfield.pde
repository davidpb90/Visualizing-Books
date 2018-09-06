class ColorField {

  PVector[][] field;
  int cell, rows, gridSize;
  float _sentimentRed, _sentimentGreen, _sentimentBlue;
  
  ColorField(int toSquare, int sizetemp) {
    gridSize = sizetemp;
    
    rows = floor(sqrt(toSquare));
    cell = floor(sizetemp/rows);

    field = new PVector[rows][rows];
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
            _sentimentRed = 0;
            _sentimentGreen = 0;
            _sentimentBlue = 0;
            break;
          case "positive":
            _sentimentRed = 255;
            _sentimentGreen = 255;
            _sentimentBlue = 255;
            break;
          case "anger":
            _sentimentRed = 228;
            _sentimentGreen = 36;
            _sentimentBlue = 38;
            break;
          case "anticipation":
            _sentimentRed = 240;
            _sentimentGreen = 210;
            _sentimentBlue = 160;
            break;
          case "disgust":
            _sentimentRed = 202;
            _sentimentGreen = 157;
            _sentimentBlue = 43;
            break;
          case "fear":
            _sentimentRed = 195;
            _sentimentGreen = 30;
            _sentimentBlue = 127;
            break;
          case "joy":
            _sentimentRed = 255;
            _sentimentGreen = 230;
            _sentimentBlue = 0;
            break;
          case "sadness":
            _sentimentRed = 10;
            _sentimentGreen = 90;
            _sentimentBlue = 200;
            break;
          case "surprise":
            _sentimentRed = 255;
            _sentimentGreen = 110;
            _sentimentBlue = 20;
            break;
          case "trust":
            _sentimentRed = 0;
            _sentimentGreen = 160;
            _sentimentBlue = 50;
            break;
          default:
            _sentimentRed = 169;
            _sentimentGreen = 169;
            _sentimentBlue = 169;
            break;
        }
        
        field[i][j] = new PVector(_sentimentRed, _sentimentGreen, _sentimentBlue);

      }
    }
  }
  
  void display() {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*cell, j*cell);
      }
    }
  }
  
  void drawVector(PVector _tempColor, float x, float y) {
    
    // RECTANGLE STYLE
    pushMatrix();
      fill(_tempColor.x, _tempColor.y, _tempColor.z);
      //noFill();
      stroke(_tempColor.x, _tempColor.y, _tempColor.z);
      strokeWeight(1);
      noStroke();
      
      //noStroke();
      //fill(255);
      rectMode(CENTER);
      rect(x, y,cell, cell);
      
    popMatrix();

    // ELLIPSE STYLE
    //pushMatrix();
    //  fill(_tempColor.x, _tempColor.y, _tempColor.z);
    //  //noFill();
    //  stroke(_tempColor.x, _tempColor.y, _tempColor.z);
    //  strokeWeight(1);
    //  noStroke();
      
    //  //noStroke();
    //  //fill(255);
    //  rectMode(CENTER);
    //  rect(x, y,cell/1.5, cell/1.5);
      
    //popMatrix();

  }
  
  PVector lookup(PVector lookup) {
    int lookRow = int(constrain(lookup.x, 0, rows-1));
    int lookCol = int(constrain(lookup.y, 0, rows-1));
    //int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[lookRow][lookCol].get();
  }
}
