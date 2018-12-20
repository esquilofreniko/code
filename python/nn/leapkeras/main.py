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
inputdimension  = 1
outputdimension = 1
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
oscserver = OscServer("127.0.0.1",4000,"/test")
oscclient = OscClient("127.0.0.1",57120)
while True:
    # predictionsize = 1
    # xin_ = np.random.rand(inputdimension,predictionsize)
    if(oscservermsg != oscserver.msg):
        xin = np.array([oscserver.msg])
        yout = nn.predict(xin)
        oscservermsg = oscserver.msg
    # oscclient.sendMsg(np.random.rand(15))
        print("OSC server listening on {}".format(oscserver.server.server_address),"handler:",oscserver.handler)
        print("press q to quit...")
    time.sleep(0.05)
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
        pass 

