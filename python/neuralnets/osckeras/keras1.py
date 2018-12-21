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

    def train(self,x,y,nExamples,epochs):
        # define and fit the final model
        self.nExamples = nExamples
        self.epochs = epochs
        self.model.compile(loss='mse', optimizer='adam')
        self.model.fit(x, y, epochs=epochs,batch_size=self.nExamples,verbose=1)

    def predict(self,xin):
        # make a prediction
        self.xin = xin
        self.yout = self.model.predict(self.xin)
        # Print Inputs -> Output Prediction
        # for i in range(self.xin.shape[0]):
        #     print("Inputs=",self.xin[i])
        #     print("Predicted=",self.yout[i])
        print("Predicted",self.outputdimension,"Outputs from",self.inputdimension,"Inputs")
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
            for i in range(self.xin.shape[0]):
                ax.scatter([xin[i][0]], [xin[i][1]], [yout[i]])
            ax.legend()
            plt.show()