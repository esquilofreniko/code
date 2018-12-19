import NeuralNetRegression
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from keras.models import Sequential
from keras.layers import Dense
from sklearn.datasets import make_regression
from sklearn.preprocessing import MinMaxScaler

class NeuralNetRegression:
    def __init__(self,x,y,nHidden,nNodes):
        # generate regression dataset
        self.x = x
        self.y = y
        self.inputdimension  = self.x.shape[1]
        self.outputdimension = self.y.shape[1]
        self.nHidden = nHidden
        self.nNodes = nNodes
        self.model = Sequential()
        self.model.add(Dense(self.nNodes, input_dim=self.inputdimension, activation='relu'))
        for i in range(nHidden-1):
            self.model.add(Dense(self.nNodes, activation='relu'))
        self.model.add(Dense(self.outputdimension, activation='linear'))

    def train(self,x,y,nExamlples,epochs):
        # define and fit the final model
        self.nExamples = nExamples
        self.epochs = epochs
        self.model.compile(loss='mse', optimizer='adam')
        self.model.fit(x, y, epochs=epochs,batch_size=nExamples,verbose=1)

    def predict(self,xin):
        # make a prediction
        self.xin = xin
        self.yout = self.model.predict(self.xin)
        # Print Inputs -> Output Prediction
        for i in range(predictionsize):
            print("X=%s, Predicted=%s" % (self.xin[i], self.yout[i]))
        return self.yout

    def plot(self,x,y,xin,yout):
        if(self.inputdimension == 1):
            #2dPlot
            plt.plot(x,y,'ro')
            plt.scatter(xin,yout)
            plt.show()
        elif(self.inputdimension == 2):
            #3dplot
            fig = plt.figure()
            ax = fig.gca(projection='3d')
            ax.scatter([x.T[0]], [x.T[1]], [y])
            for i in range(predictionsize):
                ax.scatter([xin[i][0]], [xin[i][1]], [yout[i]])
            ax.legend()
            plt.show()

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
predictionsize = 100;
xin_ = np.zeros([inputdimension,predictionsize])
for i in range(inputdimension):
    xin_[i] = np.arange(predictionsize)/(predictionsize*1.0)
xin = xin_.T
yout = nn.predict(xin)
nn.plot(x,y,xin,yout)
