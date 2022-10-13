from collections import defaultdict as dd
from itertools import product
from typing import Dict, Any, Tuple, List

"""
Task 1
Write a Python function to combine two dictionary adding values for common keys. Return updated dict.
```python
>>> task_1({'a': 123, 'b': 23, 'c': 0}, {'a': 1, 'b': 11, 'd': 99})
{'a': 124, 'b': 34, 'c': 0, 'd': 99}
"""


def task_1(data_1: Dict[str, int], data_2: Dict[str, int]):
    summary = {}
    for key in data_1.keys():
        if key in data_2.keys():
            summary[key] = data_1[key] + data_2[key]
        elif key not in data_2.keys():
            summary[key] = data_1[key]
    for key in data_2.keys():
        if key not in data_1.keys():
            summary[key] = data_2[key]
#    print(summary)
    return summary


task_1({'a': 123, 'b': 23, 'c': 0}, {'a': 1, 'b': 11, 'd': 99})


"""
Task 2
Write a Python function to return a dictionary where the keys are numbers between 1 and 15 (both included) 
and the values are square of keys.
"""


def task_2():
    dictionary = {}
    for i in range(1, 16):
        dictionary[i] = i**2
#    print(dictionary)
    return dictionary


task_2()


"""
Task 3
Write a Python function to create and display all combinations of letters, selecting each letter 
from a different key in a dictionary. Return list of combinations.
```python
>>> task_3({'1': ['a', 'b'], '2': ['c', 'd']})
["ac", "ad", "bc", "bd"]
>>> task_3({'1': ['a', 'b'], '2': ['c', 'd'], '3': ['d', 'e']})
["acd", "ace", "add", "ade", "bcd", "bce", "bdd", "bde"]
"""


import itertools


def task_3(data: Dict[Any, List[str]]):
    for items in itertools.product(*[data[key] for key in sorted(data.keys())]):
        result = (''.join(items))
#        print(result)
        return result


task_3({'1': ['a', 'b'], '2': ['c', 'd']})
task_3({'1': ['a', 'b'], '2': ['c', 'd'], '3': ['d', 'e']})


"""
Task 4
Write a Python function to find the highest 3 values of corresponding keys in a dictionary.  
If dictionary contains less then 3 values, you need to return the remaining.  
Return List[aim elements].
```python
>>> task_4({'a': 500, 'b': 5874, 'c': 560,'d': 400, 'e': 5874, 'f': 20})
["b", "e", "c"]
>>> task_4({'a': -1})
['a']
>>> task_4({})
[]
"""


from heapq import largest


def task_4(data: Dict[str, int]):
    highest_values = nlargest(3, data, key = data.get)
#    print(highest_values)
    return highest_values


task_4({'a': 500, 'b': 5874, 'c': 560, 'd': 400, 'e': 5874, 'f': 20})
task_4({'a': - 1})
task_4({})


"""
Task 5
Write a Python function to create a dictionary grouping a sequence of key-value pairs into a dictionary of lists.  
Original list:  
[('yellow', 1), ('blue', 2), ('yellow', 3), ('blue', 4), ('red', 1)]  
Grouping a sequence of key-value pairs into a dictionary of lists:  
{'yellow': [1, 3], 'blue': [2, 4], 'red': [1]}
"""


def task_5(data: List[Tuple[Any, Any]]) -> Dict[str, List[int]]:
    dictionary_of_lists = {}
    for key, value in data:
        dictionary_of_lists.setdefault(key, []).append(value)
#    print(dictionary_of_lists)
    return dictionary_of_lists


task_5([('yellow', 1), ('blue', 2), ('yellow', 3), ('blue', 4), ('red', 1)])


"""
Task 6
Write a Python function to delete repeated elements from list.
```python
>>> task_6([1, 1, 3, "3"]
[1, 3, "3"]
"""


def task_6(data: List[Any]):
    new_data = []
    for i in data:
        if i not in new_data:
            new_data.append(i)
#    print(new_data)
    return new_data


task_6([1, 1, 3, "3"])


"""
Task 7
Write a Python function to find the longest common prefix string amongst an array of strings.  
If there is no common prefix, return an empty string "".  
```python
>>> task_7(["flower", "flows"])
flow
>>> task_7(["sun", "recap"])
""
"""


def task_7(words: [List[str]]) -> str:
    prefix = ''
    for group in zip(*words):
        if not all(char == group[0] for char in group):
            break
        prefix += group[0]
#    print(prefix)
    return prefix


task_7(["sun", "recap"])
task_7(["flower", "flows"])


"""
Task 8
Write a Python functionto return the index of the first occurrence of needle in haystack, 
or -1 if needle is not part of haystack. What should we return when needle is an empty string?  
For the purpose of this problem, we will return 0 when needle is an empty string.
```python
>>> task_8("Star Killer", "Killer")
5
>>> task_8("Star Killer", "Miller")
-1
>>> task_8("Star Killer", "")
0
"""


def task_8(haystack: str, needle: str) -> int:
    pass
