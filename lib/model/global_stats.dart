import "package:my_beer_diary/db.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";

/// To transfer all the data shown on the [GlobalStatsScreen]
class GlobalStats {
  final int totalBeers;
  final double totalLitres;
  final int totalPrice;
  final int totalDraftBeers;
  final int distinctEvents;
  final int distinctBeers;
  final Iterable<(int, int)> topBeers;

  /// Iterable<(Tag ID, number of occurrences, total beers, total price)>
  final Iterable<(int, int, int, int)> topTags;

  const GlobalStats({
    required this.totalBeers,
    required this.totalLitres,
    required this.totalPrice,
    required this.totalDraftBeers,
    required this.distinctEvents,
    required this.distinctBeers,
    required this.topBeers,
    required this.topTags,
  });
}

Future<GlobalStats?> globalStats({
  required bool isFilterYear,
  required int selectedYear,
  required bool isFilterTag,
  required Tag selectedTag,
  required bool isFilterOneoffs,
}) async {
  const keyTotalBeers = "totalBeers";
  const keyTotalPrice = "totalPrice";
  const keyTotalLitres = "totalLitres";
  const keyTotalDraftBeers = "totalDraftBeers";
  const keyDistinctEvents = "distinctEvents";
  const keyDistinctBeers = "distinctBeers";
  const keyBeerId = "beerId";
  const keyTimesConsumed = "timesConsumed";
  const keyTagId = "tagId";
  const keyTagCount = "tagCount";
  const keyTagTotalBeers = "tagTotalBeers";
  const keyTagTotalPrice = "tagTotalPrice";

  const nLeaderboardRows = 9;

  if (isFilterTag && isFilterOneoffs) {
    // Oneoffs can't have tags assigned to them
    return null;
  }

  final db = await AppDatabase.instance.database;

  final wherePartsBC = <String>[];
  String whereEvent = "";

  if (isFilterYear) {
    final start = dateTimeToSeconds(DateTime(selectedYear, 1, 1));
    final end = dateTimeToSeconds(DateTime(selectedYear, 12, 31));
    wherePartsBC.add(
      "$beerConsumptionColTimestamp >= $start AND $beerConsumptionColTimestamp <= $end",
    );
    whereEvent =
        "WHERE $eventColTimestamp >= $start AND $eventColTimestamp <= $end";
  }

  if (isFilterTag && selectedTag.id != null) {
    wherePartsBC.add(
      "$beerConsumptionColEventId IN (SELECT $eventColId FROM $eventTable WHERE $eventColTagId = ${selectedTag.id})",
    );
  }

  if (isFilterOneoffs) {
    wherePartsBC.add("$beerConsumptionColEventId IS NULL");
  }

  final whereBC = wherePartsBC.isEmpty
      ? ""
      : "WHERE ${wherePartsBC.join(" AND ")}";

  // First query to get SUMs
  final result1 = await db.rawQuery("""
  SELECT 
    COUNT($beerConsumptionColId) as $keyTotalBeers
    , SUM($beerConsumptionColPrice) as $keyTotalPrice
    , SUM($beerConsumptionColLitres) as $keyTotalLitres
    , SUM($beerConsumptionColIsDraft) as $keyTotalDraftBeers
    , COUNT(DISTINCT $beerConsumptionColEventId) as $keyDistinctEvents
    , COUNT(DISTINCT $beerConsumptionColBeerId) as $keyDistinctBeers
  FROM $beerConsumptionTable
  $whereBC
""");

  final row1 = result1.first;
  final totalBeers = (row1[keyTotalBeers] as int?) ?? 0;

  // There's no need to continue if the first query's result is empty
  if (totalBeers <= 0) {
    return null;
  }

  // Second query to get top beers
  final result2 = await db.rawQuery("""
  SELECT
    $beerConsumptionColBeerId as $keyBeerId
    , COUNT(*) as $keyTimesConsumed
  FROM $beerConsumptionTable
  $whereBC
  GROUP BY $beerConsumptionColBeerId
  ORDER BY $keyTimesConsumed DESC
  LIMIT $nLeaderboardRows
""");

  final topBeers = result2.map((row) {
    final beerId = row[keyBeerId] as int?;
    if (beerId != null) {
      final count = (row[keyTimesConsumed] as int?) ?? 0;
      return (beerId, count);
    }
  }).whereType<(int, int)>();

  // Third query to get top tags
  final result3 = await db.rawQuery("""
  SELECT
    $eventColTagId as $keyTagId
    , COUNT(*) as $keyTagCount
    , SUM($eventColTotalBeers) as $keyTagTotalBeers
    , SUM($eventColTotalCost) as $keyTagTotalPrice
  FROM $eventTable
  $whereEvent
  GROUP BY $eventColTagId
  ORDER BY $keyTagCount DESC
  LIMIT $nLeaderboardRows
""");

  final topTags = result3.map((row) {
    final tagId = row[keyTagId] as int?;
    if (tagId != null) {
      final count = (row[keyTagCount] as int?) ?? 0;
      final totalBeers = (row[keyTagTotalBeers] as int?) ?? 0;
      final totalPrice = (row[keyTagTotalPrice] as int?) ?? 0;
      return (tagId, count, totalBeers, totalPrice);
    }
  }).whereType<(int, int, int, int)>();

  return GlobalStats(
    totalBeers: totalBeers,
    totalLitres: ((row1[keyTotalLitres] as num?)?.toDouble()) ?? 0.0,
    totalPrice: (row1[keyTotalPrice] as int?) ?? 0,
    totalDraftBeers: (row1[keyTotalDraftBeers] as int?) ?? 0,
    distinctEvents: (row1[keyDistinctEvents] as int?) ?? 0,
    distinctBeers: (row1[keyDistinctBeers] as int?) ?? 0,
    topBeers: topBeers,
    topTags: topTags,
  );
}
