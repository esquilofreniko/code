# code adapted from:
# https://towardsdatascience.com/how-to-build-your-own-neural-network-from-scratch-in-python-68998a08e4f6

import matplotlib.pyplot as plt
import numpy as np
import time

def sigmoid(x):
    return 1.0/(1+ np.exp(-x))

def sigmoid_derivative(x):
    return x * (1.0 - x)

class NeuralNetwork:
    def __init__(self, x, y, nHidden):
        self.input      = x
        self.inputsize  = self.input.shape[0]
        self.nExamples  = self.input.shape[1]
        self.y          = y
        self.nHidden    = nHidden
        self.weights1   = np.random.rand(self.inputsize,self.nExamples)
        self.weights2   = np.random.rand(self.nHidden,self.inputsize) 
        self.d_weights2 = np.random.rand(self.nHidden,self.inputsize)
        self.hidden     = np.zeros([self.nHidden,self.inputsize])              
        self.output     = np.zeros([self.inputsize])
        self.error = np.zeros(self.inputsize)


    def feedforward(self,x):
        self.input = x
        print self.weights1
        print self.hidden[0]
        self.hidden[0] = sigmoid(self.input * self.weights1)
        for i in range(1,self.nHidden):
            self.hidden[i] = sigmoid(self.hidden[i-1] * self.weights2[i-1])
        self.output = sigmoid(self.hidden[self.nHidden-1])
        print sum(self.output)

    def backprop(self):
        # application of the chain rule to find derivative of the loss function with respect to weights2 and weights1
        for i in range(1,self.nHidden):
                self.error = pow(self.y,2) - pow(self.output,2)
                # print sum(self.error)
                self.d_weights2[i] = self.hidden[i] * (2*(self.y - self.output) * sigmoid_derivative(self.output))
        self.d_weights1 = self.input *  (2*(self.y - self.output) * sigmoid_derivative(self.output)) * ((self.weights2[0]) * sigmoid_derivative(self.hidden[0]))

        # update the weights with the derivative (slope) of the loss function
        self.weights1 = self.d_weights1.T + self.weights1
        for i in range(self.nHidden):
            for j in range(self.nNodes):
                self.weights2[i][j] = self.weights2[i][j] + self.d_weights2[i][j]

# if __name__ == "__main__":
x = np.random.rand(4,2)
y = np.random.rand(4,2)
plt.plot(x,y,'ro')
nn = NeuralNetwork(x,y,2)

for i in range(10000):
    nn.feedforward(x)
    nn.backprop()
    # plt.scatter(x,nn.output)
    # plt.pause(0.05)
    
for i in range(1000):
    xtest = np.array([[i/1000.0]])
    nn.feedforward(nn.output)
    plt.scatter(xtest,nn.output)

plt.show()

