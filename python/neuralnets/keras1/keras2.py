import NeuralNetRegression
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from keras.models import Sequential
from keras.layers import Dense
from sklearn.datasets import make_regression
from sklearn.preprocessing import MinMaxScaler

inputdimension  = 1
outputdimension = 1
nExamples = 10
nHidden = 10
nNodes = 100
epochs = 1000
x = np.random.rand(nExamples,inputdimension)
y = np.random.rand(nExamples,outputdimension)
nn = NeuralNetRegression(x,y,nHidden,nNodes)
nn.train(x,y,nExamples,epochs)
predictionsize = 100;
xin_ = np.zeros([inputdimension,predictionsize])
for i in range(inputdimension):
    xin_[i] = np.arange(predictionsize)/(predictionsize*1.0)
xin = xin_.T
yout = nn.predict(xin)
nn.plot(x,y,xin,yout)
