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
  static final _databaseVersion = 4;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final defaultPath = await getDatabasesPath();
    final dbPath = join(defaultPath, _databaseName);
    return await openDatabase(
      dbPath,
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
}
