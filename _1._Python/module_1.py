from numbers import Number
from typing import List, Tuple, Any


"""
Task 1
Write a Python function to find those numbers which are divisible by 3 and multiple of 5, between 1 and 1000 
(both included). Return list of correct numbers.
"""


def task_1():
    numbers = list(range(1, 1001))
    new_numbers = list()
    for i in numbers:
        if((i % 3 == 0) and (i % 5 == 0)):
            new_numbers.append(i)
    print(new_numbers)
    return new_numbers


task_1()


"""
Task 2
Write a Python function that accepts a string and calculate the number(integers) of digits and letters(english).
Return num of digits and num of letters.
Example:
```python
>>> task_2("12abd3")
(3,3)
>>> task_2("13454")
(5, 0)
>>> task_2("bad")
(0, 3)
"""


def task_2(queue: str):
    alfabeth = 0
    numb = 0
    for i in queue:
        if i.isalpha():
            alfabeth += 1
        elif i.isdigit():
            numb += 1
    result = (numb,) + (alfabeth,)
    print(result)
    return result


task_2("13454")


"""
Task 3
Write a Python function to compute the difference between two lists. __Each list consists of unique values!__  
Return tuple of differences.  
Sample data: ["red", "orange", "green", "blue", "white"], ["black", "yellow", "green", "blue"]  
Color1-Color2: ['white', 'orange', 'red']  
Color2-Color1: ['black', 'yellow']  
```python
>>> task_3(["red", "orange", "green", "blue", "white"], ["black", "yellow", "green", "blue"])
(['white', 'orange', 'red'], ['black', 'yellow'])
"""


def task_3(data_1: List[Any], data_2: List[Any]):
    diff1 = list(set(data_1) - set(data_2))
    diff2 = list(set(data_2) - set(data_1))
    diff3 = list(reversed(diff1))
    print('Color1 - Color2:', diff3)
    print('Color2 - Color1:', diff2)
    return diff3, diff2


task_3(["red", "orange", "green", "blue", "white"], ["black", "yellow", "green", "blue"])


"""
Task 4
Write a Python function to convert a list of multiple integers(non-negative) into a single integer. 
Example:
```python
>>> task_4([11, 44, 33])
114433
"""


def task_4(values: List[int]) -> int:
    result = int("".join(map(str, values)))
    print(result)
    return result


task_4([11, 44, 33])


"""
Task 5
Write a Python function to find the list in a list of lists whose sum of elements is the highest.  
If the nested lists have the same max sum, then you need to return first of them.  
Return this list.  
Example:
```python
>>> task_5([[1,2], [3], [0, 12, 17, 6]])
[0, 12, 17, 6]
"""


def task_5(batches: List[List[Number]]) -> List:
    max(batches, key=sum)
    print(max(batches, key=sum))
    return max(batches, key=sum)


task_5([[1,2], [3], [0, 12, 17, 6]])


"""
Task 6
Write a Python function to reverse integer without usage of converting to str.
```python
>>> task_6(123)
321
>>> task_6(-132)
-231
>>> task_6(2550)
552
"""


def task_6(value: int) -> int:
    pass


"""
Task 7
Write a Python function to find the first non-repeating character in given string.  
Return this symbol if it's existed. Otherwise, None has to be returned.
```python
>>> task_7("aba")
b
>>> task_7("aaaccc")
None
>>> task_7("aaacccb")
b
"""


def task_7(string: str):
    number = []
    count = {}
    for i in string:
        if i in count:
            count[i] += 1
        else:
            count[i] = 1
            number.append(i)
    for i in number:
        if count[i] == 1:
            print(i)
            return i
    print(None)


task_7("aba")
task_7("aaaccc")
task_7("aaacccb")


"""
Task 8
Implement a Python function with given list of integers.  
Return a new list such that each element at index `i` of the new list is the product of all the numbers in the original array except the one at `i`.
```python
>>> foo([1, 2, 3, 4, 5])
[120, 60, 40, 30, 24]

>>> foo([3, 2, 1])
[2, 3, 6]
"""


def task_8(values: List[int]):
        new_values = []
        for i in values:
            new = 1
            for j in values:
                if i != j:
                    new *= j
            new_values.append(new)
        print(new_values)
        return new_values

task_8([1, 2, 3, 4, 5])
task_8([3, 2, 1])
