class Attractor {
  float mass;
  PVector location;
  float G;

  Attractor(float x, float y, float mass_) {
    location = new PVector (x, y);
    mass = mass_;
    G = 0.4 * gmult;
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(location, m.location); //whats the force direction?
    float distance = force.mag();
    distance = constrain(distance, 5, 25); //constraint distance
    force.normalize();
    float strength = (G*mass*m.mass) / (distance * distance);
    force.mult(strength); // whats the force magnitude?
    return force; // return force so it can be ap`plied!
  }
  
  PVector repel(Mover m) {
    PVector force = PVector.sub(location, m.location); //whats the force direction?
    float distance = force.mag();
    distance = constrain(distance, 5, 25); //constraint distance
    force.normalize();
    float strength = (G*mass*m.mass) / (distance * distance);
    force.mult(strength); // whats the force magnitude
    force.mult(-repelmult);
    return force; // return force so it can be ap`plied!
  }
  
  void display() {
    noStroke();
    fill(255, 255, 255, 50);
    ellipse(location.x, location.y, mass*2, mass*2);
  }
}

class Mover {
  // location, velocity, and acceleration 
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  // Mass is tied to size
  float mass;

  Mover(float m, float x, float y) {
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }

  void update() {
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // Location changes by velocity
    location.add(velocity);
    velocity.mult(0.75);
    // We must clear acceleration each frame
    acceleration.mult(0);
  }
  
  // Draw Mover
  void display() {
    noStroke();
    fill(255,255,255,255);
    ellipse(location.x, location.y, mass*2, mass*2);
  }
  
  // Bounce off bottom of window
  void checkEdges() {
    if (location.x > width || location.x < 0) {
      velocity.x *= -0.9;  // A little dampening when hitting the bottom
      location.x = width/2;
      location.y = height/2;
    }
    if (location.y > height || location.y < 0) {
      velocity.y *= -0.9;  // A little dampening when hitting the bottom
      location.y = height/2;
      location.x = width/2;
    }
  }
}
