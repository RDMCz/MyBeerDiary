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

  const GlobalStats({
    required this.totalBeers,
    required this.totalLitres,
    required this.totalPrice,
    required this.totalDraftBeers,
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

  final result = await db.rawQuery("""
  SELECT 
    COUNT($beerConsumptionColId) as $keyTotalBeers
    , SUM($beerConsumptionColPrice) as $keyTotalPrice
    , SUM($beerConsumptionColLitres) as $keyTotalLitres
    , SUM($beerConsumptionColIsDraft) as $keyTotalDraftBeers
  FROM $beerConsumptionTable $where
""");

  final row = result.first;
  final totalBeers = (row[keyTotalBeers] as int?) ?? 0;

  if (totalBeers <= 0) {
    return null;
  }

  return GlobalStats(
    totalBeers: totalBeers,
    totalLitres: ((row[keyTotalLitres] as num?)?.toDouble()) ?? 0.0,
    totalPrice: (row[keyTotalPrice] as int?) ?? 0,
    totalDraftBeers: (row[keyTotalDraftBeers] as int?) ?? 0,
  );
}
