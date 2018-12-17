import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
 
void setup() {
  size(400,400);
  oscP5 = new OscP5(this,57110);
  myRemoteLocation = new NetAddress("127.0.0.1",56110);
}
 
 
void draw() {
  background(0);  
}
 
void mousePressed() {
  OscMessage myMessage = new OscMessage("/test");
  myMessage.add(123); 
  oscP5.send(myMessage, myRemoteLocation); 
}
 

void oscEvent(OscMessage theOscMessage) {
  println(theOscMessage);
  println(theOscMessage.get(0).intValue());
}
