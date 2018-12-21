import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
LeapMotion leap;
boolean lefthand;
boolean righthand;
float[] handposition = new float[3];
float[] fingertips = new float[15];
float[] grabstrength = new float[2];
float[] stretchedfingers = new float[5];

// ======================================================
// 1. Callbacks
void leapOnInit() {println("Leap Motion Init");}
void leapOnConnect() {println("Leap Motion Connect");}
//void leapOnFrame() {println("Leap Motion Frame");}
void leapOnDisconnect() {println("Leap Motion Disconnect");}
void leapOnExit() {println("Leap Motion Exit");}

void leapMotion() {
  righthand = false;
  stretchedfingers = new float[5];
  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    // ==================================================
    // 2. Hand
    if(hand.isLeft()==true){break;}
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
    
    handposition[0] = hand.getPosition().x;
    handposition[1] = hand.getPosition().y;
    handposition[2] = hand.getPosition().z;
    grabstrength[0] = hand.getGrabStrength();
    grabstrength[1] = hand.getPinchStrength();
    

    // --------------------------------------------------
    // Drawing
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
    
    for  (Finger finger : hand.getOutstretchedFingers()){
        stretchedfingers[finger.getType()] = 1;
    }
    
    for (Finger finger : hand.getFingers()) {
      //for  (Finger finger : hand.getOutstretchedFingers()){
      // or              hand.getOutstretchedFingersByAngle();
      int     fingerId         = finger.getId();
      //println(fingerId);
      PVector fingerPosition   = finger.getPosition();
      PVector fingerStabilized = finger.getStabilizedPosition();
      PVector fingerVelocity   = finger.getVelocity();
      PVector fingerDirection  = finger.getDirection();
      float   fingerTime       = finger.getTimeVisible();
        switch(finger.getType()) {
        case 0:
          // System.out.println("thumb");
          PVector pos = finger.getPosition();
          fingertips[0] = pos.x;
          fingertips[1] = pos.y;
          fingertips[2] = pos.z;
          break;
        case 1:
          // System.out.println("index");
          pos = finger.getPosition();
          fingertips[3] = pos.x;
          fingertips[4] = pos.y;
          fingertips[5] = pos.z;
          break;
        case 2:
          // System.out.println("middle");
          pos = finger.getPosition();
          fingertips[6] = pos.x;
          fingertips[7] = pos.y;
          fingertips[8] = pos.z;
          break;
        case 3:
          // System.out.println("ring");
          pos = finger.getPosition();
          fingertips[9] = pos.x;
          fingertips[10] = pos.y;
          fingertips[11] = pos.z;
          break;
        case 4:
          // System.out.println("pinky");
          pos = finger.getPosition();
          fingertips[12] = pos.x;
          fingertips[13] = pos.y;
          fingertips[14] = pos.z;
          break;
        }
      }

      // ------------------------------------------------
      // Drawing:
       //finger.draw();  // Executes drawBones() and drawJoints()
       //finger.drawBones();
       //finger.drawJoints();
      //// ------------------------------------------------
      //// 5. Bones
      //// --------
      //// https://developer.leapmotion.com/documentation/java/devguide/Leap_Overview.html#Layer_1
      //Bone    boneDistal       = finger.getDistalBone();
      //Bone    boneIntermediate = finger.getIntermediateBone();
      //Bone    boneProximal     = finger.getProximalBone();
      //Bone    boneMetacarpal   = finger.getMetacarpalBone();
      //// ------------------------------------------------
      //// Touch emulation
      //int     touchZone        = finger.getTouchZone();
      //float   touchDistance    = finger.getTouchDistance();
      //switch(touchZone) {
      //case -1: // None
      //  break;
      //case 0: // Hovering
      //   //println("Hovering (#" + fingerId + "): " + touchDistance);
      //  break;
      //case 1: // Touching
      //   //println("Touching (#" + fingerId + ")");
      //  break;
      //}
    //}
  }
  
  // ====================================================
  // 6. Devices
  for (Device device : leap.getDevices()) {
    float deviceHorizontalViewAngle = device.getHorizontalViewAngle();
    float deviceVericalViewAngle = device.getVerticalViewAngle();
    float deviceRange = device.getRange();
  }
 
  ////scaleposition
  //int scalex = width*2;
  //int scaley = height*2;
  //int scalez = 250;
  //handposition[0] = handposition[0]/
   
  //scale fingertips
  int scalex = width*2;
  int scaley = height*2;
  int scalez = 250;
  for(int j=0;j<fingertips.length;j++){
     if(j%3==0){fingertips[j] = (fingertips[j] + (scalex/2))/scalex;}
     else if(j%3==1){fingertips[j] = (fingertips[j] + (scaley/2))/scaley;}
     else if(j%3==2){fingertips[j] = (fingertips[j] + (scalez/2))/scalez;}
     //Limit Coordinates to 0-1
     if(fingertips[j] > 1){fingertips[j] =1;}
     else if(fingertips[j] < 0){fingertips[j]=0;}  
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

void setup() {
  size(800,600,OPENGL);
  background(255);
  leap = new LeapMotion(this);
  oscP5 =new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",4000);
}

void draw(){
  background(255);
  leapMotion();
  if(righthand == true){
     println(handposition);
     sendOsc(fingertips,"/kerasXin");
     sendOsc(stretchedfingers,"/leap/stretchedfingers");
     sendOsc(handposition,"/leap/handposition");
     sendOsc(grabstrength,"/leap/grabstrength");
  }
}
