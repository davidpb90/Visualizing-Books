class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  float borderSize = flowfield.centerField() * 2;
  float gridHeightMargin = height - borderSize;

    Particle(PVector l, float ms, float mf) {
    position = l.get();
    r = 1.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
  }

  void run() {
    update();
    borders();
    display();
  }

  void follow(FlowField flow) {
    PVector desired = flow.lookup(position);

    desired.mult(maxspeed);

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

  void display() {
    float theta = velocity.heading2D() + radians(90);
    noFill();
    stroke(0, 10);
    strokeWeight(1);
    pushMatrix();
    
      translate(position.x, position.y);
      point(0, 0);
      //rotate(theta);
      //beginShape(TRIANGLES);
      //vertex(0, -r*2);
      //vertex(-r, r*2);
      //vertex(r, r*2);
      //endShape();
      
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = height+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > gridHeightMargin+r) position.x = -r;
    if (position.y > gridHeightMargin+r) position.y = -r;
  }
}
