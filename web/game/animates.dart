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


class Animate {

  int hp;
  int defense;
  SplayTreeMap<String, Inanimate> inventory;
  Action currentAction;
  Action examine;
  Action take;
  Action attack;
  Action move;
  Action drop;
  Location location;

  Animate(this.location);
}


class Player extends Animate {

  Player(Location location) : super(location) {
    hp = 10;
    defense = 10;
    inventory = new SplayTreeMap<String, Inanimate>();
    examine = new Examine();
    take = new Take();
    attack = new Attack();
    move = new Move();
    drop = new Drop();
  }

  String act(List<String> words) {
    return currentAction.execute(this, words);
  }

  String get inv {
    var sb = new StringBuffer();
    sb.write('Inventory:<br />');
    if (inventory.values.length > 0) {
      for (var item in inventory.values) {
        sb.write('&nbsp;&nbsp;' + item.examineText + '<br />');
      }
    } else {
      sb.write('&nbsp; Empty');
    }
    return sb.toString();
  }

}

class Monster extends Animate {

  Monster(Location location) : super(location)  {
    hp = 10;
    defense = 10;
    inventory = new SplayTreeMap<String, Inanimate>();
  }

  String act() {
    return 'Monster attacks!';
  }

  String get inv {
    var sb = new StringBuffer();
    sb.write('Inventory:<br />');
    if (inventory.values.length > 0) {
      for (var item in inventory.values) {
        sb.write('&nbsp;&nbsp;' + item.examineText + '<br />');
      }
    } else {
      sb.write('&nbsp; Empty');
    }
    return sb.toString();
  }
}