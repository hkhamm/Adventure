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


class Action {

  String execute(Player player, List<String> words) {
    // pass
  }
}

class Attack extends Action {

  String execute(Player player, List<String> words) {
    var firstWord;
    var secondWord;
    var thirdWord;
    var fourthWord;

    firstWord = words[0];
    secondWord = words[1];

    if (words.length > 2) {
      thirdWord = words[2];
    } else {
      thirdWord = '';
    }

    if (words.length > 3) {
      fourthWord = words[3];
    } else {
      fourthWord = '';
    }
    
    // Must have this form:
    // 'attack/hit [monster name] with [item name]'
    if (words.length > 2) {
      if (thirdWord != 'with') {
        return 'What do you want to $firstWord with?';
      } else if (thirdWord == 'with' && words.length > 3 &&
          player.inventory.containsKey(fourthWord)) {
        // TODO if (currentLocation.isAnimate(secondWord)) {do attack}
        return '''You $firstWord the $secondWord with the $fourthWord 
            without any noticeable effect.''';
      } else {
        return 'You need to $firstWord with an object in your inventory.';
      }
    } else {
      return '''You need to $firstWord an object with something 
          in your inventory.''';
    }
  }
}

class Move extends Action {

  String execute(Player player, List<String> words) {
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
      if (player.location.exits.containsKey(secondWord) && firstWord != 'climb') {
        player.location = player.location.exits[secondWord];
        return player.location.text();
      } else {
        if (firstWord == 'enter' ||
            firstWord == 'exit') {
          return 'You can\'t $firstWord $secondWord here.';
        } else if (firstWord == 'climb') {
          if (secondWord == 'up' || secondWord == "down") {
            return 'You can\'t $firstWord here.';
          } else if (directions.contains(secondWord)) {
            return 'You can\'t $firstWord to the $secondWord here.';
          } else {
            return 'You can\'t $firstWord the $secondWord here.';
          }
        } else {
          return 'You can\'t $firstWord $secondWord here.';
        }
      }
    } else if (player.location.exits.containsKey(firstWord)) {
      player.location = player.location.exits[firstWord];
      return player.location.text();
    } else if (directions.contains(firstWord)) {
      // If it is a direction, but not at that location.
      return 'You can\'t go $firstWord here.';
    }
  }
}

class Examine extends Action {

  String execute(Player player, List<String> words) {
    var firstWord = words[0];
    var secondWord = words[1];
    var inanimates = player.location.inanimates;

    if (inanimates.containsKey(secondWord)) {
      return 'You $firstWord the $secondWord:<br />' +
             inanimates[secondWord].examineText;
    } else {
      return 'There is no $secondWord to $firstWord.';
    }
  }
}

class Take extends Action {

  String execute(Player player, List<String> words) {
    var firstWord = words[0];
    var secondWord = words[1];
    var inanimates = player.location.inanimates;

    if (inanimates.containsKey(secondWord)) {
      if (inanimates[secondWord] is Takeable) {
        var item = inanimates[secondWord];
        inanimates.remove(secondWord);
        player.inventory.putIfAbsent(secondWord, () => item);
        return 'You $firstWord the $secondWord.';
      } else {
        return 'You are unable to $firstWord the $secondWord.';
      }
    } else {
      return 'There is no $secondWord to $firstWord.';
    }
  }

}

class Drop extends Action {

  String execute(Player player, List<String> words) {
    var firstWord = words[0];
    var secondWord = words[1];
    var inanimates = player.location.inanimates;
    var inventory = player.inventory;

    if (inventory.containsKey(secondWord)) {
      var item = inventory[secondWord];
      inventory.remove(secondWord);
      inanimates.putIfAbsent(secondWord, () => item);
      return 'You $firstWord the $secondWord.';
    } else {
      return 'You don\'t have a $secondWord to $firstWord.';
    }
  }

}