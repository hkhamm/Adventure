library game;

import 'dart:html';
import 'dart:collection' show SplayTreeMap;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'package:observe/observe.dart';

part 'actions.dart';
part 'animates.dart';
part 'exits.dart';
part 'inanimates.dart';
part 'locations.dart';
part 'view.dart';

// TODO save/load to/from a json file, save/load player and locations
// TODO multi-word location objects, allow adjectives
// example: 'sharp rock' instead of just 'rock'

class Game {

  /**
   * To add a location: create new class, add text/title to descriptions.json,
   * then declare and initialize in Game.
   */

  View view;
  Player player;

  Location currentLocation;
  Location location0;
  Location location1;
  Location location2;
  Location location3;
  Location location4;

  List<Location> locations;

  List<String> commands;

  Game() {
    view = new View();

    location0 = new Location0(this);
    location1 = new Location1(this);
    location2 = new Location2(this);
    location3 = new Location3(this);
    location4 = new Location4(this);

    locations = [location0, location1, location2, location3, location4];
    for (var location in locations) {
      location.setupExits();
    }

    commands = [];

//    readyText()
//      .then((_) {
//        // on success
//        view.inputField.disabled = false; // enable
//        view.enterButton.disabled = false;  // enable
//        location = location0;
//      })
//      .catchError((error) {
//        print('Error initializing location text: $error');
//        view.title = 'Error';
//        view.text = 'Sorry, but for some reason the text didn\'t load.';
//      });

    player = new Player(location0);

    view.text = player.location.text();
    view.title = player.location.title;

    readyCommands();

    // Observe the view
    view.changes.listen((records) {
      handleInput(view.currentInput);
    });
  }

  void handleInput(String input) {
    var words;
    var firstWord;
    var secondWord;

    input = input.replaceAll(' a ', ' ')
                 .replaceAll(' an ', ' ')
                 .replaceAll(' to ', ' ')
                 .replaceAll(' the ', ' ');

    words = input.split(' ');

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

  bool isCommand(String command) {
    return commands.contains(command);
  }

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
      } else if (firstWord == 'hit' ||
          firstWord == 'attack') {
        player.currentAction = player.attack;
        return player.act(words);
      } else if (firstWord == 'enter' ||
                 firstWord == 'exit' ||
                 firstWord == 'go' ||
                 firstWord == 'walk' ||
                 firstWord == 'run' ||
                 firstWord == 'climb') {
        player.currentAction = player.move;
        return player.act(words);
      }
//        if (currentLocation.exits.containsKey(secondWord)) {
//          currentLocation = currentLocation.exits[secondWord].location;
//          return currentLocation.text();
//        } else {
//          if (firstWord == 'enter' ||
//              firstWord == 'exit') {
//            return 'You can\'t $firstWord $secondWord here.';
//          } else {
//            return 'You can\'t $firstWord to $secondWord here.';
//          }
//        }
//      } else if (currentLocation.exits.containsKey(firstWord)) {
//        currentLocation = currentLocation.exits[firstWord].location;
//        return currentLocation.text();
//      } else if (isDirection(firstWord)) {
//        // If it is a direction, but not at that location.
//        return 'You can\'t go that way here.';
//      }
    } else {
      if (directions.contains(firstWord)) {
        player.currentAction = player.move;
        return player.act(words);
      }
      if (firstWord == 'i' ||
          firstWord == 'inventory') {
        var inv = player.inv;
        return'$inv';
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
                 firstWord == 'attack' ||
                 firstWord == 'hit') {
        return 'What do you want to $firstWord?';
      } else {
        return 'I don\'t understand \"$firstWord\" in that context.';
      }
    }
  }

  Future readyCommands() {
    return HttpRequest.getString('json/commands.json')
        .then((String jsonString) {
          var commandMap = JSON.decode(jsonString);
          commands = commandMap['commands'];
    });
  }
}