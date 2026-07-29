// Act of ordering/drinking a beer

import "package:my_beer_diary/db.dart";

const String beerConsumptionTable = "BeerConsumptions";
const String beerConsumptionColId = "_id";
const String beerConsumptionColTimestamp = "timestamp";
const String beerConsumptionColEventId = "fkEventId";
const String beerConsumptionColBeerId = "fkBeerId";
const String beerConsumptionColLitres = "litres";
const String beerConsumptionColPrice = "price";
const String beerConsumptionColIsDraft = "isDraft";

const String beerConsumptionTableCreate =
    "CREATE TABLE $beerConsumptionTable ("
    "$beerConsumptionColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$beerConsumptionColTimestamp INTEGER NOT NULL,"
    "$beerConsumptionColEventId INTEGER," // NULL = One-off beer, NOT NULL = Event beer
    "$beerConsumptionColBeerId INTEGER," // NULL = Unknown beer
    "$beerConsumptionColLitres REAL NOT NULL,"
    "$beerConsumptionColPrice INTEGER NOT NULL,"
    "$beerConsumptionColIsDraft INTEGER NOT NULL"
    ")";

const String beerConsumptionTableDrop =
    "DROP TABLE IF EXISTS $beerConsumptionTable";

class BeerConsumption {
  final int? id;
  final int timestamp;
  final int? eventId;
  final int? beerId;
  final double litres;
  final int price;
  final bool isDraft;

  const BeerConsumption({
    this.id,
    required this.timestamp,
    this.eventId,
    this.beerId,
    required this.litres,
    required this.price,
    required this.isDraft,
  });

  Map<String, Object?> toMap() {
    return {
      beerConsumptionColId: id,
      beerConsumptionColTimestamp: timestamp,
      beerConsumptionColEventId: eventId,
      beerConsumptionColBeerId: beerId,
      beerConsumptionColLitres: litres,
      beerConsumptionColPrice: price,
      beerConsumptionColIsDraft: isDraft ? 1 : 0,
    };
  }

  static BeerConsumption fromMap(Map<String, Object?> m) => BeerConsumption(
    id: m[beerConsumptionColId] as int?,
    timestamp: m[beerConsumptionColTimestamp] as int,
    eventId: m[beerConsumptionColEventId] as int?,
    beerId: m[beerConsumptionColBeerId] as int?,
    litres: m[beerConsumptionColLitres] as double,
    price: m[beerConsumptionColPrice] as int,
    isDraft: (m[beerConsumptionColIsDraft] as int) == 1,
  );

  BeerConsumption copyWith({
    int? Function()? id,
    int Function()? timestamp,
    int? Function()? eventId,
    int? Function()? beerId,
    double Function()? litres,
    int Function()? price,
    bool Function()? isDraft,
  }) => BeerConsumption(
    id: id != null ? id() : this.id,
    timestamp: timestamp != null ? timestamp() : this.timestamp,
    eventId: eventId != null ? eventId() : this.eventId,
    beerId: beerId != null ? beerId() : this.beerId,
    litres: litres != null ? litres() : this.litres,
    price: price != null ? price() : this.price,
    isDraft: isDraft != null ? isDraft() : this.isDraft,
  );

  @override
  String toString() =>
      "id=$id, timestamp=$timestamp, eventId=$eventId, beerId=$beerId, litres=$litres, price=$price, isDraft=$isDraft";
}

Future<void> beerConsumptionAdd(BeerConsumption bc) async {
  final db = await AppDatabase.instance.database;
  await db.insert(beerConsumptionTable, bc.toMap());
}

Future<List<BeerConsumption>> beerConsumptionList(int? eventId) async {
  final db = await AppDatabase.instance.database;
  final maps = await db.query(
    beerConsumptionTable,
    where: "$beerConsumptionColEventId = ?",
    whereArgs: [eventId],
  );
  return [for (final m in maps) BeerConsumption.fromMap(m)];
}

Future<List<BeerConsumption>> beerConsumptionListAll() async {
  final db = await AppDatabase.instance.database;
  final maps = await db.query(beerConsumptionTable);
  return [for (final m in maps) BeerConsumption.fromMap(m)];
}

Future<void> beerConsumptionUpdate(BeerConsumption bc) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    beerConsumptionTable,
    bc.toMap(),
    where: "$beerConsumptionColId = ?",
    whereArgs: [bc.id],
  );
}

Future<void> beerConsumptionDelete(int id) async {
  final db = await AppDatabase.instance.database;
  await db.delete(
    beerConsumptionTable,
    where: "$beerConsumptionColId = ?",
    whereArgs: [id],
  );
}

Future<void> beerConsumptionOnEventDelete(int eventId) async {
  final db = await AppDatabase.instance.database;
  await db.delete(
    beerConsumptionTable,
    where: "$beerConsumptionColEventId = ?",
    whereArgs: [eventId],
  );
}
