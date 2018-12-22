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
    output[1] = (vectin[1]/scale)/2
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
    
    def on_connect(self, controller):
        print("Connected")

    def on_frame(self, controller):
        self.frame = controller.frame()
        self.hands = self.frame.hands
        for h in self.hands:
            if h.is_right:
                # self.box = self.frame.interaction_box
                self.stretchedfingers = np.zeros(5)
                self.position[0] = h.palm_position.x
                self.position[1] = h.palm_position.y
                self.position[2] = h.palm_position.z
                self.direction = h.palm_normal
                self.velocity = h.palm_velocity
                self.grabstr = h.grab_strength
                self.pinchstr = h.pinch_strength
                #scale position
                self.position = normalize(self.position,self.scalepos)
                for f in h.fingers:
                    if f.is_extended:
                        self.stretchedfingers[f.type] = 1
                    self.ftposition[f.type] = np.array([f.tip_position.x,f.tip_position.y,f.tip_position.z])
                    self.ftdirection[f.type] = np.array([f.direction.x,f.direction.y,f.direction.z])
                    self.ftvelocity[f.type] = np.array([f.tip_velocity.x,f.tip_velocity.y,f.tip_velocity.z])
                    #scale ftposition
                    self.ftposition[f.type] = normalize(self.ftposition[f.type],self.scalepos)

from tkinter import *
tk = Tk()
width = 509
height = 400
canvas = Canvas(tk, width=width, height=height, bd=0, highlightthickness=0)
canvas.pack()

def drawPoint(x,y,z,color):
    canvas.create_oval(x*width,(1-y)*height,x*width,(1-y)*height,width=z*20,fill=color,outline=color)

def drawLine(x,y,x2,y2,z,color):
    if(x>0 and x<1 and y>0 and y<1):
        canvas.create_line(x*width,(1-y)*height,x2*width,(1-y2)*height, fill=color)


def main():
    leap = SampleListener()
    leap.init()
    controller = Leap.Controller()
    controller.add_listener(leap)
    print("Press ESC to Quit...")
    while True:
        time.sleep(0.1)
        print(leap.ftposition)
        canvas.create_rectangle(0,0,width,height, fill='black')
        drawPoint(leap.position[0],leap.position[1],leap.position[2],'white')
        for i in range(leap.ftposition.T[0].size):
            drawPoint(leap.ftposition[i][0],leap.ftposition[i][1],leap.ftposition[i][2]/2,'white')
            drawLine(leap.position[0],leap.position[1],leap.ftposition[i][0],leap.ftposition[i][1],leap.position[2],'white')
        tk.update()
        if keyboard.is_pressed('ESC'):
            tk.quit()
            controller.remove_listener(leap)
            time.sleep(1)
            quit()
        
if __name__ == "__main__":
    main()