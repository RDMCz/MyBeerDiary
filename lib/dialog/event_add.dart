import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";

class EventAddDialog extends StatelessWidget {
  const EventAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: DialogCommon.insetPadding,
      shape: DialogCommon.shape,
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text("Nová událost", style: DialogCommon.headerStyle),
            SizedBox(height: 16),

            // = Form body =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název události",
              ),
            ),
            SizedBox(height: 12),

            // = Buttons =
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // = Button :: Cancel =
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Zrušit"),
                ),
                SizedBox(width: 8),

                // = Button :: Confirm =
                TextButton(
                  onPressed: () {
                    eventAdd(
                      Event(
                        name: "ABC",
                        timestamp: secondsSinceEpoch(),
                        totalBeers: 0,
                        totalCost: 0,
                      ),
                    );
                    Navigator.of(context).pop(true);
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
