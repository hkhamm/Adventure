part of game;


class Action {

  String execute(Player player,
                 SplayTreeMap<String, Inanimate> inanimates,
                 List<String> words) {
    // pass
  }
}

class Attack extends Action {

  String execute(Player player,
                 SplayTreeMap<String, Inanimate> inanimates,
                 List<String> words) {
    // pass
  }
}

class Move extends Action {

  String execute(Player player,
                 SplayTreeMap<String, Inanimate> inanimates,
                 List<String> words) {
    // pass
  }
}

class Examine extends Action {

  String execute(Player player,
                 SplayTreeMap<String, Inanimate> inanimates,
                 List<String> words) {
    var firstWord = words[0];
    var secondWord = words[1];

    if (inanimates.containsKey(secondWord)) {
      return 'You $firstWord the $secondWord:<br />' +
             inanimates[secondWord].examineText;
    } else {
      return 'There is no $secondWord to $firstWord.';
    }
  }
}

class Take extends Action {

  String execute(Player player,
                 SplayTreeMap<String, Inanimate> inanimates,
                 List<String> words) {
    var firstWord = words[0];
    var secondWord = words[1];

    if (inanimates.containsKey(secondWord)) {
      if (inanimates[secondWord] is Takeable) {
        var obj = inanimates.remove(secondWord);
        obj.taken = true;
        player.inventory.add(obj);
        return 'You $firstWord the $secondWord.';
      } else {
        return 'You are unable to $firstWord the $secondWord.';
      }
    } else {
      return 'There is no $secondWord to $firstWord.';
    }
  }

}