import "package:flutter/material.dart";

class TagChip extends StatelessWidget {
  final String tagName;

  const TagChip({super.key, required this.tagName});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.tag),
      label: Text(tagName),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      labelPadding: EdgeInsets.all(0),
      labelStyle: TextStyle(color: Colors.black, fontSize: 15),
      // Make chip smaller:
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
