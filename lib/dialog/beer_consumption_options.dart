import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";

class BeerConsumptionOptionsDialog extends StatelessWidget {
  final String title;

  const BeerConsumptionOptionsDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: DialogCommon.insetPadding,
      shape: DialogCommon.shape,
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text(title, style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Buttons =
            Row(
              children: [
                Spacer(),

                // = Button :: Close =
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Zavřít"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
