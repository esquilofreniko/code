void motionSense(){
  pushMatrix();
  translate(0,video.height);
  opencv2.loadImage(video);
  opencv2.updateBackground();
  opencv2.dilate();
  opencv2.erode();
  noFill();
  stroke(255);
  strokeWeight(2);
  for (Contour contour : opencv2.findContours()) {
    contour.draw();
  } 
  popMatrix();
}
