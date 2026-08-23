// Sources:
// https://www.brewersfriend.com/abv-calculator/
// https://www.brewersfriend.com/plato-to-sg-conversion-chart/
// https://www.ukiaft.org/wp-content/uploads/ukiaft-atd-v4.4.pdf

import "dart:math";

import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event_stats.dart";
import "package:my_beer_diary/model/user_settings.dart";

// .: EPM to ABV :.
// .:============:.

// EPM to ABV formula uses SG1 unit, but EPM is Plato unit
double platoToSG1(double plato) =>
    1.0 + (plato / (258.6 - ((plato / 258.2) * 227.1)));

// Approximation
double epmToAbv(double originalGravityPlato) {
  // To get ABV, we need two values: "original gravity" and "final gravity" (OG & FG)
  // We can calculate OG from EPM (which is commonly stated)
  // FG is not usually stated, so we approximate
  const finalGravitySG1 = 1.0109079891683685;

  final originalGravitySG1 = platoToSG1(originalGravityPlato);
  return (76.08 *
          (originalGravitySG1 - finalGravitySG1) /
          (1.775 - originalGravitySG1)) *
      (finalGravitySG1 / 0.794);
}

// For use in [BeerAddEditDialog]
double textFieldToDouble(String s) => double.tryParse(s) ?? 0.0;

String doubleToTextField(double d) => d.toStringAsFixed(2);

String epmToAbvDialog(String epmStr) {
  final epm = textFieldToDouble(epmStr);

  final abv = max(epmToAbv(epm), 0.0);

  return doubleToTextField(abv);
}

// .: BAC :.
// .:=====:.

double totalBodyWater({
  required bool isMale,
  required int ageYears,
  required int heightCm,
  required int weightKg,
}) => isMale
    ? 2.447 - 0.09516 * ageYears + 0.1074 * heightCm + 0.3362 * weightKg
    : -2.097 + 0.1069 * heightCm + 0.2466 * weightKg;

double alcoholPermille({
  required double litres,
  required double abv,
  required bool isMale,
  required double totalBodyWater,
}) {
  const ethanolDensity = 789.45; // g/L
  const bloodWaterMale = 0.825;
  const bloodWaterFemale = 0.838;

  final bloodWater = isMale ? bloodWaterMale : bloodWaterFemale;
  final ethanol = (litres * abv * ethanolDensity) / 100.0; // g
  return (ethanol * bloodWater) / totalBodyWater;
}

/// Calculates [EventStats] for given [beerConsumptions].
/// Assuming [beerConsumptions] is sorted by [BeerConsumption.timestamp] from oldest to newest.
EventStats? eventStats({
  required Map<int, Beer> beers,
  required List<BeerConsumption> beerConsumptions,
  required UserSettings userSettings,
}) {
  const metabolismPermillePerHour = 0.15;

  if (beerConsumptions.isEmpty) {
    return null;
  }

  final tbw = totalBodyWater(
    isMale: userSettings.isMale,
    ageYears: DateTime.now().year - userSettings.birthyear,
    heightCm: userSettings.height,
    weightKg: userSettings.weight,
  );

  double permille = alcoholPermille(
    litres: beerConsumptions[0].litres,
    abv: (beers[beerConsumptions[0].beerId] ?? Beer.unknownBeer).abv,
    isMale: userSettings.isMale,
    totalBodyWater: tbw,
  );

  int prevTimestamp = beerConsumptions[0].timestamp;
  double maxPermille = permille;

  for (final bc in beerConsumptions.skip(1)) {
    // Sobering
    final timestampDiff = bc.timestamp - prevTimestamp;
    final timestampDiffHours = timestampDiff / Duration.secondsPerHour;

    final prevPermille = permille; // Save in case bac goes under zero

    permille -= timestampDiffHours * metabolismPermillePerHour;

    if (permille < 0) {
      permille = 0;
      //todo use prevPermille to get sober timestamp
    }

    // Drank another beer
    permille += alcoholPermille(
      litres: bc.litres,
      abv: (beers[bc.beerId] ?? Beer.unknownBeer).abv,
      isMale: userSettings.isMale,
      totalBodyWater: tbw,
    );

    if (permille > maxPermille) {
      maxPermille = permille;
    }

    // Prepare for next loop
    prevTimestamp = bc.timestamp;
  }

  return EventStats(maxPermille: maxPermille);
}
