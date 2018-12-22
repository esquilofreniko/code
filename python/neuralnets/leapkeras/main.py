import keras1
import numpy as np
import time
import argparse
import math
import keyboard
from osc import OscClient
from osc import OscServer
from keras1 import NeuralNetRegression

#parameters
inputdimension  = 3
outputdimension = 256
nExamples = 100
nHidden = 10
nNodes = 100
epochs = 1000

# random examples
x = np.random.rand(nExamples,inputdimension)
y = np.random.rand(nExamples,outputdimension)

# train
nn = NeuralNetRegression(x,y,nHidden,nNodes)
nn.train(x,y,nExamples,epochs)

nExamples = 0
x = np.array([0])
y = np.array([0])

#Predict    l
oscserverxin = 0
oscserver = OscServer("127.0.0.1",4000,'/leap/position','/kerasYin')
oscclient = OscClient("127.0.0.1",5000,'/kerasYout')
oscclientfocuswindow = OscClient("127.0.0.1",3000,'/focuswindow')

# Toggle Window Focus on Leap Motion
focuswindow = [0,0]
def toggleFocusWindow():
    focuswindow[0] += 1
    focuswindow[0] %= 2
    print("focuswindow:",focuswindow[0])
    oscclientfocuswindow.sendMsg([focuswindow])
keyboard.add_hotkey('shift + v', lambda: toggleFocusWindow())

print("focuswindow:",focuswindow)
print("/q: quit","e: add example","/r: remove example","/t: train", "/shift + v: toggle focus leap")
while True:
    time.sleep(0.01)
    # try: 
    #if keyboard.is_pressed('e'):
    #    if(nExamples==0):
    #        x = oscserver.xin
    #        y = oscserver.yin
    #    else:
    #        x = np.vstack((x,oscserver.xin))
    #        y = np.vstack((y,oscserver.yin))
    #    print(x)
    #    print(y)
    #    nExamples += 1
    #    print("Added Example")
    #    print("Number of Examples:", nExamples)
    #    pass
    #if keyboard.is_pressed('r'):
    #    nExamples -= 1
    #    x = x[:-1]
    #    y = y[:-1]
    #    print(x)
    #    print(y)
    #    if(nExamples<0):nExamples=0
    #    print("Removed Example")
    #    print("Number of Examples:", nExamples)
    #    pass
    #if keyboard.is_pressed('t'):
    #    # train
    #    nn = NeuralNetRegression(x,y,nHidden,nNodes)
    #    nn.train(x,y,nExamples,epochs)
    #    pass
    if keyboard.is_pressed('q'): 
        focuswindow[0] = 0
        print("focuswindow:",focuswindow[0])
        oscclientfocuswindow.sendMsg([focuswindow])
        oscserver.server.shutdown()
        quit()
        break
    if(oscserverxin != oscserver.xin):
        xin = np.array([oscserver.xin])
        yout = nn.predict(xin)
        yout = yout.tolist()
        oscclient.sendMsg(yout)
        oscserverxin = oscserver.xin
        print("OSC server listening on {}".format(oscserver.server.server_address),"with handlers:",oscserver.xhandler,oscserver.yhandler)
        print("focuswindow:",focuswindow)
        print("/q: quit","/e: add example","/r: remove example","/t: train", "/shift + v: toggle focus leap")
        pass
    else:
        pass
    # except:
    #     oscserver.server.shutdown()
    #     quit()
    #     break
