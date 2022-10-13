import time
from typing import List


Matrix = List[List[int]]


"""
Task 1
Write a Python function to do power factory. You need to implement enclosing scope as closure.  
Your closure factory function power_factory() takes an argument called `exp`.  
You can use this function to build closures that run different power operations.
```python 
>>> power = task_1(3)
>>> power(3)
9
>>> power(4)
64
>>> power(0)
0
"""


def task_1(exp):
    def power_factory(arg):
        return arg ** exp
    return power_factory
power = task_1(3)
power(3)
power(4)
power(0)


"""
Task 2
Write a Python function that can accept any num of positional and keyword arguments.
You need to print each value of argument in the order it's passed to the function.
You can use this function to build closures that run different power operations.
```python 
>>> task_2(1, 2, 3, moment=4, cap="arkadiy")
1
2
3
4
arkadiy
"""


def task_2(*args, **kwargs):
    for arg in args:
        print(arg)
    for key, value in kwargs.items():
        print(f"{value}")

task_2(1, 2, 3, moment = 4, cap = "arkadiy")


"""
Task 3
Write a Python decorator `helper` to simulate the following behavior. 
```python
@helper 
task_3
>>> task_3("John")
Hi, friend! What's your name?
Hello! My name is John.
See you soon!
"""


def helper(func):
    def naming(argm):
        line1 = "Hi, friend! What's your name?"
        print(line1)
        line2 = func(argm)
        line3 = "See you soon!"
        print(line3)
    return naming


@helper
def task_3(name: str):
    print(f"Hello! My name is {name}.")

task_3("John")


"""
Task 4
Write a Python decorator `timer` to measure runtime of function `task_4`.  
Note: Use `print(f"Finished {func.__name__} in {run_time:.4f} secs")` for printing result.
```python
@timer
task_4

>>> task_4()
Finished task_4 in 4.4489 secs
"""


def timer(func):
    def wrapper():
        t0 = time.time()
        res = func()
        t1 = time.time()
        run_time = t1 - t0
        print(f"Finished {func.__name__} in {run_time:.4f} secs")
        return res
    return wrapper


@timer
def task_4():
    return len([1 for _ in range(0, 10 ** 8)])

task_4()


"""
Task 5
Write a Python function to transpose 2D matrix.  
Given a 2D integer array matrix, return the transpose of matrix.  
The transpose of a matrix is the matrix flipped over its main diagonal, switching the matrix's row and column indices.
"""


def task_5(matrix: Matrix) -> Matrix:
    new_matrix = list(zip(*matrix))
    for row in new_matrix:
        print(row)
    return new_matrix


"""
Task 6
Write a Python function to find validity of a string of parentheses, '(', ')'.  
These brackets must be close in the correct order, for example "()".  
```python
>>> task_6("((()))")
True

>>> task_6(")()")
False
"""


def task_6(queue: str):
    pass
