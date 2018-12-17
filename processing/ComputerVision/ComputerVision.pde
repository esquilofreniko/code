import gab.opencv.*;
import processing.video.*;
import controlP5.*;

int bThresh = 75;
int difThresh = 75;
boolean bbg = true;
PImage bg,img,after;
Capture video;
OpenCV opencv,opencv2;

void setup(){
  background(0);
  size(800, 960);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv2 = new OpenCV(this, 640, 480);
  opencv2.startBackgroundSubtraction(5, 3, 0.5);
  video.start();
  initControls();
  oscInit();
}

void draw(){
  background(0);
  video.read();
  video.loadPixels();
  img = video.get(0, 0, video.width, video.height);
  if(bbg == true){
    bg = video.get(0, 0, video.width, video.height);
    bbg = false;
  }
  opencv.loadImage(img);
  opencv.diff(bg);
  opencv.dilate();
  opencv.erode();
  opencv.threshold(difThresh);
  opencv.invert();
  after = opencv.getSnapshot();
  after.loadPixels();
  image(after,0,0);
  blobTracker();
  motionSense();
  sendOsc();
  drawText();
}
