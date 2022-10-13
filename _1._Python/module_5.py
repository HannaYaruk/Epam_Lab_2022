from collections import Counter
from typing import List, Union
from random import seed, choice
from requests.exceptions import ConnectionError
import requests

from gensim.utils import simple_preprocess


PATH_TO_NAMES = "names.txt"
PATH_TO_SURNAMES = "last_names.txt"
PATH_TO_OUTPUT = "sorted_names_and_surnames.txt"
PATH_TO_TEXT = "random_text.txt"
PATH_TO_STOP_WORDS = "stop_words.txt"


"""
Task 1
Write a Python function `task_1` to open files __'names.txt'__ and __'last_names.txt'__. 
There are ~18000 names and approximately 98000 surnames.  
Sort the names and make lowercase. You need to assign random surname to each name by using `choice` function 
from `random` lib and join them by __space__.  
Whereupon, you have to write them to a new file called __'sorted_names_and_surnames.txt'__.  
Each name and surname should start with a new line as in the following example:  
```python
aadil contini
aaisha rion
aakash bitonti
aaliyah goettl
aamanda chartraw
...
zuleyka gruca
zully gracely
zulma porcaro
zvi brazzell
```
__USE THE DEFAULT PATHS FROM *.PY MODULE, PLEASE!__
"""


import random


def task_1():
    # from www.py. Tests about this task has been successfully passed.
    with open(PATH_TO_NAMES, encoding = 'utf-8') as names, \
            open(PATH_TO_SURNAMES, encoding='utf-8') as surnames, \
            open(PATH_TO_OUTPUT, 'w', encoding = 'utf-8') as output:
        seed(1)
        sorted_names = sorted([item.strip().lower() for item in names.readlines()])
        # adding some rows to last_names.txt. Prevously file was empty ==> IndexError: list index out of range
        last_names = [item.strip().lower() for item in surnames.readlines()]
        full_names_list = [*zip(sorted_names, [choice(last_names) for _ in range(len(sorted_names))])]
        for combination in full_names_list:
            # adding str ==> TypeError: write() argument must be str, not list
            output.write(str(' '.join(combination) + '\n'))


"""
Task 2
Write a Python function `task_2` with follow parameter:
* `top_k`.
Inside the function you need to open both `random_text.txt` and `stop_words.txt` files.   
Read the text from `random_text.txt`, whereupon you need to delete stop words in the text.  
Finally, you have to return list of tuples of the top words and frequency as well. 
The number of needed top words is the parameter of function.  
Note: words should only consist of alphabet tokens and be in lowercase.
```python
>>> task_2(5)
[('blind', 101), ('far', 68), ('text', 67), ('copy', 66), ('way', 51)]
```
__USE THE DEFAULT PATHS FROM *.PY MODULE, PLEASE!__
"""


def task_2(top_k: int):
    pass


"""
Task 3
Write Python function `task3` to get request by using given url. You need to raise an exception `RequestException` 
from `requests.exceptions`.  
Just info: It's a parent exception for `HTTPError`, `ConnectionError` and etc.  
Use the `response.raise_for_status()` to raise an exception.  
If your response has 200 status then just return `requests.get(url)` response.
"""


def task_3(url: str):
    pass


"""
Task 4
Write a Python function `task_4` with parameter `data`. The data can contain such types of elements like `str`, `float`,
`int`.  You need to sum up all elements of `data` if it's possible. Otherwise you need to process exception `TypeError`.  
This exception should be able to convert strings to float.  
The function has to return the sum of the values in the list.  
Example:
```python
>>> get_sum([1, 2, 3])
6
>>> get_sum([1, '2', '3.5'])
7.5
"""


def task_4(data: List[Union[int, str, float]]):
    # add function to return sum of items. Exception is for cases if we need to make item float type
    total = 0.0
    try:
        return sum(data)
    except TypeError:
        return sum([item for item in map(float, data)])


"""
Task 5
Write a Python function `task_5`. You need to declare two variables via `input()` in the body of the function.  
Try to divide first variable on second. If the second variable is zero you have to `print("Can't divide by zero")`.  
Another option is to `print("Entered value is wrong")`, if you get exception `ValueError`.  
Finally, if the result of division can be calculated without any exception then just print this result.
"""


def task_5():
    try:
        value1, value2 = map(float, input().split())
        #we should use this construction because in this case we can use
        #input just once
        result = float(value1)/float(value2)
        print(result)
    except ZeroDivisionError:
        print("Can't divide by zero")
    except ValueError:
        print("Entered value is wrong")

task_1()