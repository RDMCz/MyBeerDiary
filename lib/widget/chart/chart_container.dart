import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";

class ChartContainer extends StatelessWidget {
  final Widget child;

  const ChartContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: EdgeInsets.only(
          right: CardListCommon.listPaddingHorizontal + 4,
        ),
        child: child,
      ),
    );
  }
}
