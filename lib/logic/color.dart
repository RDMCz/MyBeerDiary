import "dart:ui";

Color hexStringToColor(String hex) {
  return Color(int.tryParse("FF$hex", radix: 16) ?? 0);
}
