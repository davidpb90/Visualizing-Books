Table table; // We initialize a Table called table
int tableRows; // Initialize a variable to store the amount of table rows in that table

FlowField flowfield; // Init a custom object which we have defined in the FlowField class (flowfield.pde)
ArrayList<Particle> particles; // Initializing an array of custom object which we have defined in the Particle class (particle.pde)

String[] books = new String[5]; // To switch quick and fast between different books we initialize an array here with 5 keys
int num = 4; // The index of the book we want to use in the visualization

boolean showFlowfield = false; // Just a boolean for debugging, when true it shows the direction of each vector in the flowfield
int time = millis(); // Initializing a variable to keep track of time which we can use to save every N amount of time a frame

// Void is a keyword used indicate that a function returns no value
// The setup() function is run once, when the program starts. 
// It's used to define initial enviroment properties such as screen size and to load our table as the program starts.
void setup() {
  size(2000, 2000, P2D);   // I run it at 2000*2000 pixels to increase quality of render, P2D is a renderer for 2D drawing, faster than the default renderer
  smooth(6); // anti-aliasing
  
  // Filling the array with book names so that we can switch easily between different datasets
  books[0] = "first_data";
  books[1] = "adventures_sherlock";
  books[2] = "flatland";
  books[3] = "kafka";
  books[4] = "kant";

  table = loadTable(books[num]+".csv", "header");   // Reading the table, by default Processing looks for a folder called 'data' in which we have stored our csv's
  tableRows = table.getRowCount();   // Getting the amount of rows in our table

  flowfield = new FlowField(tableRows, height);   // Initialize our flowfield with the amount of rows to calculate the square root and how big the grid can be  
  particles = new ArrayList<Particle>();   // Initialize our particle arraylist
  
  for(int i = 0; i < (tableRows/4); i++) {  // Create a for loop to add our particles in our arraylist, just a random number
    particles.add(new Particle(new PVector(0, 0), random(1, 4), random(0.1, 0.7)));     // Adds a newly constructed particle
  }
  
  background(169);   // Drawing the background once to show the trajectory of each particle
}

// Called directly after setup(), the draw() function continuously executes the lines of code 
// contained inside its block until the program is stopped or noLoop() is called.
void draw() {
  
  translate(flowfield.centerField(), flowfield.centerField());   // Push the coordinate system by the returned value of the centerField() function, this centers our grid 
  
  if(showFlowfield) flowfield.display(); // show flowfield vector directions when boolean is true
  
  for (Particle p : particles) {    
    p.follow(flowfield);     // Make every particle follow the vectors in the flowfield    
    p.run(flowfield);     // Have every particle run its system to be updated in location, color and check for borders
  }
  
  // Saving a frame after a certain determined time 
  // so that every frame we save from each book has had the same time to develop
  //if (millis() > time + 20000) { 
  //  save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/"+books[num]+"-"+frameCount.png");
  //} 
  
  // For saving every frame to create a movie from those frames
  // save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Flow_Field/export/first-data frames/"+books[num]+"-"+frameCount+".png");

}

// This function is called when a key is pressed
void keyPressed() {
  
  // if the spacebar is pressed it will change the value of the boolean
  if(key == ' ') {
    showFlowfield = !showFlowfield;
  }
}

// This function is called when a mousebutton is pressed
void mousePressed() {
  
  // Some variables for date and time stamps
  int d = day();
  int mM = month();
  int y = year();
  int s = second();
  int m = minute();
  int h = hour();
  
  // Save the frame at X location with N name
  save("/Volumes/Apt Opt Out/02_Projecten/Visualizing Books/Visualizing-Books/03_Visualization/FirstDraft_Color_Flow_Field/export/"+books[num]+"-"+y+mM+d+"-"+h+m+s+".png");
}
