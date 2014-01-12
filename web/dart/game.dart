library game;

import 'dart:html';
import 'dart:collection' show SplayTreeMap;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'package:collection/algorithms.dart';
import 'package:observe/observe.dart';

part 'actions.dart';
part 'animates.dart';
part 'exits.dart';
part 'inanimates.dart';
part 'locations.dart';
part 'view.dart';

// TODO handle using exists that don't exist
// TODO add all exits to all locations: 9 cardinal directions, up, down
// TODO save/load to/from a json file, save/load player and locations
// TODO multi-word inanimates: add entries to each inanimate/exit map that point
// to the same inanimate/exit, example: 'sharp rock' instead of just 'rock'

class Game extends Observable {

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
  List<String> descriptions;
  List<String> titles;
  List<String> commands;

  Game() {
    view = new View();
    player = new Player();

    location0 = new Location0(this);
    location1 = new Location1(this);
    location2 = new Location2(this);
    location3 = new Location3(this);
    location4 = new Location4(this);

    locations = [location0, location1, location2, location3, location4];
    for (var location in locations) {
      location.setupExits();
    }

    descriptions = [];
    titles = [];
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

    currentLocation = location0;
    view.text = currentLocation.text();
    view.title = currentLocation.title;
    readyCommands();
    // commands.sort();

    // Observe the view
    view.changes.listen((records) {
      // print('Changes to $view were: $records');
      handleInput(view.currentInput);
    });
  }

//  void set location(Location location) {
//    currentLocation = location;
//    updateView();
//  }
//
//  void updateView() {
//    // var index = currentLocation.index;
//    view.text = currentLocation.text; // descriptions[index];
//    view.title = currentLocation.title; // titles[index];
//  }

  void handleInput(String input) {
    var words;
    var firstWord;
    var secondWord;

    input = input.replaceAll(' a ', ' ')
                 .replaceAll(' an ', ' ')
                 .replaceAll(' the ', ' ');

    words = input.split(' ');
    firstWord = words[0];

    if (words.length > 1) {
      secondWord = words[1];
    } else {
      secondWord = '';
    }

//    if (isCommand(firstWord)) {
//      if (currentLocation.isInanimate(secondWord) ||
//          currentLocation.isExit(secondWord) ||
//          currentLocation.isExit(firstWord)) {
//        view.text = evaluateCommand(words);
//        view.title = currentLocation.title;
//      } else if (secondWord != '') {
//        view.text = 'I don\'t understand \"$firstWord\" in that context.';
//      } else {
//        evaluateCommand1(firstWord);
//      }
//    } else {
//      view.text = 'I don\'t understand \"$firstWord\".';
//    }

    if (isCommand(firstWord)) {
      view.text = evaluateCommand(words);
      view.title = currentLocation.title;
    } else if (secondWord != '') {
      view.text = 'I don\'t understand \"$firstWord\" in that context.';
    } else {
      view.text = 'I don\'t understand \"$firstWord\".';
    }
  }

  bool isCommand(String command) {
    return (binarySearch(commands, command) != -1);
  }

  String evaluateCommand(List<String> words) {
    var firstWord = words[0];
    var secondWord;

    if (words.length > 1) {
      secondWord = words[1];
    } else {
      secondWord = '';
    }

    if (firstWord == 'examine' ||
        firstWord == 'read') {
      player.currentAction = player.examine;
      return player.act(currentLocation, words);
    } else if (firstWord == 'take' ||
        firstWord == 'get') {
      player.currentAction = player.take;
      return player.act(currentLocation, words);
    } else if (firstWord == 'hit' ||
        firstWord == 'attack') {

      // TODO add combat:
      // "Attack/hit [animate/inanimate] with [item in player inventory]
      // capture the third and forth words
      // if attack/hit && secondWord is animate/inanimate && thirdWord is with
      // && fourth word is item in inventory

      return 'You $firstWord the $secondWord without any effect.';
    } else if (firstWord == 'enter' ||
        firstWord == 'exit' ||
        firstWord == 'go' ||
        firstWord == 'walk' ||
        firstWord == 'run') {
      if (currentLocation.exits.containsKey(secondWord)) {
        currentLocation = currentLocation.exits[secondWord].location;
        return currentLocation.text();
      } else {
        return 'You can\'t go $secondWord that way.';
      }
    } else if (currentLocation.exits.containsKey(firstWord)) {
      currentLocation = currentLocation.exits[firstWord].location;
      return currentLocation.text();
    } else if (firstWord == 'i' ||
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
               firstWord == 'look around' ||
               firstWord == 'where' ||
               firstWord == 'where am') {
      return currentLocation.text();
    } else if (firstWord == 'go' ||
               firstWord == 'walk' ||
               firstWord == 'run' ||
               firstWord == 'exit' ||
               firstWord == 'enter') {
      return 'Where do you want to $firstWord?';
    } else if (firstWord == 'examine' ||
               firstWord == 'take' ||
               firstWord == 'get' ||
               firstWord == 'read' ||
               firstWord == 'attack' ||
               firstWord == 'hit') {
      return 'What do you want to $firstWord?';
    }
  }

//  void evaluateCommand1(String command) {
//    if (command == 'i' ||
//               command == 'inventory') {
//        var inv = player.inv;
//        view.text = '$inv';
//    } else if (command == 'hp' ||
//               command == 'health') {
//        var hp = player.hp;
//        view.text = 'Health: $hp';
//    } else if (command == 'l' ||
//               command == 'look' ||
//               command == 'location' ||
//               command == 'look around' ||
//               command == 'where' ||
//               command == 'where am') {
//        view.text = currentLocation.text();
//    } else if (command == 'go' ||
//               command == 'walk' ||
//               command == 'run' ||
//               command == 'exit' ||
//               command == 'enter') {
//        view.text = 'Where do you want to $command?';
//    } else if (command == 'examine' ||
//               command == 'take' ||
//               command == 'get' ||
//               command == 'read' ||
//               command == 'attack' ||
//               command == 'hit') {
//        view.text = 'What do you want to $command?';
//    }
//  }

  Future readyText() {
    return HttpRequest.getString('json/descriptions.json')
        .then((String jsonString) {
          var textMap = JSON.decode(jsonString);
          descriptions = textMap['descriptions'];
          titles = textMap['titles'];
    });
  }

  Future readyCommands() {
    return HttpRequest.getString('json/commands.json')
        .then((String jsonString) {
          var commandMap = JSON.decode(jsonString);
          commands = commandMap['commands'];
    });
  }

//  Future readyDescriptions() {
//    var path = 'descriptions.json';
//    return HttpRequest.getString(path).then(_parseDescription);
//  }
//
//  void _parseDescription(String jsonString) {
//    Map descriptionMap = JSON.decode(jsonString);
//    descriptions = descriptionMap['descriptions'];
//  }
}