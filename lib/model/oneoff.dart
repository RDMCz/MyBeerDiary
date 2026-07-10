// "One-off beer" is when user drinks a one beer, which is not part of any particular event

const String _oneoffTable = "Oneoffs";
const String _oneoffColTimestamp = "timestamp";
const String _oneoffColBeerId = "fkBeerId";
const String _oneoffColLitres = "litres";
const String _oneoffColIsDraft = "isDraft";

const String oneoffTableCreate =
    "CREATE TABLE $_oneoffTable ("
    "$_oneoffColTimestamp INTEGER PRIMARY KEY,"
    "$_oneoffColBeerId INTEGER NOT NULL,"
    "$_oneoffColLitres REAL NOT NULL,"
    "$_oneoffColIsDraft INTEGER NOT NULL"
    ")";

class Oneoff {
  final int timestamp;
  final int beerId;
  final double litres;
  final bool isDraft;

  Oneoff({
    required this.timestamp,
    required this.beerId,
    required this.litres,
    required this.isDraft,
  });

  Map<String, Object?> toMap() {
    return {
      _oneoffColTimestamp: timestamp,
      _oneoffColBeerId: beerId,
      _oneoffColLitres: litres,
      _oneoffColIsDraft: isDraft,
    };
  }
}
