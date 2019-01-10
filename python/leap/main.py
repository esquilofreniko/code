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

def normalizevel(vectin,scale):
    output = np.zeros(3)
    output[0] = (vectin[0]/scale)
    output[1] = (vectin[1]/scale)
    output[2] = (vectin[2]/scale)
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
        print("Leap Connected")

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
                self.direction = np.array([h.palm_normal.x,h.palm_normal.y,h.palm_normal.z])
                self.velocity = normalizevel(np.array([h.palm_velocity.x,h.palm_velocity.y,h.palm_velocity.z]),self.scalepos)
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

import OSC
osckerasport = 4000
oscmaxport = 4001
oscclientkeras = OSC.OSCClient()
oscclientmax = OSC.OSCClient()
oscclientkeras.connect(('127.0.0.1', osckerasport))
oscclientmax.connect(('127.0.0.1',oscmaxport))

print("sending OSC messages to ports:",osckerasport, oscmaxport)

def sendOscMsg(client,arguments,address):
    oscmsg = OSC.OSCMessage()
    oscmsg.setAddress(address)
    for i in arguments:
        oscmsg.append(i)
    client.send(oscmsg)

from tkinter import *
tk = Tk()
width = 600
height = 400
depth = 4
ws = tk.winfo_screenwidth() # width of the screen
hs = tk.winfo_screenheight() # height of the screen
tk.geometry('%dx%d+%d+%d' % (width, height, ws-width-5, -30))
canvas = Canvas(tk, width=width, height=height, bd=0, highlightthickness=0)
canvas.pack()

def limit(tolimit):
    if tolimit < 0: tolimit = 0
    if tolimit > 1: tolimit = 1
    return tolimit

def drawPoint(x,y,z,color):
    x = limit((x*2)-0.5)
    y = limit(((1-y)*2)-0.5)
    z = limit((z*2)-0.5)
    canvas.create_oval(x*width,y*height,x*width,y*height,width=4,fill=color,outline=color)

def drawLine(x,y,x2,y2,z,color):
    x = limit((x*2)-0.5)
    y = limit(((1-y)*2)-0.5)
    x2 = limit((x2*2)-0.5)
    y2 = limit(((1-y2)*2)-0.5)
    z = limit((z*2)-0.5)
    canvas.create_line(x*width,y*height,x2*width,y2*height, width=1,fill=color)

def main():
    leap = SampleListener()
    leap.init()
    controller = Leap.Controller()
    controller.add_listener(leap)
    print("Press END to Quit...")
    while True:
        time.sleep(0.1)
        canvas.delete("all")
        canvas.create_rectangle(0,0,width,height, fill='black')
        drawPoint(leap.arm[0][0],leap.arm[0][1],leap.arm[0][2],'blue')
        drawPoint(leap.arm[1][0],leap.arm[1][1],leap.arm[1][2],'blue')
        for i in range(5):
            drawPoint(leap.ftposition[i][0],leap.ftposition[i][1],leap.ftposition[i][2],'white')
            for j in range(4):
                drawPoint(leap.bone[i][j][0],leap.bone[i][j][1],leap.bone[i][j][2],'white')
        drawLine(leap.arm[0][0],leap.arm[0][1],leap.arm[1][0],leap.arm[1][1],leap.arm[0][2],'blue')
        for i in range(5):
            for j in range(3):
                drawLine(leap.bone[i][j][0],leap.bone[i][j][1],leap.bone[i][j+1][0],leap.bone[i][j+1][1],leap.bone[i][j][2],'white')
            drawLine(leap.bone[i][3][0],leap.bone[i][3][1],leap.ftposition[i][0],leap.ftposition[i][1],leap.ftposition[i][2],'white')
        for i in range(4):
            drawLine(leap.bone[i][0][0],leap.bone[i][0][1],leap.bone[i+1][0][0],leap.bone[i+1][0][1],leap.bone[i][0][2],'purple')
        drawLine(leap.bone[4][0][0],leap.bone[4][0][1],leap.bone[0][0][0],leap.bone[0][0][1],leap.bone[4][0][2],'purple')
        for i in range(5):
            drawLine(leap.bone[i][0][0],leap.bone[i][0][1],leap.arm[1][0],leap.arm[1][1],leap.bone[4][0][2],'purple')
            drawLine(leap.bone[i][0][0],leap.bone[i][0][1],leap.arm[1][0],leap.arm[1][1],leap.bone[0][0][2],'purple')
        canvas.create_text(5,5,fill='white', anchor = "w", text = "Press END to Quit")
        sendOscMsg(oscclientkeras,[leap.position],'/leap/position')
        sendOscMsg(oscclientmax,[leap.ftposition],'/leap/ftposition')
        sendOscMsg(oscclientmax,[leap.stretchedfingers], '/leap/stretchedfingers')
        sendOscMsg(oscclientmax,[leap.grabstr],'/leap/grabstr')
        sendOscMsg(oscclientmax,[leap.pinchstr],'/leap/pinchstr')
        sendOscMsg(oscclientmax,[leap.velocity],'/leap/velocity')
        sendOscMsg(oscclientmax,[leap.direction],'/leap/direction')
        # sendOscMsg(oscclientmax,[leap.ftvelocity],'/leap/ftvelocity')
        # sendOscMsg(oscclientmax,[leap.ftdirection],'/leap/ftdirection')
        # sendOscMsg([leap.arm],'/leap/arm')
        # sendOscMsg([leap.bone],'/leap/bone')
        tk.update()
        if keyboard.is_pressed('END'):
            controller.remove_listener(leap)
            canvas.delete("all")
            canvas.quit()
            tk.quit()
            time.sleep(0.1)
            quit()

if __name__ == "__main__":
    main()