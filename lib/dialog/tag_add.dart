import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/model/tag.dart";

class TagAddDialog extends StatefulWidget {
  final bool isEdit;
  
  const TagAddDialog({super.key, required this.isEdit});

  @override
  State<TagAddDialog> createState() => _TagAddDialogState();
}

class _TagAddDialogState extends State<TagAddDialog> {
  final textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditController.addListener(() => setState(() {}));
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
            Text("Nový tag", style: DialogCommon.headerStyle),
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
                      : () {
                          tagAdd(Tag(name: textEditController.text.trim()));
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
