import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";

class StatListTile extends StatelessWidget {
  final Widget? leading;
  final String text;
  final String? subtext;

  const StatListTile({
    super.key,
    required this.leading,
    required this.text,
    this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: Text(text, style: boldTextStyle),
          subtitle: subtext == null
              ? null
              : Text(subtext!, style: TextStyle(fontSize: 16.0)),
        ),
        Divider(height: 0),
      ],
    );
  }
}
