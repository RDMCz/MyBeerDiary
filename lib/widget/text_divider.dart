import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";

class TextDivider extends StatelessWidget {
  final String text;

  const TextDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: DialogCommon.bodyMarginBottom),
        Row(
          children: [
            SizedBox(width: 10, child: Divider()),
            SizedBox(width: 3),
            Transform.translate(
              offset: Offset(0, -2),
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            SizedBox(width: 3),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom / 2),
      ],
    );
  }
}
