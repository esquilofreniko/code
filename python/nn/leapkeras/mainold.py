import keras1
from keras1 import NeuralNetRegression
import numpy as np
import time

#parameters
inputdimension  = 4
outputdimension = 4
nExamples = 20
nHidden = 10
nNodes = 100
epochs = 1000
x = np.random.rand(nExamples,inputdimension)
y = np.random.rand(nExamples,outputdimension)

# train
nn = NeuralNetRegression(x,y,nHidden,nNodes)
nn.train(x,y,nExamples,epochs)

##Predict
try:
    while True:
        predictionsize = 1
        xin_ = np.random.rand(inputdimension,predictionsize)
        xin = xin_.T
        yout = nn.predict(xin)
        print("press CTRL+C to Exit")
        time.sleep(0.025)
except KeyboardInterrupt:
    pass

