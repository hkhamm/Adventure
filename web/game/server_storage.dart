part of game;

class ServerStorage {

  // Load data from a server.
  void loadData() {
    HttpRequest.getString('http://127.0.0.1:8080/save_data')
        .then((String jsonString) {
          JsonObject data = new JsonObject.fromJsonString(jsonString);

          // Set player inventory.
          player.inventory.clear();
          for (var item in data.inventory) {
            player.inventory.putIfAbsent(
                item[0], () => new Inanimate(item[1], item[2]));
          }

          // Set player location.
          player.location = locations[data.currentLocation];

          // Set locations' takeables' state (bool).
          for (var location in data.locations) {
            locations[location[0]].inanimates[location[1]].taken = location[2];
          }

          updateView();
    });
  }

  // Save data to a server.
  void saveData() {
    HttpRequest request = new HttpRequest(); // create a new XHR

    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
        // data saved OK.
        print('Server: ' + request.responseText);
      }
    });

    // POST the data to the server
    request.open("POST", 'http://127.0.0.1:8080/save_data', async: false);

    var saveData = new Map();

    // Save the player's inventory.
    saveData["inventory"] = new List();
    var inventory = player.inventory.keys;
    for (var item in inventory) {
      saveData["inventory"].add([item, player.inventory[item].examineText,
                                 player.inventory[item].locationText]);
    }

    // Save the players location.
    saveData["currentLocation"] = player.location.title;

    // Save the state of takeables from every location.
    saveData["locations"] = new List();
    for (var location in locations.keys) {
      for (var inanimate in locations[location].inanimates.keys) {
        if (locations[location].inanimates[inanimate] is Takeable) {
          saveData["locations"].add(
              [location, inanimate,
               locations[location].inanimates[inanimate].taken]);
        }
      }
    }

    String jsonData = JSON.encode(saveData);
    request.send(jsonData); // perform the async POST
  }
}