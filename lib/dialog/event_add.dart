import "package:flutter/material.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";

class EventAddDialog extends StatelessWidget {
  const EventAddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: .all(32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Padding(
        padding: .symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text(
              "Nová událost",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 16),

            // = Form body =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název události",
              ),
            ),
            SizedBox(height: 8),

            // = Buttons =
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // = Button :: Cancel =
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Zrušit"),
                ),
                const SizedBox(width: 8),

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
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
