import oscP5.*;
import netP5.*;
OscP5 osc;
int[] msg = new int[10];
Attractor [] attractors = new Attractor[1];
int nMovers = 1000;
Mover [] movers = new Mover[nMovers];
boolean display;  // to display attractors
int gmult = 1;
float repelmult = 1;
int lr = 255;
int lg = 255;
int lb = 255;
int bgcol = 0;
int attract = 1;
int repel = 0;
float v1,v2,v3,v4,v5,v6,v7,v8;
int trig = 0;

void setup() {
  size(1000,1000,P3D);
  smooth();
  background(0);
  osc = new OscP5(this, 12001);
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(2, random(width), random(height));
    movers[i].size = nMovers;
    movers[i].id = i;
  }
  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(width/2, height/2, 25);
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/adress")) {
    msg[0] = theOscMessage.get(0).intValue();
  }
  if(msg[0]==3){
    v1 = random(width);
    v2 = random(height);
    v3 = random(width);
    v4 = random(height);
    v5 = random(width);
    v6 = random(height);
    v7 = random(width);
    v8 = random(height);
  }
  trig = 1;
}

int bgcolold = 0;
void draw() {
  if(msg[0] == 1){
    attract = 1;
    repel = 0;
    lr = 255;
    lg = 255;
    lb = 255;
    bgcol = 0;
  }
  if(msg[0] == 2){
    attract = 0; 
    repel = 1;
    lr = 0;
    lg = 0;
    lb = 0;
    bgcol = 255;
  }
  if(bgcol != bgcolold){
    background(bgcol,255);
  }
  bgcolold = bgcol;
  fill(bgcol, 25);
  rect(0, 0, width, height);
  pointLight(lr,lg,lb, width/2, height/2, 10000);
  int cWidth = int(width/2);
  int cHeight = int(height/2);
  int cWidthMin = (width/2) - (cWidth/2);
  int cWidthMax = (width/2) + (cWidth/2);
  int cHeightMin = (height/2) - (cHeight/2);
  int cHeightMax = (height/2) + (cHeight/2);
  strokeWeight(1);
  stroke(255-bgcol,255);
  fill(bgcol,0);
  rect(cWidthMin,cHeightMin,cWidth,cHeight);
  int forcemult = 5000;
  int repelmult = 10;
  for (int i = 0; i < movers.length; i++) {
    if(movers[i].location.x < cWidthMax && movers[i].location.x > cWidthMin && movers[i].location.y < cHeightMax && movers[i].location.y > cHeightMin){
      for ( int j = 0; j < attractors.length; j++) {
        PVector force = attractors[j].repel(movers[i]);
        force = force.mult(repelmult);
        movers[i].applyForce(force);
      }
    }
    else{
      if(trig == 1){
        if(msg[0] == 1){
          for ( int j = 0; j < attractors.length; j++) {
            PVector force = attractors[j].attract(movers[i]);
            force = force.mult(forcemult*2);
            movers[i].applyForce(force);
          }
        }
        else if(msg[0] == 2){
          for ( int j = 0; j < attractors.length; j++) {
            PVector force = attractors[j].repel(movers[i]);
            force = force.mult(forcemult);
            movers[i].applyForce(force);
          }
        }
      }
    }
    //movers[i].accelarator(cWidthMin,cWidthMax,cHeightMin,cHeightMax);
    movers[i].colision();
    movers[i].checkEdges(0,width,0,height,cWidthMin,cWidthMax,cHeightMin,cHeightMax);
    movers[i].update();
    movers[i].display();
  }
  
  
  //text("theneuronproject",2,10);
  textSize(12);
  text("theneuronproject",width-100,height-5);
  
  stroke(255-bgcol,255);
  //strokeWeight(1);
  //fill(0,255);
  //line(v1,v2,v3,v4);
  //line(v3,v4,v5,v6);
  //line(v5,v6,v1,v2);
  trig = 0;
}
