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


class View extends ChangeNotifier {

  ButtonElement enterButton;
  InputElement inputField;
  DivElement descriptionBox;
  ParagraphElement description;
  TitleElement pageTitle;
  HeadingElement roomName;

  List<String> _currentInput;
  @observable get currentInput => _currentInput;
  @observable set currentInput(value) {
    _currentInput = notifyPropertyChange(#currentInput, _currentInput, value);
  }

  View() {
    enterButton = querySelector('#button');
    enterButton.onClick.listen(handleMouseEvent);

    inputField = querySelector('#input');
    inputField.onKeyPress.listen(handleKeyEvent);

    descriptionBox = querySelector('#descriptionBox');
    description = querySelector('#description');
    pageTitle = querySelector('#pageTitle');
    roomName = querySelector('#roomName');
  }

  void handleKeyEvent(KeyboardEvent event) {
    var keyEvent = new KeyEvent.wrap(event);
    if (keyEvent.keyCode == KeyCode.ENTER) {
      handleInput();
    }
  }

  void handleMouseEvent(MouseEvent event) {
    handleInput();
  }

  void handleInput() {
    text = inputField.value;
    currentInput = inputField.value.toLowerCase()
                                   .trim()
                                   .replaceAll(' a ', ' ')
                                   .replaceAll(' an ', ' ')
                                   .replaceAll(' to ', ' ')
                                   .replaceAll(' the ', ' ')
                                   .replaceAll(' into ', ' ')
                                   .replaceAll(' in ', ' ')
                                   .split(' ');

    inputField.value = '';
  }

  String get title => pageTitle.text;

  void set title(String title) {
    var string = '$title of a dungeon';
    if (title != null && string != roomName) {
      pageTitle.text = string;
      roomName.text = string;
    }
  }

  void set text(String text) {
    var p = new ParagraphElement();
    p.innerHtml = text;
    p.id = 'description';
    descriptionBox.children.add(p);
    descriptionBox.scrollTop = descriptionBox.scrollHeight;
  }
}