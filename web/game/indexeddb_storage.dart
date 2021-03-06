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


/**
 * A class to manage a list of gameData in memory and in an IndexedDB.
 */
class IndexedDBStorage {
  static const String ADVENTURE_STORE = 'adventureStore';
  static const String NAME_INDEX = 'name_index';

  Database _db;
  Map _gameData;

  IndexedDBStorage() {
    _gameData = new Map();
  }

  void set gameData(Map data) {
    _gameData = data;
  }

  Map get gameData => _gameData;

  Future open() {
    return window.indexedDB.open('adventureDB',
        version: 1,
        onUpgradeNeeded: _initializeDatabase)
          .then(_loadFromDB);
  }

  // Initializes the object store if it is brand new,
  // or upgrades it if the version is older.
  void _initializeDatabase(VersionChangeEvent e) {
    Database db = (e.target as Request).result;

    var objectStore = db.createObjectStore(ADVENTURE_STORE,
        autoIncrement: true);

    objectStore.createIndex(NAME_INDEX, 'currentLocation', unique: true);

    loadData();
  }

  // Loads all of the existing objects from the database.
  // The future completes when loading is finished.
  void _loadFromDB(Database db) {
    _db = db;

   loadData();
  }

  // Loads game data into the gameData map.
  // The future completes when loading is finished.
  void loadData() {
    var transaction = _db.transaction(ADVENTURE_STORE, 'readonly');
    var objectStore = transaction.objectStore(ADVENTURE_STORE);
    // Get everything in the store.
    var cursors = objectStore.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      // Rebuild the internal game data map.
      gameData.clear();
      gameData.putIfAbsent(cursor.key, () => cursor.value);
    });
  }

  // Adds new game data to the Database.
  void saveData(Map saveGame) {
    var transaction = _db.transaction(ADVENTURE_STORE, 'readwrite');
    var objectStore = transaction.objectStore(ADVENTURE_STORE);

    transaction.objectStore(ADVENTURE_STORE).clear();

    objectStore.add(saveGame, 'save').then((addedKey) {
      // NOTE! The key cannot be used until the transaction completes.
      gameData.putIfAbsent(addedKey, () => saveGame);
    });
  }
}
