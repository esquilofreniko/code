import keyboard
import os, sys, inspect, thread, time
import numpy as np
src_dir = os.path.dirname(inspect.getfile(inspect.currentframe()))
# Windows and Linux
arch_dir = '../lib/x64' if sys.maxsize > 2**32 else '../lib/x86'
sys.path.insert(0, os.path.abspath(os.path.join(src_dir, arch_dir)))
import Leap

def normalize(vectin,scale):
    output = np.zeros(3)
    output[0] = ((vectin[0]/scale)+1)/2
    output[1] = ((vectin[1]/scale))+1/2
    output[2] = ((vectin[2]/scale)+1)/2
    for i in range(vectin.size):
        if(output[i]<0): output[i] = 0
        elif(output[i]>1): output[i] = 1
    return output

class SampleListener(Leap.Listener):
    def init(self):
        self.stretchedfingers = np.zeros(5)
        self.ftposition = np.zeros([5,3])
        self.ftdirection = np.zeros([5,3])
        self.ftvelocity = np.zeros([5,3])
        self.position = np.zeros([3])
        self.direction = np.zeros([3])
        self.velocity = np.zeros([3])
        self.grabstr = 0
        self.pinchstr = 0
        self.scalepos = 500
        self.bone = np.zeros([5,4,3])
        self.arm = np.zeros([2,3])
    
    def on_connect(self, controller):
        print("Connected")

    def on_frame(self, controller):
        self.frame = controller.frame()
        self.hands = self.frame.hands
        for h in self.hands:
            if h.is_right:
                # self.box = self.frame.interaction_box
                self.stretchedfingers = np.zeros(5)
                # get scaled hand positiom
                self.position = normalize(np.array([h.palm_position.x,h.palm_position.y,h.palm_position.z]),self.scalepos)
                # get hand direction and velocity
                self.direction = h.palm_normal
                self.velocity = h.palm_velocity
                # get hand grab strength
                self.grabstr = h.grab_strength
                self.pinchstr = h.pinch_strength
                self.arm[0] = normalize(np.array([h.arm.elbow_position.x,h.arm.elbow_position.y,h.arm.elbow_position.z]),self.scalepos)
                self.arm[1] = normalize(np.array([h.arm.wrist_position.x,h.arm.wrist_position.y,h.arm.wrist_position.z]),self.scalepos)
                for f in h.fingers:
                    if f.is_extended:
                        self.stretchedfingers[f.type] = 1
                    #get scaled fingertips position
                    self.ftposition[f.type] = normalize(np.array([f.tip_position.x,f.tip_position.y,f.tip_position.z]),self.scalepos)
                    # get fingertips direction and velocity
                    self.ftdirection[f.type] = np.array([f.direction.x,f.direction.y,f.direction.z])
                    self.ftvelocity[f.type] = np.array([f.tip_velocity.x,f.tip_velocity.y,f.tip_velocity.z])
                    for i in range(4):
                        self.bone[f.type][i] = normalize(np.array([f.bone(i).center.x,f.bone(i).center.y,f.bone(i).center.z]),self.scalepos)

import math
import pyglet
import numpy as np
from pyglet.gl import *

import ctypes
user32 = ctypes.windll.user32
screensize = [user32.GetSystemMetrics(0), user32.GetSystemMetrics(1)]
print(screensize)

width = 600
height = 400
depth = 0
leap = SampleListener()
win = pyglet.window.Window(width,height)
win.set_location(screensize[0] - width, 0)
pyglet.graphics.glEnable(pyglet.graphics.GL_DEPTH_TEST)
pyglet.graphics.glEnable(pyglet.graphics.GL_BLEND)

label = pyglet.text.Label("Hello World!",
                            font_name="Times New Roman",
                            color=(255,255,255,255),
                            font_size=36,
                            x=win.width//2, y=win.height//2,
                            anchor_x="center", anchor_y="center")

def update(dt):
    if leap.position.all > 0:
        glClearColor(1,1,1,1)
        win.clear()
        glPointSize(5)
        gl.glColor4f(0,0,0,0)
        for i in range(5):
            if leap.ftposition[i].all > 0:
                glPointSize(5)
                glBegin(GL_POINTS) 
                glVertex3f((leap.arm[0][0]*2.0-0.5)*width,(leap.arm[0][1]*2.0-0.5)*height,((leap.arm[0][2])*2.0-0.5)*depth)
                glVertex3f((leap.arm[1][0]*2.0-0.5)*width,(leap.arm[1][1]*2.0-0.5)*height,((leap.arm[1][2])*2.0-0.5)*depth)
                # glVertex3f((leap.position[0]*2.0-0.5)*width,(leap.position[1]*2.0-0.5)*height,((leap.position[2])*2.0-0.5)*depth)
                for j in range(4):
                    glVertex3f((leap.bone[i][j][0]*2-0.5)*width,(leap.bone[i][j][1]*2-0.5)*height,((leap.bone[i][j][2])*2-0.5)*depth)
                glEnd()
                glLineWidth(2)
                glBegin(GL_LINE_STRIP)
                glVertex3f((leap.arm[0][0]*2.0-0.5)*width,(leap.arm[0][1]*2.0-0.5)*height,((leap.arm[0][2])*2.0-0.5)*depth)
                glVertex3f((leap.arm[1][0]*2.0-0.5)*width,(leap.arm[1][1]*2.0-0.5)*height,((leap.arm[1][2])*2.0-0.5)*depth)
                glEnd()
                glBegin(GL_LINE_STRIP)
                for j in range(4):
                    glVertex3f((leap.bone[i][j][0]*2-0.5)*width,(leap.bone[i][j][1]*2-0.5)*height,((leap.bone[i][j][2])*2-0.5)*depth)
                glEnd()
                glBegin(GL_LINE_STRIP)
                glVertex3f((leap.arm[1][0]*2.0-0.5)*width,(leap.arm[1][1]*2.0-0.5)*height,((leap.arm[1][2])*2.0-0.5)*depth)
                for j in range(4):
                    glVertex3f((leap.bone[i][j][0]*2-0.5)*width,(leap.bone[i][j][1]*2-0.5)*height,((leap.bone[i][j][2])*2-0.5)*depth)
                glEnd()
        glBegin(GL_LINE_STRIP)                
        for i in range(5):
            glVertex3f((leap.bone[i][0][0]*2-0.5)*width,(leap.bone[i][0][1]*2-0.5)*height,((leap.bone[i][0][2])*2-0.5)*depth)
        glEnd() 
    if keyboard.is_pressed('ESC'):
        controller.remove_listener(leap)
        quit()

def main():
    leap.init()
    controller = Leap.Controller()
    controller.add_listener(leap)
    print("Press ESC to Quit...")
    glEnable(GL_TEXTURE_2D)
    glEnable(GL_BLEND)
    pyglet.clock.schedule_interval(update, 0.1)
    pyglet.app.run()

if __name__ == "__main__":
    main()