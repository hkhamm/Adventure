part of game;


class Inanimate {

  String examineText;
  String locationText;
  List<String> titles;

  Inanimate(this.examineText, [this.locationText]);
}


class Takeable extends Inanimate {
  
  Takeable(String examineText, [String locationDescription]) : 
    super(examineText, locationDescription); 
}