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

const String oneoffTableDrop = "DROP TABLE IF EXISTS $_oneoffTable";

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

  static Oneoff fromMap(Map<String, Object?> m) => Oneoff(
    timestamp: m[_oneoffColTimestamp] as int,
    beerId: m[_oneoffColBeerId] as int,
    litres: m[_oneoffColLitres] as double,
    isDraft: (m[_oneoffColIsDraft] as int) == 1,
  );

  @override
  String toString() =>
      "timestamp=$timestamp, beerId=$beerId, litres=$litres, isDraft=$isDraft";
}
