part of game;


class Inanimate {

  String examineText;
  String locationText;

  bool taken = false;

  Inanimate(this.examineText, [this.locationText]);
}


class Takeable extends Inanimate {

  Takeable(String examineText, [String locationText]) :
    super(examineText, locationText);
}