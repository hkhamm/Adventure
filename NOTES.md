
1) Start with a grid full of walls.
2) Pick a cell, mark it as part of the maze. Add the walls of the cell to the wall list.
3)While there are walls in the list:
    1) Pick a random wall from the list. If the cell on the opposite side isn't in the maze yet:
        1) Make the wall a passage and mark the cell on the opposite side as part of the maze.
        2) Add the neighboring walls of the cell to the wall list.
    2) If the cell on the opposite side already was in the maze, remove the wall from the list.
    
n: i, j-1
s: i, j+1
w: i-1, j
e: i+1, j