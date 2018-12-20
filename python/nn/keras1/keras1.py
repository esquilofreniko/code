import keras1classes
from keras1classes import NeuralNetRegression
import numpy as np

# train
inputdimension  = 1
outputdimension = 1
nExamples = 20
nHidden = 10
nNodes = 100
epochs = 1000
x = np.random.rand(nExamples,inputdimension)
y = np.random.rand(nExamples,outputdimension)
nn = NeuralNetRegression(x,y,nHidden,nNodes)
nn.train(x,y,nExamples,epochs)

# predict
predictionsize = 100;
xin_ = np.zeros([inputdimension,predictionsize])
for i in range(inputdimension):
    xin_[i] = np.arange(predictionsize)/(predictionsize*1.0)
xin = xin_.T
yout = nn.predict(xin)
nn.plot(x,y,xin,yout)