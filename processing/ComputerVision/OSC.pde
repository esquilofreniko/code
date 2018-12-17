import oscP5.*;
import netP5.*;

int numOutputs = 5;
OscP5 oscP5;
NetAddress dest;


void oscInit(){
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for(int i=0;i<numOutputs;i++){
   if(i*3<blobs.size()){
     Blob b = blobs.get(i);
     PVector m = b.getScaledCenter();
     msg.add(m.x); 
     msg.add(m.y);
     msg.add(m.z);
   } else if(i*3>=blobs.size()){
     msg.add(0.0);
     msg.add(0.0);
     msg.add(0.0);
   }
  }
  oscP5.send(msg, dest);
}
