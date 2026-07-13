import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/model/event.dart";

class EventEditDialog extends StatefulWidget {
  final Event event;

  const EventEditDialog({super.key, required this.event});

  @override
  State<EventEditDialog> createState() => _EventEditDialogState();
}

class _EventEditDialogState extends State<EventEditDialog> {
  late final TextEditingController textEditController;

  @override
  void initState() {
    super.initState();
    textEditController = TextEditingController(text: widget.event.name);
  }

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
            Text("Upravit událost", style: DialogCommon.headerStyle),
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
              children: [
                // = Button :: Delete =
                TextButton(
                  onPressed: () async {
                    if (widget.event.id == null) {
                      return;
                    }

                    final tag = widget.event.tagId != null
                        ? "#${widget.event.tagId} "
                        : "";

                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Smazat událost"),
                        content: Text(
                          "Opravdu si přejete smazat „$tag${widget.event.name}“?",
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
                      await eventDelete(widget.event.id!);
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
                SizedBox(width: DialogCommon.buttonSpace),

                // = Button :: Confirm =
                TextButton(
                  onPressed: () async {
                    if (widget.event.id == null) {
                      return;
                    }

                    final newName = textEditController.text;
                    if (newName != widget.event.name) {
                      await eventUpdate(
                        widget.event.copyWith(name: () => newName),
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    } else {
                      // No changes
                      Navigator.of(context).pop(false);
                    }
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
