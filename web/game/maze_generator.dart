part of game;

/**
 * Generates a maze of locations with a provided width and height. Uses Prim's
 * algorithm.
 */
class MazeGenerator {
  
  Game game;
  int width;
  int height;
  List<List<Location>> maze;
  List<List> wallList;
  List<int> start;
  
  /**
   * Constructor. Game is the game. width and height are the maze dimensions.
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
        location._description = 'Location ($i, $j)';
        col.add(location);
      }
      maze.add(col);
    }
  }
  
  /**
   * Creates the maze from a grid of unconnected locations.
   */
  void createMaze() {
    var random = new Random();
    
    addToWallList(start[0], start[1]);

    // Modified Prim's
    while (wallList.length > 0) {
      var index = random.nextInt(wallList.length);
      var wall = wallList[index]; // Random wall
      var current = maze[wall[0][0]][wall[0][1]];
      var adjacent = maze[wall[1][0]][wall[1][1]];
      
      if (!adjacent.inMaze) {
        current.exits.putIfAbsent(wall[2], () => adjacent); // by word
        current.exits.putIfAbsent(wall[2][0], () => adjacent); // by letter
        adjacent.exits.putIfAbsent(wall[3], () => current);  // by word
        adjacent.exits.putIfAbsent(wall[3][0], () => current); // by letter
        addToWallList(adjacent.row, adjacent.col);        
      } else {
        wallList.remove(wallList.elementAt(index));
      }
    }
  }
  
  /**
   * Adds all walls for the current location to wallList. row and col are the
   * coordinates of the current location.
   */
  void addToWallList(int row, int col) {   
    maze[row][col].inMaze = true;
    
    wallList.add([[row, col], [row, col - 1], 'north', 'south']);
    wallList.add([[row, col], [row, col + 1], 'south', 'north']);
    wallList.add([[row, col], [row - 1, col], 'west', 'east']);
    wallList.add([[row, col], [row + 1, col], 'east', 'west']);
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