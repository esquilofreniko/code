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
    def __init__(self, x, y):
        self.input      = x
        self.weights1   = np.random.rand(self.input.shape[1],4) 
        self.weights2   = np.random.rand(4,1)                 
        self.y          = y
        self.output     = np.zeros(self.y.shape)

    def feedforward(self,x):
        self.input = x
        self.layer1 = sigmoid(np.dot(self.input, self.weights1))
        self.output = sigmoid(np.dot(self.layer1, self.weights2))

    def backprop(self):
        # application of the chain rule to find derivative of the loss function with respect to weights2 and weights1
        d_weights2 = np.dot(self.layer1.T, (2*(self.y - self.output) * sigmoid_derivative(self.output)))
        d_weights1 = np.dot(self.input.T,  (np.dot(2*(self.y - self.output) * sigmoid_derivative(self.output), self.weights2.T) * sigmoid_derivative(self.layer1)))

        # update the weights with the derivative (slope) of the loss function
        self.weights1 += d_weights1
        self.weights2 += d_weights2

# if __name__ == "__main__":
x = np.random.rand(20,1)
y = np.random.rand(20,1)
plt.plot(x,y,'ro')
nn = NeuralNetwork(x,y)

for i in range(1500):
    nn.feedforward(nn.output)
    nn.backprop()
    # plt.scatter(x,nn.output)
    # plt.pause(0.05)

print(nn.output)

for i in range(1000):
    xtest = np.array([[i/1000.0]])
    nn.feedforward(xtest)
    plt.scatter(xtest,nn.output)

plt.show()