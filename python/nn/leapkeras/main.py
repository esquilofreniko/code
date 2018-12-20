import keras1
from keras1 import NeuralNetRegression
import numpy as np
import time
import argparse
import math
from pythonosc.osc_message_builder import OscMessageBuilder
from pythonosc.udp_client import UDPClient


#parameters
inputdimension  = 30
outputdimension = 30
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
try:
    while True:
        predictionsize = 1
        xin_ = np.random.rand(inputdimension,predictionsize)
        xin = xin_.T
        yout = nn.predict(xin)
        print("press CTRL+C to Quit...")
        time.sleep(0.1)
except KeyboardInterrupt:
    pass


