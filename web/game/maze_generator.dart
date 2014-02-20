/**
 * Adventure. A text-based adventure game for the web.
 *  Copyright (C) 2014  H. Keith Hamm
 *  
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *  
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *  
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

part of game;

/**
 * Generates a maze of locations with a provided [width] and [height]. 
 * Uses a random version of Prim's algorithm.
 */
class MazeGenerator {
  
  Game game;
  int width;
  int height;
  List<List<Location>> maze;
  List<List> wallList;
  List<int> start;
  
  /**
   * Constructor. [game] is the game. [width] and [height] are the 
   * maze dimensions.
   */
  MazeGenerator(Game game, int width, int height) {
    this.game = game;
    this.width = width;
    this.height = height;
    maze = [];
    wallList = [];
    start = [];
    
    setStart();    
    createGrid();
    createMaze();
  }
  
  /**
   * Creates a grid of unconnected locations that will become a maze.
   */
  void createGrid() {
    for (int i = 0; i < width; i++) {
      var col = [];
      for (int j = 0; j < height; j++) {
        var location = new Location(game);
        location.row = i;
        location.col = j;
        location.title = 'Location ($i, $j)';
        location._description = 'Location ($i, $j). ';
        col.add(location);
      }
      maze.add(col);
    }
  }
  
  /**
   * Creates the maze from a grid of unconnected locations using a random
   * version of Prim's algorithm for finding a minimum spanning tree in a 
   * graph.
   */
  void createMaze() {
    var random = new Random();
    
    addToWallList(start[0], start[1]);

    // Modified Prim's
    while (wallList.isNotEmpty) {
      var index = random.nextInt(wallList.length);
      var wall = wallList[index]; // Random wall
      var current = maze[wall[0][0]][wall[0][1]];
      if (wall[1][0] >= 0 && wall[1][0] < width &&
          wall[1][1] >= 0 && wall[1][1] < height) {

        var adjacent = maze[wall[1][0]][wall[1][1]];
        
        if (!adjacent.inMaze) {
          var direction = wall[2];
          current.exits.putIfAbsent(direction, () => adjacent); // by word
          current._description += 'There is an exit leading $direction. ';
          current.exits.putIfAbsent(direction[0], () => adjacent); // by letter

          direction = wall[3];
          adjacent.exits.putIfAbsent(direction, () => current);
          adjacent._description += 'There is an exit leading $direction. ';
          adjacent.exits.putIfAbsent(direction[0], () => current);
          
          addToWallList(adjacent.row, adjacent.col);        
        } else {
          wallList.remove(wallList.elementAt(index));
        }
      } else {
        wallList.remove(wallList.elementAt(index));
      }
    }
  }
  
  /**
   * Adds all valid walls for the current location to wallList. 
   * [row] and [col] are the coordinates of the current location.
   */
  void addToWallList(int row, int col) {   
    maze[row][col].inMaze = true;
    
    if (col - 1 >= 0) {
      wallList.add([[row, col], [row, col - 1], 'north', 'south']);  
    }
    if (col + 1 < width) {

      wallList.add([[row, col], [row, col + 1], 'south', 'north']);  
    }
    if (row - 1 >= 0) {
      wallList.add([[row, col], [row - 1, col], 'west', 'east']);  
    }
    if (row + 1 < height) {
      wallList.add([[row, col], [row + 1, col], 'east', 'west']);      
    }
  }
  
  /**
   * Generates a random starting location for the maze within the bounds
   * provided by width and height.
   */
  void setStart() {
    var random = new Random();
    var row = random.nextInt(width);
    var col = random.nextInt(height);

    start = [row, col];
  }
}