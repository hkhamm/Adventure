library game;

import 'dart:html';
import 'dart:collection' show SplayTreeMap;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'dart:indexed_db';
import 'dart:math' show Random;
import 'package:observe/observe.dart';

part 'actions.dart';
part 'animates.dart';
part 'exits.dart';
part 'indexeddb_storage.dart';
part 'inanimates.dart';
part 'locations.dart';
part 'maze_generator.dart';
part 'view.dart';

// TODO handle combat and object damage; monsters drop stuff when they die
// TODO multi-word location objects, allow adjectives
// example: 'sharp rock' instead of just 'rock'

class Game {

  /**
   * To add a location: create new class,
   * then declare and initialize in Game.
   */
  
  View view;
  Player player;

  IndexedDBStorage store;

//  Location location0;
//  Location location1;
//  Location location2;
//  Location location3;
//  Location location4;
  Map<String, Location> locations;
  List<List<Location>> maze;

  List<String> commands;

  Game() {
    view = new View();

    store = new IndexedDBStorage();
    store.open();

//    location0 = new Location0(this);
//    location1 = new Location1(this);
//    location2 = new Location2(this);
//    location3 = new Location3(this);
//    location4 = new Location4(this);
//
//    locations = {location0.title: location0,
//                 location1.title: location1,
//                 location2.title: location2,
//                 location3.title: location3,
//                 location4.title: location4};
//    for (var location in locations.values) {
//      location.setupExits();
//    }
    
    var mazeGenerator = new MazeGenerator(this, 20, 30);
    maze = mazeGenerator.maze;
    var start = mazeGenerator.start;
    
    // Create map of locations in the maze.
    locations = {};
    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[0].length; j++) {
        locations.putIfAbsent(maze[i][j].title, () => maze[i][j]);
      }
    }

    player = new Player(maze[start[0]][start[1]]);

    updateView();

    commands = [];
    readyCommands();

    // Observe the view.
    view.changes.listen((records) {
      handleInput(view.currentInput);
    });
  }

  void handleInput(List<String> words) {

    var firstWord;
    var secondWord;

    firstWord = words[0];

    if (words.length > 1) {
      secondWord = words[1];
    } else {
      secondWord = '';
    }

    if (isCommand(firstWord)) {
      view.text = evaluateCommand(words);
      if (view.title != player.location.title) {
        view.title = player.location.title;
      }
    } else {
      view.text = 'I don\'t understand \"$firstWord\".';
    }
  }

  void updateView() {
    view.text = player.location.text();
    view.title = player.location.title;
  }

  bool isCommand(String command) {
    return commands.contains(command);
  }

  /**
   * To add a new command: 
   * - add command to commands.json
   * - process command below
   * - if it is a new action, create action and add to player
   */
  String evaluateCommand(List<String> words) {   
    var firstWord;
    var secondWord;
    var directions;

    firstWord = words[0];

    if (words.length > 1) {
      secondWord = words[1];
    } else {
      secondWord = '';
    }

    directions = ['down', 'e', 'east', 'n', 'ne', 'north', 'northeast',
                  'northwest', 'nw', 's', 'se', 'sw', 'south', 'southeast',
                  'southwest', 'up', 'w', 'west'];

    if (secondWord != '') {
      if (firstWord == 'examine' ||
          firstWord == 'read') {
        player.currentAction = player.examine;
        return player.act(words);
      } else if (firstWord == 'take' ||
          firstWord == 'get') {
        player.currentAction = player.take;
        return player.act(words);
      } else if (firstWord == 'drop') {
        player.currentAction = player.drop;
        return player.act(words);
      } else if (firstWord == 'hit' ||
          firstWord == 'attack') {
        player.currentAction = player.attack;
        return player.act(words);
      } else if (firstWord == 'enter' ||
                 firstWord == 'exit' ||
                 firstWord == 'go' ||
                 firstWord == 'walk' ||
                 firstWord == 'run' ||
                 firstWord == 'climb' ||
                 firstWord == 'leave') {
        player.currentAction = player.move;
        return player.act(words);
      }
    } else {
      if (directions.contains(firstWord)) {
        player.currentAction = player.move;
        return player.act(words);
      } else if (firstWord == 'i' ||
                 firstWord == 'inventory') {
        var inv = player.inv;
        return '$inv';
      } else if (firstWord == 'hp' ||
                 firstWord == 'health') {
        var hp = player.hp;
        return 'Health: $hp';
      } else if (firstWord == 'l' ||
                 firstWord == 'look' ||
                 firstWord == 'location' ||
                 firstWord == 'where') {
        return player.location.text();
      } else if (firstWord == 'go' ||
                 firstWord == 'walk' ||
                 firstWord == 'run' ||
                 firstWord == 'exit' ||
                 firstWord == 'enter' ||
                 firstWord == 'climb') {
        return 'Where do you want to $firstWord?';
      } else if (firstWord == 'examine' ||
                 firstWord == 'take' ||
                 firstWord == 'get' ||
                 firstWord == 'read' ||
                 firstWord == 'drop' ||
                 firstWord == 'attack' ||
                 firstWord == 'hit') {
        return 'What do you want to $firstWord?';
      } else if (firstWord == 'save') {
        return save();
      } else if (firstWord == 'load') {
        return load();
      } else {
        return 'I don\'t understand \"$firstWord\" in that context.';
      }
    }
  }

  Future readyCommands() {
    return HttpRequest.getString('json/commands.json')
        .then((String jsonString) {
          var commandMap = JSON.decode(jsonString);
          commands = commandMap["commands"];
    });
  }

  // Load data from the IndexedDB.
  String load() {
    Map data = store.gameData['save'];

    // Set player inventory.
    player.inventory.clear();
    for (var item in data['inventory']) {
      player.inventory.putIfAbsent(
          item[0], () => new Inanimate(item[1], item[2]));
    }

    // Set player location.
    player.location = locations[data['currentLocation']];

    // Set inanimates at every location.
    for (var location in locations.keys) {
      locations[location].inanimates.clear();
    }
    for (var item in data['locations']) {
      if (item[4] == 'takeable') {
        locations[item[0]].inanimates.putIfAbsent(
            item[1], () => new Takeable(item[2], item[3]));        
      } else {
        locations[item[0]].inanimates.putIfAbsent(
            item[1], () => new Inanimate(item[2], item[3]));
      }
    }

    updateView();

    return 'Game loaded.';
  }

  // Save data to the IndexedDB.
  String save() {
    var data = new Map();

    // Save the player's inventory.
    data['inventory'] = new List();
    var inventory = player.inventory.keys;
    for (var item in inventory) {
      data['inventory'].add([item, player.inventory[item].examineText,
                                 player.inventory[item].locationText]);
    }

    // Save the players location.
    data['currentLocation'] = player.location.title;

    // Save inanimates from every location.
    data['locations'] = new List();
    for (var location in locations.keys) {
      for (var inanimate in locations[location].inanimates.keys) {
        if (locations[location].inanimates[inanimate] is Takeable) {
          data['locations'].add(
              [location, inanimate,
               locations[location].inanimates[inanimate].examineText,
               locations[location].inanimates[inanimate].locationText,
               'takeable']);
        } else {
          data['locations'].add(
              [location, inanimate,
               locations[location].inanimates[inanimate].examineText,
               locations[location].inanimates[inanimate].locationText,
               'inanimate']);
        }
      }
    }

    store.saveData(data);

    return 'Game saved.';
  }
}