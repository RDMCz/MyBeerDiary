import 'package:my_beer_diary/db.dart';
import 'package:my_beer_diary/model/beer_consumption.dart';

/// To transfer all the data shown on the [GlobalStatsScreen]
class GlobalStats {
  final int totalBeers;
  final double totalLitres;
  final int totalPrice;
  final BeerConsumption averageBeerConsumption;

  const GlobalStats({
    required this.totalBeers,
    required this.totalLitres,
    required this.totalPrice,
    required this.averageBeerConsumption,
  });
}

Future<GlobalStats?> globalStats() async {
  final db = await AppDatabase.instance.database;

  const keyTotalBeers = "totalBeers";
  const keyTotalPrice = "totalPrice";
  const keyTotalLitres = "totalLitres";
  const keyAvgPrice = "avgPrice";
  const keyAvgLitres = "avgLitres";

  final result = await db.rawQuery("""
  SELECT 
    COUNT($beerConsumptionColId) as $keyTotalBeers
    , SUM($beerConsumptionColPrice) as $keyTotalPrice
    , SUM($beerConsumptionColLitres) as $keyTotalLitres
    , AVG($beerConsumptionColPrice) as $keyAvgPrice
    , AVG($beerConsumptionColLitres) as $keyAvgLitres
  FROM $beerConsumptionTable
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
    averageBeerConsumption: BeerConsumption(
      timestamp: 0,
      beerId: -1,
      litres: ((row[keyAvgLitres] as num?)?.toDouble()) ?? 0.0,
      price: ((row[keyAvgPrice] as num?)?.round()) ?? 0,
      isDraft: true,
    ),
  );
}
