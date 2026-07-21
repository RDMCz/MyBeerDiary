import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/color.dart";
import "package:my_beer_diary/logic/decimal_input_formatter.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/brewery_input.dart";
import "package:my_beer_diary/widget/checkbox.dart";
import "package:my_beer_diary/widget/color_picker.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerAddEditDialog extends StatefulWidget {
  final Beer? beer;

  const BeerAddEditDialog({super.key, this.beer});

  @override
  State<BeerAddEditDialog> createState() => _BeerAddEditDialogState();
}

class _BeerAddEditDialogState extends State<BeerAddEditDialog> {
  String breweryNameStr = "";
  final beerDescTEC = TextEditingController();
  final epmTEC = TextEditingController();
  final abvTEC = TextEditingController();
  bool isAbvGuess = false;
  Color beerColor = beerColorGold;

  @override
  void initState() {
    super.initState();
    beerDescTEC.addListener(() => setState(() {}));
    epmTEC.addListener(() => setState(() {}));

    if (widget.beer != null) {
      breweryNameStr = widget.beer!.breweryName;
      beerDescTEC.text = widget.beer!.description;
      epmTEC.text = doubleToTextField(widget.beer!.epm);
      abvTEC.text = doubleToTextField(widget.beer!.abv);
      beerColor = hexStringToColor(widget.beer!.color);
    }
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
    final isEdit = widget.beer != null;
    final headerActionText = isEdit ? "Upravit" : "Nové";
    final buttonActionText = isEdit ? "Potvrdit" : "OK";

    final iconColorEnabled = Theme.of(context).colorScheme.inverseSurface;
    final iconColorDisabled = Theme.of(context).colorScheme.secondary;

    // Get ABV from EPM if checkbox checked
    if (isAbvGuess) {
      abvTEC.text = epmToAbvDialog(epmTEC.text);
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text(
              "$headerActionText pivo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(height: DialogCommon.headerMarginBottom),
            //Text("${widget.beer}"),
            // = Form body =
            // - breweryName
            BreweryInput(
              initialValue: breweryNameStr,
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
                // ⇝
                SvgIcon(
                  icon: SvgIcons.leadsto,
                  color: isAbvGuess ? iconColorEnabled : iconColorDisabled,
                  size: 36,
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
              padding: EdgeInsets.all(0),
              value: isAbvGuess,
              onChanged: (bool newValue) {
                setState(() {
                  isAbvGuess = newValue;
                });
              },
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            // - color
            ColorPickerBeer(
              pickerColor: beerColor,
              onColorChanged: (Color color) {
                setState(() {
                  beerColor = color;
                });
              },
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
                  onPressed: !isValid
                      ? null
                      : !isEdit
                      // .: Adding new beer :.
                      ? () async {
                          await beerAdd(
                            Beer.normalize(
                              Beer(
                                breweryName: breweryNameTextTrim,
                                description: beerDescTextTrim,
                                epm: textFieldToDouble(epmTEC.text),
                                abv: textFieldToDouble(abvTEC.text),
                                color: colorToHexString(beerColor),
                              ),
                            ),
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      // .: Editing existing beer :.
                      : () async {
                          final isBreweryNameChange =
                              widget.beer!.breweryName != breweryNameTextTrim;

                          final isBeerDescChange =
                              widget.beer!.description != beerDescTextTrim;

                          final epm = textFieldToDouble(epmTEC.text);
                          final isEpmChange = widget.beer!.epm != epm;

                          final abv = textFieldToDouble(abvTEC.text);
                          final isAbvChange = widget.beer!.abv != abv;

                          final color = colorToHexString(beerColor);
                          final isColorChange = widget.beer!.color != color;

                          if (!isBreweryNameChange &&
                              !isBeerDescChange &&
                              !isEpmChange &&
                              !isAbvChange &&
                              !isColorChange) {
                            // No changes
                            Navigator.of(context).pop(false);
                          } else {
                            // Write changes to DB
                            await beerUpdate(
                              widget.beer!.copyWith(
                                breweryName: () => breweryNameTextTrim,
                                description: () => beerDescTextTrim,
                                epm: () => epm,
                                abv: () => abv,
                                color: () => color,
                              ),
                            );
                            // Close the dialog
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
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
