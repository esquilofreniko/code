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
  int size = 0;
  int id = 0;
  
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
  void checkEdges(int x0,int x1,int y0,int y1,int cx0,int cx1, int cy0, int cy1) {
    if (location.x > x1 || location.x < x0 || location.y < y0 || location.y > y1) {
      //location.x = random(cx0,cx1);
      location.x = width/2;
      location.y = height/2;
      velocity.x *= 0.5;
      velocity.y *= 0.5;
    }
  }
  
  void colision(){
    for(int i=0;i<size;i++){
      if(i != id){
        if(location.x == movers[i].location.x && location.y == movers[i].location.y){
          velocity.x *= -2;
          velocity.y *= -2;
          movers[i].velocity.x *= -2;
          movers[i].velocity.y *= -2;
        }
      }
    }
  }
  
  void accelarator(int x0,int x1,int y0,int y1) {
    if (location.x > x0 && location.x < x1 && location.y > y0 && location.y < y1){
      velocity.x *= 0.9;
      velocity.y *= 0.9;
    }
    //if(location.y > y0 && location.y < y1){
      //velocity.y *= 1.5; 
    //}
  }
}
