// An event where a user drinks more than one beer

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
}
