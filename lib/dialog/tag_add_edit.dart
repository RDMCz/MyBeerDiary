import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/model/tag.dart";

class TagAddEditDialog extends StatefulWidget {
  final Tag? tag;

  const TagAddEditDialog({super.key, this.tag});

  @override
  State<TagAddEditDialog> createState() => _TagAddEditDialogState();
}

class _TagAddEditDialogState extends State<TagAddEditDialog> {
  late final TextEditingController textEditController;

  @override
  void initState() {
    super.initState();
    textEditController = widget.tag != null
        ? TextEditingController(text: widget.tag!.name)
        : TextEditingController();
    textEditController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tag != null;
    final headerActionText = isEdit ? "Upravit" : "Nový";
    final buttonActionText = isEdit ? "Potvrdit" : "OK";

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
            Text("$headerActionText tag", style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název tagu",
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
                  onPressed: textEditController.text.trim().isEmpty
                      ? null
                      : !isEdit
                      ? () {
                          tagAdd(Tag(name: textEditController.text.trim()));
                          Navigator.of(context).pop(true);
                        }
                      : () {
                          final newName = textEditController.text.trim();
                          if (newName != widget.tag!.name) {
                            tagUpdate(
                              widget.tag!.copyWith(name: () => newName),
                            );
                            Navigator.of(context).pop(true);
                          } else {
                            // No changes
                            Navigator.of(context).pop(false);
                          }
                        },
                  child: Text(buttonActionText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
