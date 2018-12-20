import unittest
import numpy as np
from perceptron import Perceptron

class PerceptronTest(unittest.TestCase):

    def test_mimics_logical_and(self):
        weights = np.array([-1, 1, 1])

        a = 1
        b = 1
        inputs = np.array([a, b])

        perceptron = Perceptron(inputs.size)
        perceptron.weights = weights

        output = perceptron.predict(inputs)
        self.assertEqual(output, a & b)

    def test_trains_for_logical_and(self):
        labels = np.array([1, 0, 0, 0])
        input_matrix = []
        input_matrix.append(np.array([1, 1]))
        input_matrix.append(np.array([1, 0]))
        input_matrix.append(np.array([0, 1]))
        input_matrix.append(np.array([0, 0]))

        perceptron = Perceptron(2, threshold=10, learning_rate=1)
        perceptron.train(input_matrix, labels)

        a = 1
        b = 1
        inputs = np.array([a, b])

        output = perceptron.predict(inputs)
        self.assertEqual(output, a & b)

if __name__ == '__main__':
        unittest.main()

? np.array
