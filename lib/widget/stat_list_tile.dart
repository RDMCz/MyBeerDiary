import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";

class StatListTile extends StatelessWidget {
  final Widget? leading;
  final String text;

  const StatListTile({required this.leading, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(text, style: boldTextStyle),
    );
  }
}
