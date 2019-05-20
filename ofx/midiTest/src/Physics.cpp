#include "Physics.h"

void Particle::init(float x, float y, float z, float m){
    mass = m;
    pos.x = x; pos.y = y; pos.z = z;
    vel.x = 0; vel.y = 0; vel.z = 0;
    acc.x = 0; acc.y = 0; acc.z = 0;
}

void Particle::applyForce(ofVec3f force) {
    // Newton's 2nd law: A = F / M
    ofVec3f f = force / mass;
    acc += f;
}

void Particle::update(){
    vel = vel + acc;
    pos = pos + vel;
    vel = vel * 0.99;
    acc = acc * 0;
}

void Particle::checkEdges(float xmin, float xmax, float ymin, float ymax){
    if (pos.x > xmax || pos.x < xmin) {
        // vel *= 0.99;
        vel.x *= ofRandom(-1,-0.5);
    }
    if (pos.y > ymax || pos.y < ymin) {
        // vel *= 0.99;
        vel.y *= ofRandom(-1,-0.5);
    }
    if(pos.x > xmax){
        pos.x = xmax;
    }
    if(pos.x < xmin){
        pos.x = xmin;
    }
    if(pos.y > ymax){
        pos.y = ymax;
    }
    if(pos.y < ymin){
        pos.y = ymin;
    }
}

void Particle::draw(int color, int alpha){ 
    ofSetColor(color,alpha);
    ofDrawCircle(pos.x,pos.y,pos.z,mass);
}

void Particle::draw(int r, int g, int b, int alpha){
    ofSetColor(r,g,b,alpha);
    ofDrawCircle(pos.x,pos.y,pos.z,mass);
}

void Attractor::init(float x, float y, float z, int _rad, int res, float _gmult){
    pos.x = x;
    pos.y = y;
    pos.z = z;
    gmult = _gmult;
    rad = _rad;
    mass = rad;
    G = G * gmult;
    sphere.setRadius(rad);
    sphere.setResolution(res);
    sphere.setPosition(x,y,z);
}

ofVec3f Attractor::attract(Particle p, bool rep){
    ofVec3f force = pos - p.pos; //force direction
    float distance = force.length();
    distance = ofClamp(distance, 5, 25); //constraint distance
    force.normalize();
    float strength = (G*mass*p.mass) / (distance * distance);
    force = force * strength;
    if(rep == 0){
        force = force * -1;
    }
    return force; 
}

void Attractor::setRad(int _rad){
    mass = _rad;
    rad = _rad;
    sphere.setRadius(rad);
}

void Attractor::draw(int color, int alpha){
        if(color == 0){sphere.setResolution(20);}
        else{sphere.setResolution(20);}
        ofSetColor(color,alpha);
        ofFill();
        sphere.draw();
        ofSetColor(color,alpha*2);
        ofFill();
        sphere.drawWireframe();
}