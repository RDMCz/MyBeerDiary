import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/color.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/color_picker.dart";

class TagAddEditDialog extends StatefulWidget {
  final Tag? tag;

  const TagAddEditDialog({super.key, this.tag});

  @override
  State<TagAddEditDialog> createState() => _TagAddEditDialogState();
}

class _TagAddEditDialogState extends State<TagAddEditDialog> {
  final textEditController = TextEditingController();

  double hueSliderValue = 0.0;
  Color tagColor = hueToTagColor(0.0);

  void updateColorAndSlider(double value) {
    setState(() {
      hueSliderValue = value;
      tagColor = hueToTagColor(hueSliderValue);
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.tag != null) {
      textEditController.text = widget.tag!.name;
      updateColorAndSlider(colorHue(hexStringToColor(widget.tag!.color)));
    }

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

            // = Color slider =
            Row(
              children: [
                ColorContainer(
                  isEnabled: true,
                  color: tagColor,
                  isCurrentColor: false,
                ),
                Expanded(
                  child: Slider(
                    value: hueSliderValue,
                    onChanged: (double value) => updateColorAndSlider(value),
                    min: 0.0,
                    max: 360.0,
                  ),
                ),
              ],
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
                      ? () async {
                          await tagAdd(
                            Tag(
                              name: textEditController.text.trim(),
                              color: colorToHexString(tagColor),
                            ),
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      : () async {
                          final newName = textEditController.text.trim();
                          final newColor = colorToHexString(tagColor);

                          if (newName != widget.tag!.name ||
                              newColor != widget.tag!.color) {
                            await tagUpdate(
                              widget.tag!.copyWith(
                                name: () => newName,
                                color: () => newColor,
                              ),
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
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
