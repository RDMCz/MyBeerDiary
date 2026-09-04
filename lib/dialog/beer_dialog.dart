// Dialog to add or edit beers in the database

import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/color.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/form/beer_form.dart";
import "package:my_beer_diary/widget/form/brewery_input.dart";

class BeerDialog extends StatefulWidget {
  final Beer? beer;

  const BeerDialog({super.key, this.beer});

  @override
  State<BeerDialog> createState() => _BeerDialogState();
}

class _BeerDialogState extends State<BeerDialog> {
  final breweryTEC = TextEditingController();
  final beerDescTEC = TextEditingController();
  final epmTEC = TextEditingController();
  final abvTEC = TextEditingController();
  Color beerColor = beerColorGold;
  bool isAbvGuess = false;

  @override
  void initState() {
    super.initState();
    breweryTEC.addListener(() => setState(() {}));
    beerDescTEC.addListener(() => setState(() {}));
    epmTEC.addListener(() => setState(() {}));

    if (widget.beer != null) {
      breweryTEC.text = widget.beer!.breweryName;
      beerDescTEC.text = widget.beer!.description;
      epmTEC.text = doubleToTextField(widget.beer!.epm);
      abvTEC.text = doubleToTextField(widget.beer!.abv);
      beerColor = hexStringToColor(widget.beer!.color);
    }
  }

  @override
  void dispose() {
    breweryTEC.dispose();
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

    final breweryNameTextTrim = breweryTEC.text.trim();
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

            // = Form body =
            BreweryInput(textEditController: breweryTEC),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            BeerForm(
              isEnabled: true,
              beerDescTEC: beerDescTEC,
              epmTEC: epmTEC,
              abvTEC: abvTEC,
              beerColor: beerColor,
              onColorChanged: (Color color) {
                setState(() {
                  beerColor = color;
                });
              },
              isAbvGuess: isAbvGuess,
              onIsAbvGuessChanged: (bool value) {
                setState(() {
                  isAbvGuess = value;
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
                            Beer(
                              breweryName: breweryNameTextTrim,
                              description: beerDescTextTrim,
                              epm: Beer.epmOrDefault(epmTEC.text),
                              abv: Beer.abvOrDefault(abvTEC.text),
                              color: colorToHexString(beerColor),
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

                          final epm = Beer.epmOrDefault(epmTEC.text);
                          final isEpmChange = widget.beer!.epm != epm;

                          final abv = Beer.abvOrDefault(abvTEC.text);
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
