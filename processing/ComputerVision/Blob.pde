boolean toggleblobs = true;
boolean autoblobsort = true;
int distThresh = 150;
int minBlob = 1500;
ArrayList<Blob> blobs = new ArrayList<Blob>();
int lifespansize = 125;
int blobCounter = 0;
color trackColor = color(0);
float [] blobSizes = new float[1000];

void delBlobs(){
   for(int i=0;i<blobs.size();i++){
    blobs.remove(i); 
   }
   blobCounter = 0;
}

void sortBlobs(){
  int index=0;
   for(Blob b : blobs){
      blobSizes[index] = b.size(); 
      index++;
   }
   sort(blobSizes);
   for(int i=0;i<blobs.size();i++){
     for(Blob b : blobs){
       if(b.size() == blobSizes[i]){
         b.id = i;
       }
     }
   }
   blobCounter = blobs.size();
}
void blobTracker(){
  if(autoblobsort == true){
    sortBlobs();
  }
  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();  
  for(int x=0;x<after.width;x++) {
    for(int y=0;y<after.height;y++){
     int loc = x + y * after.width;
     color currentColor = after.pixels[loc];
     float c = brightness(currentColor);
     if(c < bThresh) {
       after.pixels[loc] = 255;
       boolean found = false;
       for (Blob b : currentBlobs){
         if(b.isNear(x,y)){
           b.add(x,y);
           found = true;
           break;
         }
       }
       if(!found) {
         Blob b = new Blob(x,y);
         currentBlobs.add(b);
       }
     }
    }
  }
  for (int i=currentBlobs.size()-1;i>=0;i--) {
    if(currentBlobs.get(i).size() < minBlob){
      currentBlobs.remove(i);
    }
  }
  
  if(blobs.isEmpty() && currentBlobs.size() > 0){
    for(Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b); 
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()){
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();
        float d = PVector.dist(centerB,centerCB);
        if ( d < recordD && !cb.taken) {
          recordD = d;
          matched = cb;
        }
      }
      matched.taken = true;
      b.become(matched);
    }
    for(Blob b : currentBlobs) {
     if(!b.taken) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
     }
    }
  } else if (blobs.size() > currentBlobs.size()){
    for(Blob b : blobs) {
      b.taken = false;
    }
    //Match whatever blobs you can
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();
        float d = PVector.dist(centerB,centerCB);
        if ( d < recordD && !b.taken) {
          recordD = d;
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.lifespan = lifespansize;
        matched.become(cb);
      } 
    }
    for(int i=blobs.size()-1;i>=0;i--){
      Blob b = blobs.get(i);
      if(!b.taken) {
        if(b.checkLife()){
          blobs.remove(i);
        }
      }
    }
  }
  for (Blob b : blobs) {
    b.show();
  }
}

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  int id = 0;
  int lifespan = lifespansize;
  boolean taken = false;
  
  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }
  
  void add(float x, float y) {
    minx = min(minx,x);
    miny = min(miny,y);
    maxx = max(maxx,x);
    maxy = max(maxy,y);
  }
  
  boolean checkLife(){
    lifespan--;
    return lifespan < 0;
  }
  
  void show() {
   if(toggleblobs == true){
     stroke(0,0,255,lifespan*2);
     noFill();
     strokeWeight(1);
     beginShape();
     rectMode(CORNERS);
     rect(minx,miny,maxx,maxy);
     textSize(20);
     fill(0,0,255,lifespan*2);
     text(id, minx + (maxx-minx)*0.5,miny + (maxy-miny)*0.5);
   }
  }
  
  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
  }
  
  float size() {
    return (maxx-minx)*(maxy-miny);
  }
  
  PVector getCenter() {
    float x = (maxx - minx) * 0.5 + minx;
    float y = (maxy - miny) * 0.5 + miny;
    return new PVector(x,y);
  }
  PVector getScaledCenter() {
    float x = ((maxx - minx) * 0.5 + minx)/video.width;
    float y = ((maxy - miny) * 0.5 + miny)/video.height;
    int bsize = int((maxx-minx)*(maxy-miny)/(video.width)*(video.height));
    int round = 10000;
    x = int(x*round);
    y = int(y*round);
    x = x/round;
    y = y/round;
    return new PVector(x,y,bsize);
  }
  
  boolean isNear(float px, float py) {
   float cx = (minx + maxx) / 2;
   float cy = (miny + maxy) / 2;
   float d = dist(cx,cy,px,py);
   if(d < distThresh) {
     return true;
   } else {
     return false;
   }
  }
}
