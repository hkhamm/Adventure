part of game;


class Inanimate {

  String text;
  List<String> titles;

  Inanimate(this.text);

}


class Takeable extends Inanimate {
  
  Takeable(String text) : super(text);
  
}