// Sources:
// https://www.brewersfriend.com/abv-calculator/
// https://www.brewersfriend.com/plato-to-sg-conversion-chart/

import "dart:math";

// .: EPM to ABV :.
// .:============:.

// To get ABV, we need two values: "original gravity" and "final gravity" (OG & FG)
// We can calculate OG from EPM (which is commonly stated)
// FG is not usually stated, so we approximate
const finalGravitySG1 = 1.0109079891683685;

// Formula uses SG1 unit, but EPM is Plato unit
double platoToSG1(double plato) =>
    1.0 + (plato / (258.6 - ((plato / 258.2) * 227.1)));

// Approximation
double epmToAbv(double originalGravityPlato) {
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
/* https://github.com/RadekMocek/PAA/blob/main/app/src/main/java/com/radekmocek/mybeerdiary/util/Calc.java */
