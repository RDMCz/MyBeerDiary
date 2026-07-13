// "One-off beer" is when user drinks a one beer, which is not part of any particular event

const String oneoffTable = "Oneoffs";
const String oneoffColTimestamp = "timestamp";
const String oneoffColBeerId = "fkBeerId";
const String oneoffColLitres = "litres";
const String oneoffColIsDraft = "isDraft";

const String oneoffTableCreate =
    "CREATE TABLE $oneoffTable ("
    "$oneoffColTimestamp INTEGER PRIMARY KEY,"
    "$oneoffColBeerId INTEGER NOT NULL,"
    "$oneoffColLitres REAL NOT NULL,"
    "$oneoffColIsDraft INTEGER NOT NULL"
    ")";

const String oneoffTableDrop = "DROP TABLE IF EXISTS $oneoffTable";

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
      oneoffColTimestamp: timestamp,
      oneoffColBeerId: beerId,
      oneoffColLitres: litres,
      oneoffColIsDraft: isDraft,
    };
  }

  static Oneoff fromMap(Map<String, Object?> m) => Oneoff(
    timestamp: m[oneoffColTimestamp] as int,
    beerId: m[oneoffColBeerId] as int,
    litres: m[oneoffColLitres] as double,
    isDraft: (m[oneoffColIsDraft] as int) == 1,
  );

  @override
  String toString() =>
      "timestamp=$timestamp, beerId=$beerId, litres=$litres, isDraft=$isDraft";
}
