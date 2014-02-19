part of game;

class MazeGenerator {

  List<List> maze;

  MazeGenerator(Game game, int width, int height) {
    createGrid(game, width, height);
    createMaze(randomStart(width, height));
  }

  void createGrid(Game game, int width, int height) {
    maze = [];

    for (int i = 0; i < width; i++) {
      var col = [];
      for (int j = 0; j < height; j++) {
        var location = new Location(game);
        location.row = i;
        location.col = j;
        location.title = 'Room ($i, $j)';
        location._description = 'Room ($i, $j)';
        col.add(location);
      }
      maze.add(col);
    }
  }

  void createMaze(List start) {
    var wallList = [];
    var row = start[0];
    var col = start[1];
    var random = new Random();
    maze[row][col].inMaze = true;
    wallList.add([[row, col], [row, col - 1]]);
    wallList.add([[row, col], [row, col + 1]]);
    wallList.add([[row, col], [row - 1, col]]);
    wallList.add([[row, col], [row + 1, col]]);

    // continue
    while (wallList) {

    }
  }

  List<int> randomStart(int width, int height) {
    var random = new Random();
    var row = random.nextInt(width);
    var col = random.nextInt(height);

    return [row, col];
  }
}