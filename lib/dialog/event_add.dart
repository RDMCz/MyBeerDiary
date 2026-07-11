import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";

class EventAddDialog extends StatefulWidget {
  const EventAddDialog({super.key});

  @override
  State<EventAddDialog> createState() => _EventAddDialogState();
}

class _EventAddDialogState extends State<EventAddDialog> {
  final textEditController = TextEditingController();

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

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
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název události",
              ),
              controller: textEditController,
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

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
                SizedBox(width: DialogCommon.buttonSpace),

                // = Button :: Confirm =
                TextButton(
                  onPressed: () {
                    eventAdd(
                      Event(
                        name: textEditController.text,
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
