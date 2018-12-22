import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
LeapMotion leap;
boolean lefthand;
boolean righthand;
float[] position = new float[3];
float[] grabstrength = new float[2];
float[] stretchedfingers = new float[5];
float[] direction = new float[3];
float[] dynamics = new float[3];

//OSC ADDRESSES
int recvport = 3000;
int sendport = 4000;

// ======================================================
// 1. Callbacks
void leapOnInit() {println("Leap Motion Init");}
void leapOnConnect() {println("Leap Motion Connect");}
void leapOnFrame() {redraw();}
void leapOnDisconnect() {println("Leap Motion Disconnect");}
void leapOnExit() {println("Leap Motion Exit");}

void leapMotion() {
  righthand = false;
  stretchedfingers = new float[5];
  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    // ==================================================
    // 2. Hand 
    if(hand.isLeft()==true){break;} // limit to right hand
    if(hand.isRight()==true){righthand = true;}
    int     handId             = hand.getId();
    PVector handPosition       = hand.getPosition();
    PVector handStabilized     = hand.getStabilizedPosition();
    PVector handDirection      = hand.getDirection();
    PVector handDynamics       = hand.getDynamics();
    float   handRoll           = hand.getRoll();
    float   handPitch          = hand.getPitch();
    float   handYaw            = hand.getYaw();
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    float   handGrab           = hand.getGrabStrength();
    float   handPinch          = hand.getPinchStrength();
    float   handTime           = hand.getTimeVisible();
    PVector spherePosition     = hand.getSpherePosition();
    float   sphereRadius       = hand.getSphereRadius();
    //Get Hand Direction
    direction[0] = hand.getDirection().x;
    direction[1] = hand.getDirection().y;
    direction[2] = hand.getDirection().z;
    //Get Hand Dynamics
    dynamics[0] = hand.getDynamics().x;
    dynamics[1] = hand.getDynamics().y;
    dynamics[2] = hand.getDynamics().z;
    //Get Hand Position
    position[0] = hand.getPosition().x;
    position[1] = hand.getPosition().y;
    position[2] = hand.getPosition().z;
    //Scale Hand Position
    int scalex = width*2;
    int scaley = height*2;
    int scalez = 250;
    position[0] = (position[0]+(scalex/2))/scalex;
    position[1] = (position[1]+(scaley/2))/scaley;
    position[2] = (position[2]+(scalez/2))/scalez;
    //Limit Coordinates to 0-1
    for(int i=0;i<3;i++){
      if(position[i]>1){position[i]=1;}
      else if(position[i]<0){position[i]=0;}
    }
    //Get Hand Grab and Pinch Strength
    grabstrength[0] = hand.getGrabStrength();
    grabstrength[1] = hand.getPinchStrength();
    //Draw Hand
    hand.draw();
    // ==================================================
    // 3. Arm
    if (hand.hasArm()) {
      Arm     arm              = hand.getArm();
      float   armWidth         = arm.getWidth();
      PVector armWristPos      = arm.getWristPosition();
      PVector armElbowPos      = arm.getElbowPosition();
    }
    // ==================================================
    // 4. Finger
    Finger  fingerThumb        = hand.getThumb();
    Finger  fingerIndex        = hand.getIndexFinger();
    Finger  fingerMiddle       = hand.getMiddleFinger();
    Finger  fingerRing         = hand.getRingFinger();
    Finger  fingerPink         = hand.getPinkyFinger();
    
    //FINGER DIRECTION
    //for (Finger finger : hand.getFingers()) {
    //  println(finger.getDirection()); 
    //}
    
    for  (Finger finger : hand.getOutstretchedFingers()){
    //for (Finger finger : hand.getFingers()) {
    //for (Finger finger : hand.getOutstretchedFingersByAngle()) {
        int     fingerId         = finger.getId();
        PVector fingerPosition   = finger.getPosition();
        PVector fingerStabilized = finger.getStabilizedPosition();
        PVector fingerVelocity   = finger.getVelocity();
        PVector fingerDirection  = finger.getDirection();
        float   fingerTime       = finger.getTimeVisible();
        //Get Stretched Fingers
        stretchedfingers[finger.getType()] = 1;
    }
  }
  // ====================================================
  // 6. Devices
  for (Device device : leap.getDevices()) {
    float deviceHorizontalViewAngle = device.getHorizontalViewAngle();
    float deviceVericalViewAngle = device.getVerticalViewAngle();
    float deviceRange = device.getRange();
  }
}

//====== OSC SEND ======
void sendOsc(float[]output,String name) {
  OscMessage msg = new OscMessage(name);
  for (int i = 0; i < output.length; i++) {
    msg.add(output[i]);
  }
  oscP5.send(msg, dest);
}

//===== OSC RECEIVE =====
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/focuswindow")==true) {
    redraw();
    println(theOscMessage);
    focuswindow = theOscMessage.get(0).intValue();
    print("focuswindow: ");
    println(focuswindow);
  }
}

  
import processing.serial.*;

Serial myPort;  // The serial port


void setup() {
  surface.setAlwaysOnTop(true);
  size(600,400);
  background(255);
  leap = new LeapMotion(this);
  leap.allowBackgroundApps();
  oscP5 =new OscP5(this,recvport);
  dest = new NetAddress("127.0.0.1",sendport);
}

int focuswindow=0;

void draw(){
  //if(focuswindow==1){surface.setVisible(true);}
  frame.toFront();
  frame.repaint();
  background(255);
  leapMotion();
  if(righthand == true){
     sendOsc(position,"/leap/position");
     println(dynamics);  
     println(direction);
     sendOsc(dynamics,"/leap/dynamics");
     sendOsc(direction,"/leap/direction");
     sendOsc(grabstrength,"/leap/grabstrength");
     sendOsc(stretchedfingers,"/leap/stretchedfingers");
  }
}
