import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/model/event.dart";

class EventEditDialog extends StatelessWidget {
  final Event event;

  const EventEditDialog({super.key, required this.event});

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
            Text("Upravit událost", style: DialogCommon.headerStyle),
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
              children: [
                // = Button :: Delete =
                TextButton(
                  onPressed: () async {
                    if (event.id == null) {
                      return;
                    }

                    final tag = event.tagName != null
                        ? "#${event.tagName} "
                        : "";

                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Smazat událost"),
                        content: Text(
                          "Opravdu si přejete smazat „$tag${event.name}“?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Zrušit"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Smazat"),
                          ),
                        ],
                      ),
                    );

                    if (result ?? false) {
                      eventDelete(event.id!);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                  child: Text("Smazat"),
                ),
                Spacer(),

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
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Potvrdit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
