library game;

import 'dart:html';
import 'dart:collection' show SplayTreeMap;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'package:collection/algorithms.dart';

part 'actions.dart';
part 'animates.dart';
part 'exits.dart';
part 'inanimates.dart';
part 'locations.dart';
part 'view.dart';

// TODO save/load to/from a json file
// TODO multi-word inanimates: add entries to each inanimate/exit map that point
// to the same inanimate/exit
// TODO modify descriptions, possibly using stringbuilder to create them 
// from substrings located in the inanimates OR provide complete alternate
// descriptions that are selected when certain actions occur
// TODO add descriptions of inanimates to inanimates
// TODO create complete location description by combining the base location
// description with the 'current' description for each inanimate

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
  List<String> descriptions;
  List<String> titles;
  List<String> commands;

  Game() {
    view = new View(this);
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
    currentLocation = location0; // TODO get starting location from json save file.
    view.text = currentLocation.text;
    view.title = currentLocation.title;
    readyCommands();
    // commands.sort();
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
    var combo;
    
    input = input.replaceAll(' a ', ' ');
    input = input.replaceAll(' an ', ' ');
    input = input.replaceAll(' the ', ' ');
    
    words = input.split(' ');
    firstWord = words[0];

    if (words.length > 1) {
      secondWord = words[1];
    } else {
      secondWord = '';
    }

//    combo = firstWord + ' ' + secondWord;

//    if (isCommand(combo)) {
//      evaluateCommand(combo);
//    } else 
    if (isCommand(firstWord)) {
      if (currentLocation.isInanimate(secondWord) || 
          currentLocation.isExit(secondWord) ||
          currentLocation.isExit(firstWord)) {
        view.text = currentLocation.evaluateCommand(player, words);
        view.title = currentLocation.title;
      } else if (secondWord != '') {
        view.text = 'I don\'t understand \"$firstWord\" in that context.';
      } else {
        evaluateCommand(firstWord);
      }
    } else {
      view.text = 'I don\'t understand \"$firstWord\".';
    }
  }

  bool isCommand(String command) {
    if (binarySearch(commands, command) != -1) {
      return true;
    } else {
      return false;
    }
  }

  void evaluateCommand(String command) {
//    if (command == 'n' ||
//        command == 'north' ||
//        command == 'go north' ||
//        command == 'walk north' ||
//        command == 'run north' ||
//        command == 'exit north' ||
//        command == 'enter north') {
//      location = currentLocation.north;
//    } else if (command == 's' ||
//               command == 'south' ||
//               command == 'go south' ||
//               command == 'walk south' ||
//               command == 'run south' ||
//               command == 'exit south' ||
//               command == 'enter south') {
//      location = currentLocation.south;
//    } else if (command == 'e' ||
//               command == 'east' ||
//               command == 'go east' ||
//               command == 'walk east' ||
//               command == 'run east' ||
//               command == 'exit east' ||
//               command == 'enter east') {
//      location = currentLocation.east;
//    } else if (command == 'w' ||
//               command == 'west' ||
//               command == 'go west' ||
//               command == 'walk west' ||
//               command == 'run west' ||
//               command == 'exit west' ||
//               command == 'enter west') {
//      location = currentLocation.west;
//    } else 
      if (command == 'i' ||
               command == 'inventory') {
      var inv = player.inv;
      view.text = '$inv';
    } else if (command == 'hp' ||
               command == 'health') {
      var hp = player.hp;
      view.text = 'Health: $hp';
    } else if (command == 'l' ||
               command == 'look' ||
               command == 'location' ||
               command == 'look around' ||
               command == 'where' ||
               command == 'where am') {
      view.text = currentLocation.text;
    } else if (command == 'go' ||
               command == 'walk' ||
               command == 'run' ||
               command == 'exit' ||
               command == 'enter') {
      view.text = 'Where do you want to $command?';
    } else if (command == 'examine' ||
               command == 'take' ||
               command == 'get' ||
               command == 'read' ||
               command == 'attack' ||
               command == 'hit') {
      view.text = 'What do you want to $command?';
    }
  }

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