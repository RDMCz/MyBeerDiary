import "package:my_beer_diary/db.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
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
  final Iterable<(String, int)> topBreweryNames;

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
    required this.topBreweryNames,
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

  // Build where clause for BeerConsumption and Event queries
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

  // .: Query to get SUMs :.
  const keyTotalBeers = "totalBeers";
  const keyTotalPrice = "totalPrice";
  const keyTotalLitres = "totalLitres";
  const keyTotalDraftBeers = "totalDraftBeers";
  const keyDistinctEvents = "distinctEvents";
  const keyDistinctBeers = "distinctBeers";

  final resultSums = await db.rawQuery("""
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

  final rowSums = resultSums.first;
  final totalBeers = (rowSums[keyTotalBeers] as int?) ?? 0;

  // There's no need to continue if the first query's result is empty
  if (totalBeers <= 0) {
    return null;
  }

  // .: Query to get top beers :.
  const nLeaderboardRows = 9;
  const keyBeerId = "beerId";
  const keyTimesConsumed = "timesConsumed";

  final resultTopBeers = await db.rawQuery("""
  SELECT
    $beerConsumptionColBeerId as $keyBeerId
    , COUNT(*) as $keyTimesConsumed
  FROM $beerConsumptionTable
  $whereBC
  GROUP BY $keyBeerId
  ORDER BY $keyTimesConsumed DESC
  LIMIT $nLeaderboardRows
""");

  final topBeers = resultTopBeers.map((row) {
    final beerId = row[keyBeerId] as int?;
    if (beerId != null) {
      final count = (row[keyTimesConsumed] as int?) ?? 0;
      return (beerId, count);
    }
  }).whereType<(int, int)>();

  // .: Query to get top brewery names :.
  const keyBreweryName = "breweryName";

  final resultTopBreweryNames = await db.rawQuery("""
  SELECT
    b.$beerColBreweryName as $keyBreweryName
    , COUNT(*) as $keyTimesConsumed
  FROM $beerConsumptionTable bc
  JOIN $beerTable b ON b.$beerColId = bc.$beerConsumptionColBeerId
  $whereBC
  GROUP BY $keyBreweryName
  ORDER BY $keyTimesConsumed DESC
  LIMIT $nLeaderboardRows
""");

  final topBreweryNames = resultTopBreweryNames.map(
    (row) => (
      (row[keyBreweryName] as String?) ?? "",
      (row[keyTimesConsumed] as int?) ?? 0,
    ),
  );

  // .: Query to get top tags :.
  const keyTagId = "tagId";
  const keyTagCount = "tagCount";
  const keyTagTotalBeers = "tagTotalBeers";
  const keyTagTotalPrice = "tagTotalPrice";

  final resultTopTags = await db.rawQuery("""
  SELECT
    $eventColTagId as $keyTagId
    , COUNT(*) as $keyTagCount
    , SUM($eventColTotalBeers) as $keyTagTotalBeers
    , SUM($eventColTotalCost) as $keyTagTotalPrice
  FROM $eventTable
  $whereEvent
  GROUP BY $keyTagId
  ORDER BY $keyTagCount DESC
  LIMIT $nLeaderboardRows
""");

  final topTags = resultTopTags.map((row) {
    final tagId = row[keyTagId] as int?;
    if (tagId != null) {
      final count = (row[keyTagCount] as int?) ?? 0;
      final totalBeers = (row[keyTagTotalBeers] as int?) ?? 0;
      final totalPrice = (row[keyTagTotalPrice] as int?) ?? 0;
      return (tagId, count, totalBeers, totalPrice);
    }
  }).whereType<(int, int, int, int)>();

  // .: Queries for months/days charts :.
  const keyMonth = "month";
  const keyMonthCount = "monthCount";

  final resultMonthChart = await db.rawQuery("""
  SELECT
    COUNT(*) as $keyMonthCount
    , CAST(strftime('%m', $beerConsumptionColTimestamp, 'unixepoch') as INTEGER) as $keyMonth
  FROM $beerConsumptionTable
  $whereBC
  GROUP BY $keyMonth
""");

  final monthCounter = {for (int i = 1; i <= 12; i++) i: 0};

  for (final row in resultMonthChart) {
    final month = row[keyMonth] as int?;
    if (month != null) {
      final count = (row[keyMonthCount] as int?) ?? 0;
      monthCounter.update(month, (v) => v + count, ifAbsent: () => count);
    }
  }

  const keyWeekday = "weekday";
  const keyWeekdayCount = "weekdayCount";

  final resultWeeakdayChart = await db.rawQuery("""
  SELECT
    COUNT(*) as $keyWeekdayCount
    , CAST(strftime('%w', $beerConsumptionColTimestamp, 'unixepoch') as INTEGER) as $keyWeekday
  FROM $beerConsumptionTable
  $whereBC
  GROUP BY $keyWeekday
""");

  final weekdayCounter = {for (int i = 1; i <= 7; i++) i: 0};

  for (final row in resultWeeakdayChart) {
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
    totalLitres: ((rowSums[keyTotalLitres] as num?)?.toDouble()) ?? 0.0,
    totalPrice: (rowSums[keyTotalPrice] as int?) ?? 0,
    totalDraftBeers: (rowSums[keyTotalDraftBeers] as int?) ?? 0,
    distinctEvents: (rowSums[keyDistinctEvents] as int?) ?? 0,
    distinctBeers: (rowSums[keyDistinctBeers] as int?) ?? 0,
    topBeers: topBeers,
    topBreweryNames: topBreweryNames,
    topTags: topTags,
    monthCounter: monthCounter,
    weekdayCounter: weekdayCounter,
  );
}
