/*
 * Copyright (c) 2013 Dan Wilcox <danomatika@gmail.com>
 *
 * BSD Simplified License.
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 *
 * See https://github.com/danomatika/ofxMidi for documentation
 *
 */
#pragma once

#include "ofMain.h"
#include "Physics.h"
#include "ofxMidi.h"

#define numParticles 10000
#define numAttractors 5

class ofApp : public ofBaseApp, public ofxMidiListener {
	
public:
	
	void setup();
	void update();
	void draw();
	void exit();
	
	void keyPressed(int key);
	void keyReleased(int key);
	
	void mouseMoved(int x, int y );
	void mouseDragged(int x, int y, int button);
	void mousePressed(int x, int y, int button);
	void mouseReleased();

	float orientation = 0;
	int counter = 0;
	int counterMax = 100;
	int bgColor = 255;
	int repel = 1;
	int minAttractor = 0;
	int activeAttractors = 1;
	int sphereRadius;
	bool fs;
	Particle particle[numParticles];
	Attractor attractor[numAttractors];

	ofLight light;
	ofBoxPrimitive box;
	
	void newMidiMessage(ofxMidiMessage& eventArgs);
	
	ofxMidiIn midiIn;
	std::vector<ofxMidiMessage> midiMessages;
	std::size_t maxMessages = 10; //< max number of messages to keep track of
};
