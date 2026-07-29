// An event where a user drinks more than one beer

import "package:my_beer_diary/db.dart";
import "package:my_beer_diary/model/beer_consumption.dart";

const String eventTable = "Events";
const String eventColId = "_id";
const String eventColTagId = "fkTagId";
const String eventColName = "name";
const String eventColTimestamp = "timestamp";
const String eventColTotalBeers = "totalBeers";
const String eventColTotalCost = "totalCost";

const String eventTableCreate =
    "CREATE TABLE $eventTable ("
    "$eventColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$eventColTagId INTEGER," // Tag can be null
    "$eventColName TEXT," // Name of the event, can also be null (maybe user provides tag with a pub name and there's no need for event name)
    "$eventColTimestamp INTEGER NOT NULL," // Created at
    "$eventColTotalBeers INTEGER NOT NULL," // Totals so we don't have to query these
    "$eventColTotalCost INTEGER NOT NULL"
    ")";

const String eventTableDrop = "DROP TABLE IF EXISTS $eventTable";

class Event {
  final int? id;
  final int? tagId;
  final String name;
  final int timestamp;
  final int totalBeers;
  final int totalCost;

  const Event({
    this.id,
    this.tagId,
    required this.name,
    required this.timestamp,
    required this.totalBeers,
    required this.totalCost,
  });

  Map<String, Object?> toMap() {
    return {
      eventColId: id,
      eventColTagId: tagId,
      eventColName: name,
      eventColTimestamp: timestamp,
      eventColTotalBeers: totalBeers,
      eventColTotalCost: totalCost,
    };
  }

  static Event fromMap(Map<String, Object?> m) => Event(
    id: m[eventColId] as int?,
    tagId: m[eventColTagId] as int?,
    name: m[eventColName] as String,
    timestamp: m[eventColTimestamp] as int,
    totalBeers: m[eventColTotalBeers] as int,
    totalCost: m[eventColTotalCost] as int,
  );

  Event copyWith({
    int? Function()? id,
    int? Function()? tagId,
    String Function()? name,
    int Function()? timestamp,
    int Function()? totalBeers,
    int Function()? totalCost,
  }) => Event(
    id: id != null ? id() : this.id,
    tagId: tagId != null ? tagId() : this.tagId,
    name: name != null ? name() : this.name,
    timestamp: timestamp != null ? timestamp() : this.timestamp,
    totalBeers: totalBeers != null ? totalBeers() : this.totalBeers,
    totalCost: totalCost != null ? totalCost() : this.totalCost,
  );

  @override
  String toString() =>
      "id=$id, tagId=$tagId, name=$name, timestamp=$timestamp, totalBeers=$totalBeers, totalCost=$totalCost";
}

Future<void> eventAdd(Event event) async {
  final db = await AppDatabase.instance.database;
  await db.insert(eventTable, event.toMap());
}

Future<List<Event>> eventList() async {
  const orderBy = "$eventColTimestamp DESC, $eventColId DESC";

  final db = await AppDatabase.instance.database;
  final maps = await db.query(eventTable, orderBy: orderBy);
  return [for (final m in maps) Event.fromMap(m)];
}

Future<void> eventUpdate(Event event) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    eventTable,
    event.toMap(),
    where: "$eventColId = ?",
    whereArgs: [event.id],
  );
}

Future<void> eventUpdateTotals({
  required int eventId,
  required int totalBeersIncrease,
  required int totalCostIncrease,
}) async {
  final db = await AppDatabase.instance.database;

  final eventQuery = await db.query(
    eventTable,
    where: "$eventColId = ?",
    whereArgs: [eventId],
    limit: 1,
  );

  if (eventQuery.isEmpty) {
    return;
  }

  final event = Event.fromMap(eventQuery.first);

  await eventUpdate(
    event.copyWith(
      totalBeers: () => event.totalBeers + totalBeersIncrease,
      totalCost: () => event.totalCost + totalCostIncrease,
    ),
  );
}

Future<void> eventDelete(int id) async {
  final db = await AppDatabase.instance.database;
  // Delete the event
  await db.delete(eventTable, where: "$eventColId = ?", whereArgs: [id]);
  // Delete event's beer consumptions
  await beerConsumptionOnEventDelete(id);
}
