part of game;


class Inanimate {

  String examineText;
  String locationText;
  List<String> titles;

  Inanimate(this.examineText, [this.locationText]);
}


class Takeable extends Inanimate {

  bool taken = false;

  Takeable(String examineText, [String locationText]) :
    super(examineText, locationText);
}