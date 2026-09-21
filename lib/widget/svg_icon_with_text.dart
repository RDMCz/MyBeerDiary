import "package:flutter/material.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class SvgIconWithText extends StatelessWidget {
  final SvgIcons icon;
  final String text;
  final TextStyle textStyle;
  final double iconSize;

  const SvgIconWithText({
    super.key,
    required this.icon,
    required this.text,
    required this.textStyle,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgIcon(icon: icon, size: iconSize),
        Text(" $text", style: textStyle),
      ],
    );
  }
}
