part of game;


class Action {

  String execute(Player player,
                 List<String> words) {
    // pass
  }
}

class Attack extends Action {

  String execute(Player player,
                 List<String> words) {
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

    if (words.length > 2) {
      if (thirdWord != 'with') {
        return 'What do you want to $firstWord with?';
      } else if (thirdWord == 'with' && words.length > 3 &&
          player.inventory.containsKey(fourthWord)) {
        // if (currentLocation.isAnimate(fourthWord)) {do attack}
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
    var location;
    var directions;

    firstWord = words[0];

    if (words.length > 1) {
      secondWord = words[1];
    } else {
      secondWord = '';
    }

    location = player.location;


    directions = ['down', 'e', 'east', 'n', 'ne', 'north', 'northeast',
                  'northwest', 'nw', 's', 'se', 'sw', 'south', 'southeast',
                  'southwest', 'up', 'w', 'west'];

    if (secondWord != '') {
      if (location.exits.containsKey(secondWord) && firstWord != 'climb') {
        player.location = location.exits[secondWord].location;
        return location.text();
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
    } else if (location.exits.containsKey(firstWord)) {
      location = location.exits[firstWord].location;
      return location.text();
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
        var obj = inanimates.remove(secondWord);
        obj.taken = true;
        player.inventory.putIfAbsent(secondWord, () => obj);
        return 'You $firstWord the $secondWord.';
      } else {
        return 'You are unable to $firstWord the $secondWord.';
      }
    } else {
      return 'There is no $secondWord to $firstWord.';
    }
  }

}