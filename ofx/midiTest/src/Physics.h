#pragma once

#include "ofMain.h"

class Particle {
    public:
    ofVec3f pos;
    ofVec3f vel;
    ofVec3f acc;
    float mass;
    int invert = 0;

    void init(float x, float y, float z, float m);
    void applyForce(ofVec3f force);
    void update();
    void checkEdges(float xmin, float xmax, float ymin, float ymax);
    void draw(int color, int alpha);
    void draw(int r, int g, int b, int alpha);
};

class Attractor {
    public:
    float mass;
    float gmult;
    float G = 9.8;
    int rad;
    ofVec3f pos;
	ofSpherePrimitive sphere;

    void init(float x, float y, float z, int _rad, int res, float _gmult);
    void setRad(int _rad);
    ofVec3f attract(Particle p, bool repel);
    void draw(int color, int alpha);
};