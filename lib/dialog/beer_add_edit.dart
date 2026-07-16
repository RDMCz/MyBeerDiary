import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/decimal_input_formatter.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/brewery_input.dart";
import "package:my_beer_diary/widget/checkbox.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerAddEditDialog extends StatefulWidget {
  const BeerAddEditDialog({super.key});

  @override
  State<BeerAddEditDialog> createState() => _BeerAddEditDialogState();
}

class _BeerAddEditDialogState extends State<BeerAddEditDialog> {
  String breweryNameStr = "";
  final beerDescTEC = TextEditingController();
  final epmTEC = TextEditingController();
  final abvTEC = TextEditingController();
  bool isAbvGuess = false;

  @override
  void initState() {
    super.initState();
    beerDescTEC.addListener(() => setState(() {}));
    epmTEC.addListener(() => setState(() {}));
  }

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

    // Get ABV from EPM if checkbox checked
    if (isAbvGuess) {
      abvTEC.text = epmToAbvTextField(epmTEC.text);
    }

    final breweryNameTextTrim = breweryNameStr.trim();
    final beerDescTextTrim = beerDescTEC.text.trim();
    final isValid =
        breweryNameTextTrim.isNotEmpty || beerDescTextTrim.isNotEmpty;

    return Dialog(
      insetPadding: EdgeInsets.all(16.0),
      shape: DialogCommon.shape,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text(
              "Přidat pivo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            // - breweryName
            BreweryInput(
              onTextChanged: (value) {
                setState(() {
                  breweryNameStr = value;
                });
              },
            ),
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
                    inputFormatters: [DecimalInputFormatter()],
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
                    inputFormatters: [DecimalInputFormatter()],
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
                TextButton(
                  onPressed: !isValid
                      ? null
                      : () async {
                          await beerAdd(
                            Beer.normalize(
                              Beer(
                                breweryName: breweryNameStr,
                                description: beerDescTextTrim,
                                epm: double.tryParse(epmTEC.text) ?? 0,
                                abv: double.tryParse(abvTEC.text) ?? 0,
                                color: "f5ddb1",
                              ),
                            ),
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
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
