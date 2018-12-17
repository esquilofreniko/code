ControlP5 cp5;

void keyPressed() {
  if (key == ' ') {
    bbg = true;
    delBlobs();
    sortBlobs();
  }
  if(key == 't'){
   delBlobs();
   sortBlobs();
   toggleblobs = !toggleblobs; 
  }
  if(key == 'a'){
    autoblobsort = !autoblobsort;
    
  }
  if (key == 'r') {
    delBlobs();
    sortBlobs();
  }
}

void initControls() {
  cp5 = new ControlP5(this);
  cp5.addSlider("difThresh")
     .setLabel("difThresh")
     .setPosition(640,30)
     .setRange(0,255)
     ;
  cp5.addSlider("distThresh")
     .setLabel("distThres")
     .setPosition(640,50)
     .setRange(25,500)
     ;       
  cp5.addSlider("minBlob")
     .setLabel("minBlob")
     .setPosition(640,70)
     .setRange(100,10000)
     ;       
}

void drawText(){
  fill(255);
  textSize(12);
  text("Background Subtract and", 640,10);
  text("Persistent Blob Tracking",640,20);
  textSize(12);
  text("Outputs: ", 640, 100);
  textSize(10);
  text("Total Blobs: " + blobs.size(),640,110);
  int i=0;
  for(Blob b : blobs){
    text(i + ": " + b.getScaledCenter(),640,120+i*10);
    if(i >= 29){
     break; 
    }
    i++;
  }
  textSize(12);
  text(" Keybindings: ", 640,430);
  textSize(10);
  text(" 'space' to subtract bg", 640,440);
  text(" 't' to toggle blobs",640,450);
  if(autoblobsort == true){
   fill(0,255,0); 
  } else if(autoblobsort == false){
   fill(255,0,0); 
  }
  text(" 'a' to toggle blob autosort",640,460);
  fill(255);
  text(" 'r' to sort blobs by size",640,470);
  text("________________________________________",640,480);
  textSize(12);
  text("Motion and Speed Tracking", 640,490);
}
