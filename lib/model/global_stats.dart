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
  final Map<int, int> monthCounter;
  final Map<int, int> weekdayCounter;

  const GlobalStats({
    required this.totalBeers,
    required this.totalLitres,
    required this.totalPrice,
    required this.totalDraftBeers,
    required this.distinctEvents,
    required this.distinctBeers,
    required this.topBeers,
    required this.topTags,
    required this.monthCounter,
    required this.weekdayCounter,
  });
}

Future<GlobalStats?> globalStats({
  required bool isFilterYear,
  required int selectedYear,
  required bool isFilterTag,
  required Tag selectedTag,
  required bool isFilterOneoffs,
}) async {
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
  const keyTotalBeers = "totalBeers";
  const keyTotalPrice = "totalPrice";
  const keyTotalLitres = "totalLitres";
  const keyTotalDraftBeers = "totalDraftBeers";
  const keyDistinctEvents = "distinctEvents";
  const keyDistinctBeers = "distinctBeers";

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
  const nLeaderboardRows = 9;
  const keyBeerId = "beerId";
  const keyTimesConsumed = "timesConsumed";

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
  const keyTagId = "tagId";
  const keyTagCount = "tagCount";
  const keyTagTotalBeers = "tagTotalBeers";
  const keyTagTotalPrice = "tagTotalPrice";

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

  // Fourth & fifth query for months/days charts
  const keyMonth = "month";
  const keyMonthCount = "monthCount";

  final result4 = await db.rawQuery("""
  SELECT
    COUNT(*) as $keyMonthCount
    , CAST(strftime('%m', $beerConsumptionColTimestamp, 'unixepoch') as INTEGER) as $keyMonth
  FROM $beerConsumptionTable
  $whereBC
  GROUP BY $keyMonth
""");

  final monthCounter = {for (int i = 1; i <= 12; i++) i: 0};

  for (final row in result4) {
    final month = row[keyMonth] as int?;
    if (month != null) {
      final count = (row[keyMonthCount] as int?) ?? 0;
      monthCounter.update(month, (v) => v + count, ifAbsent: () => count);
    }
  }

  const keyWeekday = "weekday";
  const keyWeekdayCount = "weekdayCount";

  final result5 = await db.rawQuery("""
  SELECT
    COUNT(*) as $keyWeekdayCount
    , CAST(strftime('%w', $beerConsumptionColTimestamp, 'unixepoch') as INTEGER) as $keyWeekday
  FROM $beerConsumptionTable
  $whereBC
  GROUP BY $keyWeekday
""");

  final weekdayCounter = {for (int i = 1; i <= 7; i++) i: 0};

  for (final row in result5) {
    final weekday = row[keyWeekday] as int?;
    if (weekday != null) {
      final count = (row[keyWeekdayCount] as int?) ?? 0;

      // Convert '%w' to '%u'
      final correctWeekday = weekday == 0 ? 7 : weekday;

      weekdayCounter.update(
        correctWeekday,
        (v) => v + count,
        ifAbsent: () => count,
      );
    }
  }

  return GlobalStats(
    totalBeers: totalBeers,
    totalLitres: ((row1[keyTotalLitres] as num?)?.toDouble()) ?? 0.0,
    totalPrice: (row1[keyTotalPrice] as int?) ?? 0,
    totalDraftBeers: (row1[keyTotalDraftBeers] as int?) ?? 0,
    distinctEvents: (row1[keyDistinctEvents] as int?) ?? 0,
    distinctBeers: (row1[keyDistinctBeers] as int?) ?? 0,
    topBeers: topBeers,
    topTags: topTags,
    monthCounter: monthCounter,
    weekdayCounter: weekdayCounter,
  );
}
