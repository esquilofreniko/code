import keras1
import numpy as np
import time
import argparse
import math
import keyboard
from osc import OscClient
from osc import OscServer
from keras1 import NeuralNetRegression
from pythonosc.osc_message_builder import OscMessageBuilder
from pythonosc.udp_client import UDPClient


#parameters
inputdimension  = 3
outputdimension = 3
nExamples = 20
nHidden = 10
nNodes = 100
epochs = 1000
x = np.random.rand(nExamples,inputdimension)
y = np.random.rand(nExamples,outputdimension)

# train
nn = NeuralNetRegression(x,y,nHidden,nNodes)
nn.train(x,y,nExamples,epochs)

#Predict    
oscservermsg = 0
oscserver = OscServer("127.0.0.1",4000,'/keras1in')
oscclient = OscClient("127.0.0.1",57120,'/keras1out')
while True:
    if(oscservermsg != oscserver.msg):
        xin = np.array([oscserver.msg])
        yout = nn.predict(xin)
        yout = yout.tolist()
        oscclient.sendMsg(yout)
        oscservermsg = oscserver.msg
        print("OSC server listening on {}".format(oscserver.server.server_address),"handler:",oscserver.handler)
        print("press q to quit...")
    try: 
        if keyboard.is_pressed('q'): 
            oscserver.server.shutdown()
            quit()
            break 
        else:
            pass
    except:
        oscserver.server.shutdown()
        quit()
        break