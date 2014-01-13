part of game;


class Location {

  Game game;
  SplayTreeMap<String, Inanimate> inanimates;
  SplayTreeMap<String, Exit> exits;
  String _description;
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

  String text() {
    var temp = _description;
    var list = [];
    for (var obj in inanimates.values) {
      if (!list.contains(obj)) {
        list.add(obj);
        if (obj is !Takeable) {
          temp += obj.locationText;
        } else if (obj is Takeable && !obj.taken) {
          temp += obj.locationText;
        }
      }
    }
    return temp;
  }
}


class Location0 extends Location {

  Inanimate sign;
  Inanimate cave;
  Exit west;
  Takeable rock;
  Inanimate _currentInanimate;

  Location0(Game game) : super(game) {
    title = 'The entrance';
    _description =
        '''You are standing at the base of a steep rocky slope. ''';

    // inanimates
    sign = new Inanimate(
        'WARNING! This is a dangeous cave. Enter at your own risk!',
        'There is a small sign embedded near the cave. ');
    inanimates.putIfAbsent('sign', () => sign);

    cave = new Inanimate('A dark, mysterious cave entrance.',
                         'To the west is the entrance to a cave. ');
    inanimates.putIfAbsent('cave', () => cave);

    rock = new Takeable('A sharp rock.',
                        'A particularly sharp rock lies on the ground. ');
    inanimates.putIfAbsent('rock', () => rock);
    //inanimates.putIfAbsent('sharp rock', () => rock);
  }

//  void currentInanimate(String inanimate) {
//    switch (inanimate) {
//      case 'sign':
//        _currentInanimate = sign;
//        break;
//      case 'cave':
//        _currentInanimate = cave;
//        break;
//      case 'rock':
//        _currentInanimate = rock;
//        break;
//    }
//  }

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
    _description = '''You are looking down a long dark tunnel. 
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