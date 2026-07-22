import "package:flutter/material.dart";
import "package:my_beer_diary/logic/color.dart";
import "package:my_beer_diary/model/tag.dart";

class TagChip extends StatelessWidget {
  final Tag tag;

  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Chip(
      //avatar: Icon(Icons.tag),
      label: Text(tag.name),
      backgroundColor: hexStringToColor(tag.color),
      labelPadding: EdgeInsets.all(0),
      labelStyle: TextStyle(color: Colors.black, fontSize: 15),
      // Make chip smaller:
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
