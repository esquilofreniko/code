#include "ofApp.h"
#include <array>;

//--------------------------------------------------------------
void ofApp::setup() {
	ofSetVerticalSync(true);
	// ofBackground(255, 255, 255);
	ofSetLogLevel(OF_LOG_VERBOSE);
	midiIn.listInPorts();
	midiIn.openPort("Teensy MIDI");
	midiIn.ignoreTypes(false, false, false);
	midiIn.addListener(this);
	midiIn.setVerbose(false);

    ofSetFullscreen(true);
    // ofSetWindowShape(1920,1080);
    ofSetVerticalSync(true);
    ofEnableAlphaBlending();
	ofSetSmoothLighting(true);
    ofSetBackgroundAuto(false);
    ofSetBackgroundColor( 0, 0, 0 );
	ofEnableBlendMode(OF_BLENDMODE_ALPHA);

	for (int i = 0; i < numParticles; i++) {
        particle[i].init(ofRandom(ofGetWidth()),ofRandom(ofGetHeight()),0,1);
    }

    attractor[0].init(ofGetWidth()/2,ofGetHeight()/2,0,ofGetHeight()/12,25,0.05);

    attractor[1].init(ofGetWidth()/8,ofGetHeight()/8,0,ofGetHeight()/32,25,0.1);
    attractor[2].init(ofGetWidth()/8,(ofGetHeight()/8)*7,0,ofGetHeight()/32,25,0.1);
    attractor[3].init((ofGetWidth()/8)*7,ofGetHeight()/8,0,ofGetHeight()/32,25,0.1);
    attractor[4].init((ofGetWidth()/8)*7,(ofGetHeight()/8)*7,0,ofGetHeight()/32,25,0.1);

    box.set(ofGetWidth()*2);
    box.setPosition(ofGetWidth()/2,ofGetHeight()/2,0);
}

//--------------------------------------------------------------
void ofApp::update() {
	for(int j=minAttractor; j<activeAttractors;j++){
        // orientation += ofRandom(-2,2);
        // attractor[j].sphere.setOrientation(ofQuaternion(orientation,ofVec3f(ofGetWidth()/2,ofGetHeight()/2,0)));
        attractor[j].setRad(attractor[j].rad + ofRandom(-1,2));
        if(attractor[j].rad < 0){attractor[j].setRad(0);}
        if(attractor[j].rad > ofGetHeight()/8){attractor[j].setRad(ofGetHeight()/8);}
        if(j!=0){
            if(attractor[j].rad > ofGetHeight()/32){attractor[j].setRad(ofGetHeight()/32);}
        }
        for(int i=0;i<numParticles;i++){
            ofVec3f force = attractor[j].attract(particle[i],repel);
            if(j!=0){force = attractor[j].attract(particle[i],1);}
            particle[i].applyForce(force);
        }
    }
    for (int i=0;i<numParticles;i++){
        particle[i].checkEdges(0,ofGetWidth(),0,ofGetHeight());
        particle[i].update();
    }
    counter++;
    if(counter > counterMax){counter = 0;}
    if(counter == 0){
        repel = ofRandom(0,2);
        bgColor = repel * 255;
        counterMax = ofRandom(50,500);
    }
}

int note1 = -1;
int note1old = -1;
int vel1 = -1;
int vel1old = -1;
int counter = 0;

//--------------------------------------------------------------
void ofApp::draw() {
	for(unsigned int i = 0; i < midiMessages.size(); ++i) {
		ofxMidiMessage &message = midiMessages[i];
		stringstream text;
		text << ofxMidiMessage::getStatusString(message.status);
		if(message.status < MIDI_SYSEX) {
			if(message.status == MIDI_CONTROL_CHANGE) {
				//message.control
			}
			else if(message.status == MIDI_PITCH_BEND) {
				//message.value
			}
			else {
				note1 = message.pitch;
				vel1 = message.pitch;
				if(note1 < 64){
					for(int j=minAttractor; j<activeAttractors;j++){
						attractor[j].setRad(ofRandom(0,ofGetHeight()/8));
					}
				}
				else if(note1 > 65){
					repel += 1;
					repel %= 2;
				}
			}
			// if(note1 != note1old){
				// std::cout << "note: " << note1 << " velocity: " << vel1 << endl;
			// }	
			// note1old = note1;
		}
		counter++;
	}

	ofSetColor(bgColor,20);
    ofFill();
    box.draw();
    for (int i=0;i<numParticles;i++){
        particle[i].invert = 0;
        for(int j=minAttractor;j<activeAttractors;j++){
            if(particle[i].pos.distance(attractor[j].pos) < attractor[j].rad){
                particle[i].draw(bgColor,255);
                particle[i].invert = 1;
            }
            else if(particle[i].invert == 0){
                particle[i].draw(255-bgColor,255);
            }
        }
    }
    for(int j=minAttractor;j<activeAttractors;j++){
        attractor[j].draw(255-bgColor,10);
    }
}

//--------------------------------------------------------------
void ofApp::exit() {
	// clean up
	midiIn.closePort();
	midiIn.removeListener(this);
}

//--------------------------------------------------------------
void ofApp::newMidiMessage(ofxMidiMessage& msg) {

	// add the latest message to the message queue
	midiMessages.push_back(msg);

	// remove any old messages if we have too many
	while(midiMessages.size() > maxMessages) {
		midiMessages.erase(midiMessages.begin());
	}
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key) {
	switch(key) {
		case '?':
			midiIn.listInPorts();
			break;
		case 'f':
      		fs = !fs;
        	ofSetFullscreen(fs);
	}
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key) {
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y) {
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button) {
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button) {
}

//--------------------------------------------------------------
void ofApp::mouseReleased() {
}
