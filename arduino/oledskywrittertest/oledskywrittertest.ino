//SkyWritter
//SCL -> SCL
//SDA -> SDA
#include <Wire.h>
#include <skywriter.h>

const int trftPin = 2;
const int resetPin = 3;

float x = 0;
float y = 0;
float z = 0;

void handle_xyz(unsigned int _x, unsigned int _y, unsigned int _z){
 char buf[17];
 sprintf(buf, "%05u:%05u:%05u", _x, _y, _z);
 x = float(_x)/65536;
 y = float(_y)/65536;
 z = float(_z)/65536;
}

//OLED
//DIN -> 11
//CLK -> 13
//CS -> 10
//DC -> 7
//RST -> 8
#include "OLED_Driver.h"
#include "OLED_GUI.h"
#include "DEV_Config.h"
#include "Show_Lib.h"
#include "Debug.h"

extern OLED_DIS sOLED_DIS;

void oledSetup(){
  System_Init();
  OLED_SCAN_DIR OLED_ScanDir = SCAN_DIR_DFT;
  OLED_Init( OLED_ScanDir );
  OLED_ClearBuf();
  OLED_ClearScreen(OLED_BACKGROUND);
  OLED_ClearBuf();
}

static char sx[6];
static char sy[6];
static char sz[6];
int oldY=0;
float out1=0;
float out2=0;
static char sout1[6];
static char sout2[6];
static char sb1[2];
static char sb2[2];

//Buttons
int b1pin=6;
int b2pin=5;

void oledLoop(){
  dtostrf(x, 4, 2, sx);
  dtostrf(y, 4, 2, sy);
  dtostrf(z, 4, 2, sz);
  dtostrf(out1, 4, 2, sout1);
  dtostrf(out2, 4, 2, sout2);
  dtostrf(digitalRead(b1pin), 1, 0, sb1);
  dtostrf(digitalRead(b2pin), 1, 0, sb2);
  GUI_DisString_EN(0, 0, "Neural Network", &Font12, FONT_BACKGROUND, WHITE);
  OLED_Display(0, 0, 128, 127);
  OLED_ClearBuf();
  GUI_DisString_EN(0, 0, "inputs: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(63, 0, "outputs: ", &Font12, FONT_BACKGROUND, WHITE);
  OLED_Display(0, 14, 128, 127);
  OLED_ClearBuf();
  GUI_DisString_EN(0, 0, "x: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(15, 0, sx, &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(63, 0, "1: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(79, 0, sout1, &Font12, FONT_BACKGROUND, WHITE);
  OLED_Display(0, 28, 128, 127);
  OLED_ClearBuf();
  GUI_DisString_EN(0, 0, "y: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(15, 0, sy, &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(63, 0, "2: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(79, 0, sout2, &Font12, FONT_BACKGROUND, WHITE);
  OLED_Display(0, 42, 128, 127);
  OLED_ClearBuf();
  GUI_DisString_EN(0, 0, "z: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(15, 0, sz, &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(63, 0, "b1: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(84, 0, sb1, &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(94, 0, "b2: ", &Font12, FONT_BACKGROUND, WHITE);
  GUI_DisString_EN(115, 0, sb2, &Font12, FONT_BACKGROUND, WHITE);
  OLED_Display(0, 56, 128, 127);
  OLED_ClearBuf();
  OLED_Display(0, 70+oldY, 128, 127);
  OLED_ClearBuf();
  GUI_DrawPoint(x*128, 0, WHITE, 2, DOT_STYLE_DFT);
  OLED_Display(0, 70+(56-(y*56)), 128, 127);
  oldY = (56-(y*56));
  OLED_ClearBuf();
}

//Main
void setup(){
  pinMode(b1pin,INPUT);
  pinMode(b2pin,INPUT);
  oledSetup();
  Skywriter.begin(trftPin, resetPin);
  Skywriter.onXYZ(handle_xyz);
}

void loop(){
  Skywriter.poll();
  out1=analogRead(0)/float(1024);
  out2=analogRead(1)/float(1024);
  oledLoop();
  delay(1000/60);
}
