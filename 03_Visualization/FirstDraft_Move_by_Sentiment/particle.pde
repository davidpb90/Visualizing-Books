class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  boolean print_this = true;
  float borderSize = flowfield.centerField() * 2;
  float gridHeightMargin = height - borderSize;
  float mass;

    Particle(PVector l, float ms, float mf) {
    position = l.get();
    r = 1.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
  }

  void run(FlowField flow) {
    update();
    borders();
    display(flow);
  }

  void follow(FlowField flow) {
    PVector desired = flow.lookup_position(position);
    mass = map(flow.lookup_mass(position), 0, 200, 0, 50);

    desired.mult(maxspeed);

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer, mass);
  }

  void applyForce(PVector force, float mass) {
    // We could add mass here if we want A = F / M
    //PVector f = PVector.div(force, 1);
    acceleration.add(force);
    
    //if(print_this) {
    //  println(force, mass);
    //  print_this = !print_this;
    //}
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display(FlowField flow) {
    pushMatrix();
      noStroke();
      fill(255, 90);
      textAlign(CENTER);
      //textSize(14);
      translate(position.x, position.y);
      text(flow.lookup_sentiment(position).toUpperCase(), 0, 0); 
      noFill();
      stroke(255, 255, 255, 255);

      strokeWeight(6);
      point(0, 0);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x *=-1;
    if (position.y < -r) position.y *=-1;
    if (position.x > gridHeightMargin+r) position.x *=-1;
    if (position.y > gridHeightMargin+r) position.y *=-1;
  }
}
