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
