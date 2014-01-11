part of game;


class Animate {

  int hp;
  int defense;
  List<Inanimate> inventory;
  Action currentAction;
  Action examine;
  Action take;
  Action attack;
}


class Player extends Animate {

  Player() {
    hp = 10;
    defense = 10;
    inventory = [];
    examine = new Examine();
    take = new Take();
    attack = new Attack();
  }

  String act(Location location, List<String> words) {
    return currentAction.execute(this, location.inanimates, words);
  }
  
  String get inv {
    var sb = new StringBuffer();
    sb.write('Inventory:<br />');
    for (var item in inventory) {
      sb.write('&nbsp;&nbsp;' + item.text + '<br />'); 
    }
    return sb.toString();
  }

}