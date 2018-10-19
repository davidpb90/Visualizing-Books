class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;  // Size of particle
  float maxforce;  // Maximum steering force
  float maxspeed;  // Maximum speed
  
  float borderSize = flowfield.centerField() * 2; // Defining the borders of the grid
  float gridHeightMargin = height - borderSize; // Defining the borders of the grid

  // Particle constructor, when initializing a particle this is called
  Particle(PVector l, float ms, float mf) {
    position = l.get();
    r = 1.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
  }

  // One function to manage multiple functions that make up the system of each particle
  void run(FlowField colorflow) {
    update();
    borders();
    display(colorflow);
  }

  void follow(FlowField flow) {
    // Looking up the vector of the vector cell it's currently positioned at
    PVector desired = flow.lookup(position);
    
    // Multiply times the maxspeed we have given the particle
    desired.mult(maxspeed);
  
    // Calculate the direction to go to
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display(FlowField colorflow) {
    // Looking up the color of the vector cell it's currently positioned at
    PVector newColor = colorflow.lookupColor(position);
    
    // Some styling
    noFill();
    stroke(newColor.x, newColor.y, newColor.z , 20);
    strokeWeight(r);
    
    // Pushing the coordinate matrix so that only that every particle has its own 2d space matrix
    pushMatrix();
      // Drawing the particle
      point(position.x, position.y);
    popMatrix();
  }
  
  // OLD
  //color LerpRGB(color a, color b, float t) {
  //  float rOfA = red(a);
  //  float gOfA = green(a);
  //  float bOfA = blue(a);
    
  //  float rOfB = red(b);
  //  float gOfB = green(b);
  //  float bOfB = blue(b);
    
  //  return color(rOfA + (rOfB - rOfA) * t, gOfA + (gOfB - gOfA) * t, bOfA + (bOfB - bOfA) * t);
  //}
  
  // c = c + a*d*c1
  color colorInfluence(float a, float dist, float colInflu) {
    float currentColor = 0;
    float alphaConst = sentimentStrength; 
    NextParticleColor = currentColor + a * (CurrentFieldColor - currentColor);
  }

  // Torus topology making each particle re-appear on the other end of the canvas when exiting
  void borders() {
    if (position.x < -r) position.x = height+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > gridHeightMargin+r) position.x = -r;
    if (position.y > gridHeightMargin+r) position.y = -r;
  }
}
