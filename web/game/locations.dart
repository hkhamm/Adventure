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


class Location {

  Game game;
  SplayTreeMap<String, Inanimate> inanimates;
  SplayTreeMap<String, Location> exits;
  String title;
  String _description;
  int row;
  int col;
  bool inMaze = false;

  Location(this.game) {
    inanimates = new SplayTreeMap<String, Inanimate>();
    exits = new SplayTreeMap<String, Location>();
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
    var text = _description;
    var list = [];
    
    // TODO reduce the complexity here. [taken] bool is no longer needed. 
    // Add all locationText from every inanimate.
    for (var inanimate in inanimates.values) {
      if (!list.contains(inanimate)) {
        list.add(inanimate);
        if (inanimate is !Takeable) {
          text += inanimate.locationText;
        } else if (inanimate is Takeable && !inanimate.taken) {
          text += inanimate.locationText;
        }
      }
    }
    
    return text;
  }
}


//class Location0 extends Location {
//
//  Inanimate sign;
//  Inanimate cave;
//  Exit west;
//  Takeable rock;
//
//  Location0(Game game) : super(game) {
//    title = 'The entrance';
//    _description =
//        '''You are standing at the base of a steep rocky slope. ''';
//
//    // inanimates
//    sign = new Inanimate(
//        'WARNING! This is a dangeous cave. Enter at your own risk!',
//        'There is a small sign embedded near the cave. ');
//    inanimates.putIfAbsent('sign', () => sign);
//
//    cave = new Inanimate('A dark, mysterious cave entrance.',
//                         'To the west is the entrance to a cave. ');
//    inanimates.putIfAbsent('cave', () => cave);
//
//    rock = new Takeable('A sharp rock.',
//                        'A particularly sharp rock lies on the ground. ');
//    inanimates.putIfAbsent('rock', () => rock);
//    //inanimates.putIfAbsent('sharp rock', () => rock);
//  }
//
//  Inanimate inanimate(String inanimate) {
//    switch (inanimate) {
//      case 'sign':
//        return sign;
//      case 'cave':
//        return cave;
//      case 'rock':
//        return rock;
//    }
//  }
//
//  void setupExits() {
//    west = new Exit(game.location1);
//    exits.putIfAbsent('cave', () => west);
//    exits.putIfAbsent('dungeon', () => west);
//    exits.putIfAbsent('west', () => west);
//    exits.putIfAbsent('w', () => west);
//  }
//}
//
//
//class Location1 extends Location {
//
//  Exit east;
//
//  Location1(Game game) : super(game) {
//    title = 'A long dark tunnel';
//    _description = '''You are looking down a long dark tunnel. 
//           Behind you, light streams in from the cave entrance to the east. ''';
//  }
//
//  void setupExits() {
//    east = new Exit(game.location0);
//    exits.putIfAbsent('cave', () => east);
//    exits.putIfAbsent('entrance', () => east);
//    exits.putIfAbsent('east', () => east);
//    exits.putIfAbsent('e', () => east);
//  }
//}
//
//
//class Location2 extends Location {
//
//  Location2(Game game) : super(game) {
//  }
//}
//
//
//class Location3 extends Location {
//
//  Location3(Game game) : super(game) {
//  }
//}
//
//
//class Location4 extends Location {
//
//  Location4(Game game) : super(game) {
//  }
//}