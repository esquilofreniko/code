import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

void setup() {
  //fullScreen(2);
  size(1920,1080);
  background(0);
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  // start the Audio Input
  in.start();
  // patch the AudioIn
  fft.input(in);
}      

int[] bgcol = new int[3];

void draw() { 
  background(bgcol[0],bgcol[1],bgcol[2]);
  fft.analyze(spectrum);

  if(spectrum[2] > 0.2){
    for(int i=0;i<3;i++){
    bgcol[i] = int(random(0,0));
    }
  }

  stroke(255-bgcol[0],255-bgcol[1],255-bgcol[2]);
  for(int i = 0; i < bands; i++){
    if(i < 256){
      line( width-(256-i), 128, width-(256-i), 128 - spectrum[i]*4*256);
      float lnx = width/2+(width/4)*sin((TWO_PI/256)*i);
      float lny = height/2+(height/4)*cos((TWO_PI/256)*i);
      line(lnx,lny, lnx + (spectrum[i] * width/2), lny + (spectrum[i] * height/2));
    }  
  } 
  point(width/2,height/2);
}
