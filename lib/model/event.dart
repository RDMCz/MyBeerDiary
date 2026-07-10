// An event where a user drinks more than one beer

import "package:my_beer_diary/db.dart";

const String _eventTable = "Events";
const String _eventColId = "_id";
const String _eventColTagName = "fkTagName";
const String _eventColName = "name";
const String _eventColTimestamp = "timestamp";
const String _eventColTotalBeers = "totalBeers";
const String _eventColTotalCost = "totalCost";

const String eventTableCreate =
    "CREATE TABLE $_eventTable ("
    "$_eventColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$_eventColTagName TEXT," // Tag can be null
    "$_eventColName TEXT," // Name of the event, can also be null (maybe user provides tag with a pub name and there's no need for event name)
    "$_eventColTimestamp INTEGER NOT NULL," // Created at
    "$_eventColTotalBeers INTEGER NOT NULL," // Totals so we don't have to query these
    "$_eventColTotalCost INTEGER NOT NULL"
    ")";

class Event {
  final int? id;
  final String? tagName;
  final String name;
  final int timestamp;
  final int totalBeers;
  final int totalCost;

  Event({
    this.id,
    this.tagName,
    required this.name,
    required this.timestamp,
    required this.totalBeers,
    required this.totalCost,
  });

  Map<String, Object?> toMap() {
    return {
      _eventColId: id,
      _eventColTagName: tagName,
      _eventColName: name,
      _eventColTimestamp: timestamp,
      _eventColTotalBeers: totalBeers,
      _eventColTotalCost: totalCost,
    };
  }

  static Event fromMap(Map<String, Object?> m) => Event(
    id: m[_eventColId] as int?,
    tagName: m[_eventColTagName] as String?,
    name: m[_eventColName] as String,
    timestamp: m[_eventColTimestamp] as int,
    totalBeers: m[_eventColTotalBeers] as int,
    totalCost: m[_eventColTotalCost] as int,
  );

  @override
  String toString() =>
      "id=$id, tagName=$tagName, name=$name, timestamp=$timestamp, totalBeers=$totalBeers, totalCost=$totalCost";
}

Future<void> eventAdd(Event event) async {
  final db = await AppDatabase.instance.database;
  await db.insert(_eventTable, event.toMap());
}

Future<List<Event>> eventList() async {
  const orderBy = "$_eventColTimestamp DESC, $_eventColId DESC";

  final db = await AppDatabase.instance.database;
  final maps = await db.query(_eventTable, orderBy: orderBy);
  return [for (final m in maps) Event.fromMap(m)];
}

Future<void> eventUpdate(Event event) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    _eventTable,
    event.toMap(),
    where: "$_eventColId = ?",
    whereArgs: [event.id],
  );
}

Future<void> eventDelete(int id) async {
  final db = await AppDatabase.instance.database;
  await db.delete(_eventTable, where: "$_eventColId = ?", whereArgs: [id]);
}
