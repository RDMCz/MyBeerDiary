// Act of ordering a beer at a particular event

import "package:my_beer_diary/db.dart";
import "package:sqflite/sqlite_api.dart";

const String ebTable = "EventBeers";
const String ebColEventId = "fkEventId";
const String ebColTimestamp = "timestamp";
const String ebColBeerId = "fkBeerId";
const String ebColLitres = "litres";
const String ebColPrice = "price";
const String ebColIsDraft = "isDraft";

const String ebTableCreate =
    "CREATE TABLE $ebTable ("
    "$ebColEventId INTEGER NOT NULL,"
    "$ebColTimestamp INTEGER NOT NULL,"
    "$ebColBeerId INTEGER NOT NULL,"
    "$ebColLitres REAL NOT NULL,"
    "$ebColPrice INTEGER NOT NULL,"
    "$ebColIsDraft INTEGER NOT NULL,"
    "PRIMARY KEY ($ebColEventId, $ebColTimestamp)"
    ")";

const String ebTableDrop = "DROP TABLE IF EXISTS $ebTable";

class EventBeer {
  final int eventId;
  final int timestamp;
  final int beerId;
  final double litres;
  final int price;
  final bool isDraft;

  EventBeer({
    required this.eventId,
    required this.timestamp,
    required this.beerId,
    required this.litres,
    required this.price,
    required this.isDraft,
  });

  Map<String, Object?> toMap() {
    return {
      ebColEventId: eventId,
      ebColTimestamp: timestamp,
      ebColBeerId: beerId,
      ebColLitres: litres,
      ebColPrice: price,
      ebColIsDraft: isDraft ? 1 : 0,
    };
  }

  static EventBeer fromMap(Map<String, Object?> m) => EventBeer(
    eventId: m[ebColEventId] as int,
    timestamp: m[ebColTimestamp] as int,
    beerId: m[ebColBeerId] as int,
    litres: m[ebColLitres] as double,
    price: m[ebColPrice] as int,
    isDraft: (m[ebColIsDraft] as int) == 1,
  );

  @override
  String toString() =>
      "eventId=$eventId, timestamp=$timestamp, beerId=$beerId, litres=$litres, price=$price, isDraft=$isDraft";
}

Future<void> ebAdd(EventBeer eb) async {
  final db = await AppDatabase.instance.database;
  await db.insert(
    ebTable,
    eb.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<List<EventBeer>> ebList() async {
  final db = await AppDatabase.instance.database;
  final maps = await db.query(ebTable);
  return [for (final m in maps) EventBeer.fromMap(m)];
}

Future<void> ebUpdate(EventBeer eb) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    ebTable,
    eb.toMap(),
    where: "$ebColEventId = ? AND $ebColTimestamp = ?",
    whereArgs: [eb.eventId, eb.timestamp],
  );
}

Future<void> ebDelete(int eventId, int timestamp) async {
  final db = await AppDatabase.instance.database;
  await db.delete(
    ebTable,
    where: "$ebColEventId = ? AND $ebColTimestamp = ?",
    whereArgs: [eventId, timestamp],
  );
}
