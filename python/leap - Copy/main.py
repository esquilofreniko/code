import keyboard
import os, sys, inspect, threading, time
import numpy as np
src_dir = os.path.dirname(inspect.getfile(inspect.currentframe()))
# Windows and Linux
arch_dir = '../lib/x64' if sys.maxsize > 2**32 else '../lib/x86'
sys.path.insert(0, os.path.abspath(os.path.join(src_dir, arch_dir)))
import Leap

class SampleListener(Leap.Listener):
    def on_connect(self, controller):
        print("Connected")

    def on_frame(self, controller):
        frame = controller.frame()
        stretchedfingers = np.zeros(5)
        ftposition = np.zeros([5,3])
        ftdirection = np.zeros([5,3])
        ftvelocity = np.zeros([5,3])
        hands = frame.hands
        for h in hands:
            if h.is_right:
                position = h.palm_position
                direction = h.palm_normal
                velocity = h.palm_velocity
                grabstr = h.grab_strength
                pinchstr = h.pinch_strength
                for f in h.fingers:
                    if f.is_extended:
                        stretchedfingers[f.type] = 1
                    ftposition[f.type] = np.array([f.tip_position.x,f.tip_position.y,f.tip_position.z])
                    ftdirection[f.type] = np.array([f.direction.x,f.direction.y,f.direction.z])
                    ftvelocity[f.type] = np.array([f.tip_velocity.x,f.tip_velocity.y,f.tip_velocity.z])
                print(position)

from ctypes import *
from pyprocessing import *
import math
import OpenGL.GL as gl

c_int = 0;
def setup():
    size(200,200)
    noLoop()

def draw(): 
    # clear the whole screen
    background(200)
    lights()
    noStroke()
    background(200)
    pushMatrix()
    fill(255,255,0)
    translate(130,130)
    rotate(PI/6,1,1,0)
    box(50)
    popMatrix()
    fill(255,0,255)
    translate(60, 50)
    sphere(50)
    
    
run()

def main():

    listener = SampleListener()
    controller = Leap.Controller()
    controller.add_listener(listener)
    print("Press Enter to quit...")
    try:
        sys.stdin.readline()
    except KeyboardInterrupt:
        pass
    finally:
        controller.remove_listener(listener)
        
if __name__ == "__main__":
    main()