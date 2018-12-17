void setup(){
 //size(800,600);
 fullScreen(2);
 background(0);
}


float headlinex = 0;
float headliney = 0;
float legslinex = 0;
float legsliney = 0;
int x = 0;


void draw(){
  if(x == 1){
  //fill(0,100);
  //rect(0,0,width,height);
  fill(255,100);
  ellipse(width/2,height/2,height/16*13,height/16*13);
  int movement = height/16;  
  headlinex = random(-movement,movement);
  headliney = random(-movement,movement);
  legslinex = random(-movement,movement);
  legsliney = random(-movement,movement);
  stroke(0,255);
  strokeWeight(10);
  fill(0,255);
  line(width/2+headlinex,height/32*9+headliney,width/2+legslinex,height/2+legsliney); 
  line(width/2+headlinex,height/64*22+headliney,width/32*19+random(-movement,movement),height/64*22+random(-movement,movement));
  line(width/2+headlinex,height/64*22+headliney,width/32*13+random(-movement,movement),height/64*22+random(-movement,movement));  
  line(width/2+legslinex,height/2+legsliney,width/16*7 + random(-movement,movement),height/8*6 + random(-movement,movement));  
  line(width/2+legslinex,height/2+legsliney,width/16*9 + random(-movement,movement),height/8*6 + random(-movement,movement)); 
  ellipse((width/2)+headlinex,(height/4-height/64)+headliney,height/8,height/8); 
  stroke(150,0,255);
  //point(width/64*33+headlinex,height/64*15+headliney);
  //point(width/64*31+headlinex,height/64*15+headliney);
  stroke(0);
  }
  x += 1;
  x = x%10;
}
