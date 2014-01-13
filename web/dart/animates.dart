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