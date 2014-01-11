part of game;


class Location {

  Game game;
  SplayTreeMap<String, Inanimate> inanimates;
  SplayTreeMap<String, Exit> exits;
  String text;
  String title;

  Location(this.game) {
    inanimates = new SplayTreeMap<String, Inanimate>();
    exits = new SplayTreeMap<String, Exit>();
  }

  bool isInanimate(String inanimate) {
    return inanimates.containsKey(inanimate);
  }
  
  bool isExit(String exit) {
    return exits.containsKey(exit);
  }

  void setupExits() {
    // pass
  }
  
  String evaluateCommand(Player player, List<String> words) {
    var firstWord = words[0];
    var secondWord;
    if (words.length > 1) {
      secondWord = words[1];  
    }
    

    if (firstWord == 'examine' ||
        firstWord == 'read') {
      player.currentAction = player.examine;
      return player.act(this, words);
//      if (secondWord == 'sign' ||
//          secondWord == 'small') {
//        return sign.text;
//      } else {
//        return 'There is no $secondWord to $firstWord.';
//      }
    } else if (firstWord == 'take' ||
               firstWord == 'get') {
      player.currentAction = player.take;
      return player.act(this, words);
//      if (secondWord == 'sign') {
//        return 'The sign is too well secured to the stone to take.';
//      } else {
//        return 'There is no $secondWord to $firstWord.';
//      }
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
      if (exits.containsKey(secondWord)) {
        game.currentLocation = exits[secondWord].location;
        return exits[secondWord].location.text;
      }
//      if (secondWord == 'cave' ||
//          secondWord == 'dungeon') {
//        game.location = game.location1;
//      }
    } else if (exits.containsKey(firstWord)) { 
      game.currentLocation = exits[firstWord].location;
      return exits[firstWord].location.text;
    } else {
      return 'I don\'t understand "$firstWord" in that context.';
    }
  }
}


class Location0 extends Location {

  Inanimate sign;
  Inanimate cave;
  Exit west;
  Takeable rock;

  Location0(Game game) : super(game) {
    title = 'The entrance';
    text = '''You are standing at the base of a large hill. 
           To the west is the entrance to a cave. 
           Several sharp rocks litter the ground around the entrance. 
           There is a small sign imbedded in the rock.''';

    // inanimates
    sign = new Inanimate(
        'WARNING! This is a dangeous cave. Enter at your own risk!');
    inanimates.putIfAbsent('sign', () => sign);

    cave = new Inanimate('A dark, mysterious cave entrance.');
    inanimates.putIfAbsent('cave', () => cave);
    
    rock = new Takeable('A sharp rock.');
    inanimates.putIfAbsent('rock', () => rock);
    inanimates.putIfAbsent('sharp rock', () => rock);
  }

  void setupExits() {
    west = new Exit(game.location1);
    exits.putIfAbsent('cave', () => west);
    exits.putIfAbsent('dungeon', () => west);
    exits.putIfAbsent('west', () => west);
    exits.putIfAbsent('w', () => west);
  }
}


class Location1 extends Location {
  
  Exit east;

  Location1(Game game) : super(game) {
    title = 'A long dark tunnel';
    text = '''You are looking down a long dark tunnel. 
           Behind you, light streams in from the entrance to the cave.''';
  }

  void setupExits() {
    east = new Exit(game.location0);
    exits.putIfAbsent('cave', () => east);
    exits.putIfAbsent('entrance', () => east);
    exits.putIfAbsent('east', () => east);
    exits.putIfAbsent('e', () => east);
  }
}


class Location2 extends Location {

  Location2(Game game) : super(game) {
  }
}


class Location3 extends Location {

  Location3(Game game) : super(game) {
  }
}


class Location4 extends Location {

  Location4(Game game) : super(game) {
  }
}