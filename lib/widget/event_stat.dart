import "package:flutter/material.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class EventStat extends StatelessWidget {
  final SvgIcons icon;
  final String text;

  const EventStat({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgIcon(icon: icon),
        Text(
          " $text",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ],
    );
  }
}
