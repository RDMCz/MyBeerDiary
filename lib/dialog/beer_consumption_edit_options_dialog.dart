import "package:flutter/material.dart";

enum EditSummaryAction { applyOne, applyAll, cancel }

class BeerConsumptionEditOptionsDialog extends StatelessWidget {
  final String editSummary;
  final bool isOneoff;

  const BeerConsumptionEditOptionsDialog({
    super.key,
    required this.editSummary,
    required this.isOneoff,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return SimpleDialog(
      title: Text("Souhrn změn"),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(editSummary),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(EditSummaryAction.applyOne);
          },
          child: RichText(
            text: TextSpan(
              style: textStyle,
              children: [
                WidgetSpan(
                  child: Icon(Icons.crop_portrait_sharp),
                  alignment: PlaceholderAlignment.middle,
                ),
                TextSpan(text: "  Provést změny pro tento záznam"),
              ],
            ),
          ),
        ),
        if (!isOneoff)
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(EditSummaryAction.applyAll);
            },
            child: RichText(
              text: TextSpan(
                style: textStyle,
                children: [
                  WidgetSpan(
                    child: Icon(Icons.copy_sharp),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(
                    text:
                        "  Provést změny pro všechny identické záznamy této události",
                  ),
                ],
              ),
            ),
          ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(EditSummaryAction.cancel);
          },
          child: RichText(
            text: TextSpan(
              style: textStyle,
              children: [
                WidgetSpan(
                  child: Icon(Icons.close),
                  alignment: PlaceholderAlignment.middle,
                ),
                TextSpan(text: "  Zrušit"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
