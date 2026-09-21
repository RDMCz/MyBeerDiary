import "dart:io";
import "dart:typed_data";

import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:path/path.dart" show join;
import "package:sqflite/sqflite.dart";

class AppDatabase {
  AppDatabase._init();
  static final AppDatabase instance = AppDatabase._init();

  static final _databaseName = "MyBeerDiary.db";
  static final _databaseVersion = 6;
  static Database? _database;

  Future<String> get _dbPath async =>
      join(await getDatabasesPath(), _databaseName);

  Future<void> close() async {
    await _database?.close();
    _database = null;
    // Will lazily reopen
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      await _dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(tagTableCreate);
    await db.execute(eventTableCreate);
    await db.execute(beerTableCreate);
    await db.execute(beerConsumptionTableCreate);

    for (final beer in defaultBeers) {
      //await beerAdd(beer); // Can't do that, function uses db.instance, which was not initalized at this point
      await db.insert(beerTable, beer.toMap());
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(tagTableDrop);
    await db.execute(eventTableDrop);
    await db.execute(beerTableDrop);
    await db.execute(beerConsumptionTableDrop);

    await _onCreate(db, newVersion);
  }

  // .: Database backup :.
  // .:=================:.

  Future<Uint8List> exportBytes() async {
    await close();
    return File(await _dbPath).readAsBytes();
  }

  /// Restores data from backup database on [path] – this deletes all local data (current database).
  /// Returns a [bool] indicating whether the restore was successful
  /// and [String] with error message if it wasn't.
  Future<(bool, String)> restore(String path) async {
    final source = File(path);

    // Copy the new database file to out database directory,
    // do not overwrite the original database yet, we'll check this db first
    final dbDir = await getDatabasesPath();
    final tempPath = join(dbDir, "temporary.db");
    await source.copy(tempPath);

    // We'll check if the database has the required tables for the app to work
    // This should prevent accidental loading of some database that is not from this app
    const expectedTableNames = [
      tagTable,
      eventTable,
      beerTable,
      beerConsumptionTable,
    ];

    try {
      final tempDb = await openDatabase(tempPath, readOnly: true);

      // Check the database for expected tables
      final tableSet = (await tempDb.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      )).map((row) => row["name"]).toSet();

      for (final expectedTableName in expectedTableNames) {
        if (!tableSet.contains(expectedTableName)) {
          return (false, "V databázi chybí tabulka „$expectedTableName“.");
        }
      }

      // tempDb is OK: close current database and replace it
      await close();
      await File(tempPath).copy(await _dbPath);
    } catch (e) {
      return (false, e.toString());
    }

    return (true, "");
  }
}
