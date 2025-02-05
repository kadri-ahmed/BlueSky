import numpy as np

A = np.array([
    [0, -1, -1],
    [3, 0, 3],
    [4, 4, 0]
])

B = [
    [6, 0, 0],
    [0, 2, 0],
    [0, 0, 3]
]

print(A @ B @ A.T)