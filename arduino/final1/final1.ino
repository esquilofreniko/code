#include <MD_MAXPanel.h>
const MD_MAX72XX::moduleType_t HARDWARE_TYPE = MD_MAX72XX::FC16_HW;
const uint8_t X_DEVICES = 1;
const uint8_t Y_DEVICES = 1;
const uint8_t CLK_PIN = 30;
const uint8_t DATA_PIN = 32;
const uint8_t CS_PIN = 31;
MD_MAXPanel mp = MD_MAXPanel(HARDWARE_TYPE, DATA_PIN, CLK_PIN, CS_PIN, X_DEVICES, Y_DEVICES);
#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>
AudioPlaySdWav           playSdWav1;
AudioOutputAnalogStereo  audioOutput;
AudioAnalyzeFFT1024      fft1024;
AudioAnalyzePeak         peak1;
AudioConnection          patchCord1(playSdWav1, 0, audioOutput, 0);
AudioConnection          patchCord2(playSdWav1, 1, audioOutput, 1);
AudioConnection          patchCord3(playSdWav1, fft1024);
AudioConnection          patchCord4(playSdWav1, peak1);
#define SDCARD_CS_PIN    BUILTIN_SDCARD
int wavfilenumber;
String wavfile;
#include <Adafruit_AMG88xx.h>
Adafruit_AMG88xx amg;
float pixels[AMG88xx_PIXEL_ARRAY_SIZE];
float level[8];
int   shown[8];
int led = 13;                         
int motionstate = LOW;            
int lightsense = 33;
float averagetemp;
float oldaveragetemp;
int heatmotion;
float oldpixels[64];
float preaveragetemp;
int boxopened = 0;
int counter = 0;
const int counts = 20;
int lightsensibility = 100;
int light[counts];
int avglight = 0;
int oldavglight = 1000; 
int stickcounter = 0;
            
void setup() {
  mp.begin();
  mp.setRotation(MD_MAXPanel::ROT_90);
  pinMode(led, OUTPUT);      // initalize LED as an output
  pinMode(lightsense,INPUT);
  Serial.begin(9600);
  AudioMemory(12);
  bool status;
  status = amg.begin();
  if (!(SD.begin(SDCARD_CS_PIN))) {
    while (1) {
      Serial.println("Unable to access the SD card");
      delay(500);
    }
  }
  delay(100);
}

void loop(){
  delay(5);
  //Photoresistor
  light[counter] = analogRead(lightsense);
  if(counter == 0){
    avglight = 0;
    for(int i=0;i<counts;i++){
      avglight += light[i];
    }
    avglight = avglight / counts;
    if(avglight - oldavglight > lightsensibility){
      boxopened = true;
    }
    else if(oldavglight - avglight > lightsensibility){
      boxopened = false;
    }
    oldavglight = avglight;
    Serial.println(avglight);
    Serial.println(boxopened);
  }
  //Thermal Cam Motion Detector
  amg.readPixels(pixels);
  averagetemp = 0;
  heatmotion = 0;
  for(int i=0;i<64;i++){
    if(pixels[i] - oldpixels[i] > 5){
      heatmotion += 1;
    }
    oldpixels[i] = pixels[i];
    averagetemp += pixels[i+1];
  }
  averagetemp = averagetemp/64;
  if (heatmotion >= 1) {     
    Serial.println("Heat Motion Detected");     
    digitalWrite(led, HIGH); 
    if (motionstate == LOW) {
      preaveragetemp = averagetemp;
      motionstate = HIGH;
    }
  }
  if(counter == 0){ 
    if(heatmotion < 1){
      digitalWrite(led, LOW);          
      if (motionstate == HIGH){
        motionstate = LOW;       
      }
    }
  }
  
  if(motionstate==LOW){};
  if(motionstate==HIGH){};

  if(boxopened == false){
    mp.clear();
    delay(100);
  }
  
  if(boxopened == true){
    if (playSdWav1.isPlaying() == false) {
      wavfilenumber = random(1,227);
      wavfile = String(wavfilenumber) + ".WAV";
      playSdWav1.play(wavfile.c_str());
      stickcounter = 4;
    }
    if(peak1.available()){
      int peak = peak1.read() * 30.0;
      if(peak >= 30){
        if(stickcounter >= 4){
          mp.clear();
          dancingStickman();
          stickcounter = 0;
        }
      }
    }
//    if (fft1024.available()) {
//      level[0] =  fft1024.read(0,1);
//      level[1] =  fft1024.read(2, 6);
//      level[2] =  fft1024.read(7, 15);
//      level[3] =  fft1024.read(16, 32);
//      level[4] =  fft1024.read(33, 66);
//      level[5] = fft1024.read(67, 131);
//      level[6] = fft1024.read(132, 257);
//      level[7] = fft1024.read(258, 501);
////      for (int i=0; i<8; i++) {
////        shown[i] = level[i] * 4;
////      }
////      mp.clear();
////      for (int x = 0; x<8; x++){
////        mp.drawLine(x,0,x,shown[x], true);
////      }
//    }
  }
  stickcounter ++;
  counter ++;
  counter %= counts;
}

void dancingStickman(){
  int xoffset = random(1,5);
  int yoffset = random(4);
  //Head
  mp.setPoint(xoffset+1,4+yoffset,true);
  //Torso
  mp.drawLine(xoffset+1,2+yoffset,xoffset+1,4+yoffset);
  //Lefttarm
  mp.setPoint(xoffset,3+yoffset,true);
  int leftarmy = random(2,5);
  mp.setPoint(xoffset-1+random(2),leftarmy+yoffset,true);
  //RightArm
  mp.setPoint(xoffset+2,3+yoffset,true);
  int rightarmy = random(2,5);
  mp.setPoint(xoffset+3-random(2),rightarmy+yoffset,true);
  //LeftLeg
  mp.setPoint(xoffset,1+yoffset,true);
  mp.setPoint(xoffset-random(-1,2),0+yoffset,true);
  //RightLeg
  mp.setPoint(xoffset+2,1+yoffset,true);
  mp.setPoint(xoffset+2+random(-1,2),0+yoffset,true);
}
