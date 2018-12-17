import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

Attractor [] attractors = new Attractor[1];
Mover [] movers = new Mover[1000];
boolean display;  // to display attractors

int gmult = 25;
float repelmult = 1;

int lr = 255;
int lg = 255;
int lb = 255;
int bgcol = 0;
int [] shapevert = new int[60];

void setup() {
  fullScreen(P3D,2);
  smooth();
  background(0);
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  in.start();
  fft.input(in);
  
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(1, random(width), random(height));
  }

  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(width/2, height/2, 25);
  }
}

void draw() {
  fill(bgcol, 50);
  rect(0, 0, width, height);
  pointLight(lr,lg,lb, width/2, height/2, 10000);
  fft.analyze(spectrum);
  
  for(int k = 0; k<256;k++){
    if(spectrum[k] > 0.1){
      int index = int(random(0,20));
      shapevert[index] = (width/2-75) + int(random((width/2)-75,(width/2)+75));
      shapevert[index+20] = int(random((height/2)-75,(height/2)+75));
      shapevert[index+40] = int(random(0,0));
    }
  }
  fill(lr,lg,lb,255);
  stroke(lr,lg,lb,255);
  beginShape();
  for(int i=0;i<20;i++){
   vertex(shapevert[i],shapevert[i+20],shapevert[i+40]); 
  }
  endShape();
  beginShape();
  for(int i=0;i<20;i++){
   vertex(width-shapevert[i],shapevert[i+20],shapevert[i+40]); 
  }
  endShape();   
  
  for (int i = 0; i < movers.length; i++) {
    for(int k = 0; k<64;k++){
      if(spectrum[k] > 0.1){
        for ( int j = 0; j < attractors.length; j++) {
          PVector force = attractors[j].attract(movers[i]);
          movers[i].applyForce(force);
        }
        lr = 255;
        lg = 255;
        lb = 255;
        bgcol = 0;
      }
    }
    for(int k = 64; k<128 ;k++){
      if(spectrum[k] > 0.01){
        for ( int j = 0; j < attractors.length; j++) {
          PVector force = attractors[j].repel(movers[i]);
          movers[i].applyForce(force);
        }
        lr = 0;
        lg = 0;
        lb = 0;
        bgcol = 255;
      }
    }
    movers[i].checkEdges();
    movers[i].update();
    movers[i].display();
  }
  stroke(lr,lg,lb);
  for(int i = 0; i < bands; i++){
    if(i < 256){
      line( width-(256-i), 128, width-(256-i), 128 - spectrum[i]*512);
      line( (i), height , (i), height  - spectrum[i]*512);
    }  
  } 
  
  text("fps: "  + frameRate,2,10);
  text("theneuronproject",2,20);
  
  text("fps: "  + frameRate,width-100,height-15);
  text("theneuronproject",width-100,height-5);
}


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
    }
    if (location.y > height || location.y < 0) {
      velocity.y *= -0.9;  // A little dampening when hitting the bottom
      location.y = height/2;
    }
  }
}
