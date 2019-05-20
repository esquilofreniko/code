import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

Attractor [] attractors = new Attractor[1];
Mover [] movers = new Mover[2000];
boolean display;  // to display attractors

int gmult = 100;
float repelmult = 1;

int lr = 255;
int lg = 255;
int lb = 255;
int bgcol = 0;
int [] shapevert = new int[60];

void setup() {
  fullScreen(P3D,2);
  smooth();
  //background(0);
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  in.start();
  fft.input(in);
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(1, random(height/2)+((width/2)-height/4), random(height/2)+height/4);
  }
  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(width/2, height/2, 25);
  }
  lr = 255;
  lg = 255;
  lb = 255;
  bgcol = 0;
}

float bassAvg = 0;
float bassSensibility = 0.05;
float midAvg = 0;
float midSensibility = 0.05;
float highAvg = 0;
float highSensibility = 0.05;


void update(){
  fft.analyze(spectrum);
  bassAvg = 0;
  midAvg = 0;
  highAvg = 0;
  for(int k = 0; k<64;k++){
    if(spectrum[k] > bassSensibility*16){
      for ( int j = 0; j < attractors.length; j++) {
        for (int i = 0; i < movers.length; i++) {
          PVector force = attractors[j].attract(movers[i]);
          movers[i].applyForce(force);
        }
      }
      lr = 255;
      lg = 255;
      lb = 255;
      bgcol = 0;
    }
    bassAvg += spectrum[k];
  }
  for(int k = 64; k<128 ;k++){
    if(spectrum[k] > midSensibility*16){
      for ( int j = 0; j < attractors.length; j++) {
        for (int i = 0; i < movers.length; i++) {
          PVector force = attractors[j].repel(movers[i]);
          movers[i].applyForce(force);
        }
      }
      lr = 0;
      lg = 0;
      lb = 0;
      bgcol = 255;
    }
    midAvg += spectrum[k];
  }
  for(int k = 0; k<256;k++){
    if(spectrum[k] > highSensibility*64){
      int index = int(random(0,20));
      shapevert[index] = (width/2-75) + int(random((width/2)-75,(width/2)+75));
      shapevert[index+20] = int(random((height/2)-75,(height/2)+75));
      shapevert[index+40] = int(random(0,0));
    }
    highAvg += spectrum[k];
  }
  bassAvg = bassAvg / 64;
  bassSensibility = bassAvg;
  midAvg = midAvg / 64;
  midSensibility = midAvg;
  highAvg = highAvg / spectrum.length;
  highSensibility = highAvg;
  for (int i = 0; i < movers.length; i++) {
    movers[i].checkEdges();
    movers[i].update();
  }
}

void draw() {
  update();
 
  fill(bgcol, 25);
  stroke(bgcol);
  rect(0, 0, width, height);
  
  fill(255-bgcol,125);
  stroke(255-bgcol,125);
  rect((width/2)-height/4, height/4, height/2, (height/2));
  
  for (int i = 0; i < movers.length; i++) {
    if(movers[i].location.x > (width/2)-height/4 && movers[i].location.x < (width/2)+height/4 && movers[i].location.y > height/4 && movers[i].location.y < (height/4)*3){
      fill(bgcol);
      stroke(bgcol);    
    }
    else {
      fill(255-bgcol);
      stroke(255-bgcol);
    }
    movers[i].display();
  }

  fill(255-bgcol);
  stroke(255-bgcol);
  beginShape();
  for(int i=0;i<20;i++){vertex(shapevert[i]-(width/12),shapevert[i+20],shapevert[i+40]);}
  endShape();
  beginShape();
  for(int i=0;i<20;i++){vertex((width-shapevert[i])+(width/12),shapevert[i+20],shapevert[i+40]);}
  endShape();
  
  fill(lr,lg,lb);
  stroke(lr,lg,lb);
  for(int i = 0; i < bands; i++){
    if(i < 256){
      line( width-(256-i), 128, width-(256-i), 128 - spectrum[i]*512);
      line( (i), height , (i), height  - spectrum[i]*512);
    }  
  }
  
  text("fps: "  + round(frameRate),2,10);
  text("theneuronproject",2,20); 
  text("fps: "  + round(frameRate),width-100,height-15);
  text("theneuronproject",width-100,height-5);
}
