PASSING_GRADE = 10
Passing_mark = 8


"""
Task 1
Create class `Trainee`, whose constructor receives Trainees' name and surname.
Task 2
Create method `visit_lecture`. This method has to be able to add 1 point to `visited_lectures` attribute.
Task 3
Create method `do_homework`. This method has to be able to add 2 points to `done_home_tasks` attribute.
Task 4
Create method `miss_lecture`. This method has to be able to subtract 1 point from the `missed_lectures` attribute.
Task 5
Create method `miss_homework`. This method has to be able to subtract 2 point from the `missed_home_tasks` attribute.
Task 6
Create method `_add_points`.  
This method has to be able to add a certain number of pointsto the `mark` attribute depending upon 
where it is used either in `visit_lecture` or in `do_homework`.  
Note: The mark can't be more than 10 points. Keep in mind.
Task 7
Create method `_subtract_points`. This method has to be able to subtract a certain number of points to the `mark` attribute depending upon where it is used either in `miss_lecture` or in `miss_homework`.  
Note: The mark can't be less than 0 points. Think about it.
Task 8
Create method `is_passed`.  
If `mark` attribute is equal or more than 8 points, you need to print this phrase: "Good job!".  
Otherwise, print "You need to {here is missing points} points. Try to do your best!". 
"""


class Trainee:
    def __init__(self, name, surname):
        self.name = name
        self.surname = surname
        self.visited_lectures = 0
        self.done_home_tasks = 0
        self.missed_lectures = 0
        self.missed_home_tasks = 0
        self.mark = 0

    def visit_lecture(self):
        self.visited_lectures += 1
        self._add_points(1)
        return self.visited_lectures

    def do_homework(self):
        self.done_home_tasks += 2
        self._add_points(2)
        return self.done_home_tasks

    def miss_lecture(self):
        self.missed_lectures -= 1
        self._subtract_points(1)
        return self.missed_lectures

    def miss_homework(self):
        self.missed_home_tasks -= 2
        self._subtract_points(2)
        return self.missed_home_tasks

    def _add_points(self, points: int):
        if self.mark == PASSING_GRADE:
            return self.mark
        elif self.mark == PASSING_GRADE - 1:
            self.mark = PASSING_GRADE
        else:
            self.mark += points
        return self.mark

    def _subtract_points(self, points):
        if self.mark == 0:
            return self.mark
        elif self.mark == 1:
            self.mark = 0
        else:
            self.mark -= points
        return self.mark

    def is_passed(self):
        if self.mark >= Passing_mark:
            print("Good job!")
        else:
            print(f"You need to {Passing_mark - self.mark} points. Try to do your best!")

    def __str__(self):
        status = f"Trainee {self.name.title()} {self.surname.title()}:\n" \
                 f"done homework {self.done_home_tasks} points;\n" \
                 f"missed homework {self.missed_home_tasks} points;\n" \
                 f"visited lectures {self.visited_lectures} points;\n" \
                 f"missed lectures {self.missed_lectures} points;\n" \
                 f"current mark {self.mark};\n" \

        return status
