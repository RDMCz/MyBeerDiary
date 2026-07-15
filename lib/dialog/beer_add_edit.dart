import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/widget/brewery_input.dart";
import "package:my_beer_diary/widget/checkbox.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerAddEditDialog extends StatefulWidget {
  const BeerAddEditDialog({super.key});

  @override
  State<BeerAddEditDialog> createState() => _BeerAddEditDialogState();
}

class _BeerAddEditDialogState extends State<BeerAddEditDialog> {
  String breweryName = "";
  final beerDescTEC = TextEditingController();
  final epmTEC = TextEditingController();
  final abvTEC = TextEditingController();
  bool isAbvGuess = false;

  @override
  void dispose() {
    beerDescTEC.dispose();
    epmTEC.dispose();
    abvTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconColorEnabled = Theme.of(context).colorScheme.inverseSurface;
    final iconColorDisabled = Theme.of(context).colorScheme.secondary;

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
            Text("Přidat pivo", style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            // - breweryName
            BreweryInput(onTextChanged: (_) {}),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            // - description
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název/styl/popis piva",
                suffixIcon: SuffixSvgIcon(icon: SvgIcons.beer),
              ),
              controller: beerDescTEC,
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            Row(
              children: [
                // - epm
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Stupňovitost",
                      suffixIcon: SuffixSvgIcon(icon: SvgIcons.epm),
                    ),
                    controller: epmTEC,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -3),
                  child: Text(
                    "⇝",
                    style: TextStyle(
                      fontSize: 40,
                      height: 1,
                      color: isAbvGuess ? iconColorEnabled : iconColorDisabled,
                    ),
                  ),
                ),
                // - abv
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Alkohol",
                      suffixIcon: SuffixSvgIcon(
                        icon: SvgIcons.abv,
                        color: !isAbvGuess
                            ? iconColorEnabled
                            : iconColorDisabled,
                      ),
                    ),
                    controller: abvTEC,
                    enabled: !isAbvGuess,
                  ),
                ),
              ],
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            LabeledCheckbox(
              label: "Odhadnout procenta alkoholu ze stupňovistosti",
              padding: .all(0),
              value: isAbvGuess,
              onChanged: (bool newValue) {
                setState(() {
                  isAbvGuess = newValue;
                });
              },
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            // - color
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
                TextButton(onPressed: () {}, child: Text("OK")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
