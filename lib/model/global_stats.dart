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
  final Iterable<(int?, int?)> topBeers;

  const GlobalStats({
    required this.totalBeers,
    required this.totalLitres,
    required this.totalPrice,
    required this.totalDraftBeers,
    required this.distinctEvents,
    required this.distinctBeers,
    required this.topBeers,
  });
}

Future<GlobalStats?> globalStats({
  required bool isFilterYear,
  required int selectedYear,
  required bool isFilterTag,
  required Tag selectedTag,
}) async {
  const keyTotalBeers = "totalBeers";
  const keyTotalPrice = "totalPrice";
  const keyTotalLitres = "totalLitres";
  const keyTotalDraftBeers = "totalDraftBeers";
  const keyDistinctEvents = "distinctEvents";
  const keyDistinctBeers = "distinctBeers";
  const keyBeerId = "beerId";
  const keyTimesConsumed = "timesConsumed";

  final db = await AppDatabase.instance.database;

  final whereParts = <String>[];
  if (isFilterYear) {
    final start = dateTimeToSeconds(DateTime(selectedYear, 1, 1));
    final end = dateTimeToSeconds(DateTime(selectedYear, 12, 31));
    whereParts.add(
      "$beerConsumptionColTimestamp >= $start AND $beerConsumptionColTimestamp <= $end",
    );
  }
  if (isFilterTag && selectedTag.id != null) {
    whereParts.add(
      "$beerConsumptionColEventId IN (SELECT $eventColId FROM $eventTable WHERE $eventColTagId = ${selectedTag.id})",
    );
  }
  final where = whereParts.isEmpty ? "" : "WHERE ${whereParts.join(" AND ")}";

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
  $where
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
  $where
  GROUP BY $beerConsumptionColBeerId
  ORDER BY $keyTimesConsumed DESC
  LIMIT 9
""");

  final topBeers = result2.map((row) {
    final beerId = row[keyBeerId] as int?;
    final count = row[keyTimesConsumed] as int?;
    return (beerId, count);
  });

  return GlobalStats(
    totalBeers: totalBeers,
    totalLitres: ((row1[keyTotalLitres] as num?)?.toDouble()) ?? 0.0,
    totalPrice: (row1[keyTotalPrice] as int?) ?? 0,
    totalDraftBeers: (row1[keyTotalDraftBeers] as int?) ?? 0,
    distinctEvents: (row1[keyDistinctEvents] as int?) ?? 0,
    distinctBeers: (row1[keyDistinctBeers] as int?) ?? 0,
    topBeers: topBeers,
  );
}
