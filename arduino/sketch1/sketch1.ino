#include <dht.h>

dht DHT;

#define DHT11_PIN 7

const int trigPin = 9;
const int echoPin = 10;

long duration;
int distance;

void setup(){
	pinMode(trigPin, OUTPUT);
	pinMode(echoPin, INPUT);
	Serial.begin(115200);
}

void loop(){
	digitalWrite(trigPin,LOW);
	delayMicroseconds(2);
	digitalWrite(trigPin,HIGH);
	delayMicroseconds(10);
	digitalWrite(trigPin,LOW);
	duration = pulseIn(echoPin,HIGH);
	distance = duration*0.034/2;

	int chk = DHT.read11(DHT11_PIN);
	Serial.print(distance);
	Serial.print(" ");
	Serial.print(DHT.temperature);
	Serial.print(" ");
	Serial.println(DHT.humidity);
}

