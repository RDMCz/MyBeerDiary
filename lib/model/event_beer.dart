const String _ebTable = "EventBeers";
const String _ebColEventId = "fkEventId";
const String _ebColTimestamp = "timestamp";
const String _ebColBeerId = "fkBeerId";
const String _ebColLitres = "litres";
const String _ebColPrice = "price";
const String _ebColIsDraft = "isDraft";

const String ebTableCreate =
    "CREATE TABLE $_ebTable ("
    "$_ebColEventId INTEGER NOT NULL,"
    "$_ebColTimestamp INTEGER NOT NULL,"
    "$_ebColBeerId INTEGER NOT NULL,"
    "$_ebColLitres REAL NOT NULL,"
    "$_ebColPrice INTEGER NOT NULL,"
    "$_ebColIsDraft INTEGER NOT NULL,"
    "PRIMARY KEY ($_ebColEventId, $_ebColTimestamp)"
    ")";

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
      _ebColEventId: eventId,
      _ebColTimestamp: timestamp,
      _ebColBeerId: beerId,
      _ebColLitres: litres,
      _ebColPrice: price,
      _ebColIsDraft: isDraft ? 1 : 0,
    };
  }
}
