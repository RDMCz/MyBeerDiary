import "dart:math";
import "package:flutter/widgets.dart";

/// Converts String [hex] in "rrggbb" format to Flutter Color
Color hexStringToColor(String hex) =>
    Color(int.tryParse("FF$hex", radix: 16) ?? 0);

/// Converts Flutter Color [color] to String in "rrggbb" format
String colorToHexString(Color color) =>
    color.toARGB32().toRadixString(16).substring(2);

//

Color hueToTagColor(double hue) =>
    HSVColor.fromAHSV(1.0, hue, 0.263, 1.0).toColor();

Color randomTagColor() => hueToTagColor(Random().nextDouble() * 360.0);

double colorHue(Color color) => HSVColor.fromColor(color).hue;
