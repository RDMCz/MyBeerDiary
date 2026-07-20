import "dart:ui";

/// Converts String [hex] in "rrggbb" format to Flutter Color
Color hexStringToColor(String hex) =>
    Color(int.tryParse("FF$hex", radix: 16) ?? 0);

/// Converts Flutter Color [color] to String in "rrggbb" format
String colorToHexString(Color color) =>
    color.toARGB32().toRadixString(16).substring(2);
