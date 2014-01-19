part of game;


/**
 * A class to manage a list of gameData in memory
 * and in an IndexedDB.
 */
class AdventureStore {
  static const String ADVENTURE_STORE = 'adventureStore';
  static const String NAME_INDEX = 'name_index';

  Database _db;
  Map gameData;

  AdventureStore() {
    gameData = new Map();
  }

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

    // Create an index to search by name,
    // unique is true: the index doesn't allow duplicate adventure names.
    objectStore.createIndex(NAME_INDEX, 'adventureName', unique: true);

    loadData();
  }

  // Loads all of the existing objects from the database.
  // The future completes when loading is finished.
  Future _loadFromDB(Database db) {
    _db = db;

    var trans = db.transaction(ADVENTURE_STORE, 'readonly');
    var store = trans.objectStore(ADVENTURE_STORE);

    return loadData().then((_) {
      return gameData.length;
    });
  }

  // Load game data into the the gameData map.
  // The future completes when loading is finished.
  Future loadData() {
    var transaction = _db.transaction(ADVENTURE_STORE, 'readonly');
    var objectStore = transaction.objectStore(ADVENTURE_STORE);
    // Get everything in the store.
    var cursors = objectStore.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      // Rebuild the internal game data map.
      gameData.clear();
      gameData.putIfAbsent(cursor.key, () => cursor.value);
    });

    return cursors.length;
  }

  // Add new game data to the Database.
  Future saveData(Map saveGame) {
    print(saveGame);
    var transaction = _db.transaction(ADVENTURE_STORE, 'readwrite');
    var objectStore = transaction.objectStore(ADVENTURE_STORE);

    transaction.objectStore(ADVENTURE_STORE).clear();

    objectStore.add(saveGame, 'save').then((addedKey) {
      // NOTE! The key cannot be used until the transaction completes.

      gameData.putIfAbsent(addedKey, () => saveGame);
    });

    // Note that the game data cannot be queried until the transaction
    // has completed!
    return transaction.completed.then((_) {
      return gameData;
    });
  }
}