import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/widget/text_divider.dart";

class StatLeaderboard extends StatelessWidget {
  final String headerText;
  final List<Widget> children;

  const StatLeaderboard({
    super.key,
    required this.headerText,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextDivider(text: headerText),
        DefaultTextStyle.merge(
          style: TextStyle(fontSize: 16.0),
          child: Padding(
            padding: CardListCommon.horizontalPaddingOnly,
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
