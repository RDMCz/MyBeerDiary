// Fullscreen dialog for adding/editing beer consumption, either Event or Oneoff

import "dart:ui";
import "package:escape_parent_padding/escapable_padding.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/dialog/beer_consumption_edit_options_dialog.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/beer_size.dart";
import "package:my_beer_diary/logic/color.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/card/beer_card_mini.dart";
import "package:my_beer_diary/widget/card/beer_card_mini_new.dart";
import "package:my_beer_diary/widget/form/beer_form.dart";
import "package:my_beer_diary/widget/form/brewery_input.dart";
import "package:my_beer_diary/widget/form/checkbox.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class BeerConsumptionDialog extends StatefulWidget {
  /// Links this dialog to a specific Event, use null for Oneoffs
  final int? eventId;

  /// Used for editing variant of this dialog, beer will be preselected and fields filled
  final Beer? beer;

  /// Used for editing variant of this dialog, fields will be filled
  final BeerConsumption? beerConsumption;

  const BeerConsumptionDialog({
    super.key,
    required this.eventId,
    required this.beer,
    required this.beerConsumption,
  });

  @override
  State<BeerConsumptionDialog> createState() => _BeerConsumptionDialogState();
}

class _BeerConsumptionDialogState extends State<BeerConsumptionDialog> {
  // Outline card serves as a "group box"
  static const _outlineCardPadding = EdgeInsets.symmetric(
    horizontal: 11,
    vertical: 13,
  );

  final breweryTEC = TextEditingController();
  String breweryNameStrPrev = ""; // To check for text changes

  final beerDescTEC = TextEditingController();
  final epmTEC = TextEditingController();
  final abvTEC = TextEditingController();
  final priceTEC = TextEditingController();
  Color beerColor = beerColorGold;
  bool isAbvGuess = false;

  static const _initialCustomBeerSizeValue = 0.4;
  BeerSize beerSizeSelected = BeerSize.large;
  double customBeerSizeValue = _initialCustomBeerSizeValue;
  String customBeerSizeName = doubleToBeerSizeStr(_initialCustomBeerSizeValue);

  bool isDraft = true;

  Beer? selectedBeer;

  void clearBeerForm() {
    setState(() {
      selectedBeer = null;
      beerDescTEC.text = "";
      epmTEC.text = "";
      abvTEC.text = "";
      beerColor = beerColorGold;
    });
  }

  @override
  void initState() {
    super.initState();

    breweryTEC.addListener(() {
      final breweryNameStr = breweryTEC.text;
      // The listener gets also called on focus se we need to check if the text was actually changed
      if (breweryNameStrPrev != breweryNameStr) {
        breweryNameStrPrev = breweryNameStr;

        // Update suggestions cards
        setState(() {});

        if (selectedBeer != null) {
          // If user selects a beer and then starts editing breweryName field, selected card will probably disappear, so we unselect it
          clearBeerForm();
        }
      }
    });

    beerDescTEC.addListener(() => setState(() {}));

    // Update ABV if checkbox checked
    epmTEC.addListener(() => setState(() {}));

    // Fill fields if editing existing beerConsumption
    if (widget.beer != null && widget.beerConsumption != null) {
      final b = widget.beer!;
      breweryTEC.text = b.breweryName;
      beerDescTEC.text = b.description;
      epmTEC.text = doubleToTextField(b.epm);
      abvTEC.text = doubleToTextField(b.abv);
      beerColor = hexStringToColor(b.color);

      selectedBeer = b;

      final bc = widget.beerConsumption!;
      priceTEC.text = bc.price.toString();
      isDraft = bc.isDraft;

      beerSizeSelected = doubleToBeerSize(bc.litres);
      if (beerSizeSelected == BeerSize.custom) {
        customBeerSizeValue = bc.litres;
        customBeerSizeName = doubleToBeerSizeStr(customBeerSizeValue);
      }
    }
  }

  @override
  void dispose() {
    breweryTEC.dispose();
    beerDescTEC.dispose();
    epmTEC.dispose();
    abvTEC.dispose();
    priceTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.beer != null && widget.beerConsumption != null;

    final breweryNameTextTrim = breweryTEC.text.trim();
    final beerDescTextTrim = beerDescTEC.text.trim();

    final isValid =
        breweryNameTextTrim.isNotEmpty || beerDescTextTrim.isNotEmpty;

    final beers = context.read<BeerNotifier>().itemList;

    return Dialog.fullscreen(
      child: SingleChildScrollView(
        child: Padding(
          padding: DialogCommon.contentPadding,
          child: Column(
            children: [
              // = Header =
              Row(
                children: [
                  Text(
                    isEdit ? "Upravit záznam vypití piva" : "Další pivo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                  Spacer(),
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: DialogCommon.headerMarginBottom),

              // = Brewery name input =
              BreweryInput(textEditController: breweryTEC),
              SizedBox(height: DialogCommon.bodyMarginBottom),

              // = Beer suggestions horizontal scroll =
              EscapablePadding.lite(
                height: 90,
                child: ScrollConfiguration(
                  behavior: MaterialScrollBehavior().copyWith(
                    dragDevices: {...PointerDeviceKind.values},
                  ),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      // - New beer card -
                      BeerCardMiniNew(
                        isSelected: selectedBeer == null,
                        onTap: clearBeerForm,
                      ),

                      // - Beer suggestion cards -
                      for (final beer in beers.where(
                        (e) => e.breweryName.toLowerCase().contains(
                          breweryNameTextTrim.toLowerCase(),
                        ),
                      ))
                        BeerCardMini(
                          beer: beer,
                          isSelected:
                              selectedBeer != null &&
                              selectedBeer!.id == beer.id,
                          onTap: () {
                            setState(() {
                              isAbvGuess = false;
                              breweryTEC.text = beer.breweryName;
                              beerDescTEC.text = beer.description;
                              epmTEC.text = doubleToTextField(beer.epm);
                              abvTEC.text = doubleToTextField(beer.abv);
                              beerColor = hexStringToColor(beer.color);

                              // Beer must be set after changing brewery name field otherwise it would be set to null by listener
                              selectedBeer = beer;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: DialogCommon.bodyMarginBottom),

              // = Rest of the beer form =
              Card.outlined(
                child: Padding(
                  padding: _outlineCardPadding,
                  child: BeerForm(
                    isEnabled: selectedBeer == null,
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
                ),
              ),
              SizedBox(height: DialogCommon.bodyMarginBottom),

              Card.outlined(
                child: Padding(
                  padding: _outlineCardPadding,
                  child: Column(
                    children: [
                      // = Choose beer size =
                      SegmentedButton(
                        segments: [
                          ButtonSegment(
                            value: BeerSize.small,
                            label: Text("Malé"),
                            icon: SvgIcon(icon: SvgIcons.beerSizeSmall),
                          ),
                          ButtonSegment(
                            value: BeerSize.large,
                            label: Text("Velké"),
                            icon: SvgIcon(icon: SvgIcons.beerSizeLarge),
                          ),
                          ButtonSegment(
                            value: BeerSize.custom,
                            label: Text(customBeerSizeName),
                            icon: SvgIcon(icon: SvgIcons.beerSizeCustom),
                          ),
                        ],
                        selected: {beerSizeSelected},
                        onSelectionChanged: (final newSelection) {
                          setState(() {
                            beerSizeSelected = newSelection.first;
                          });
                        },
                        expandedInsets: EdgeInsets.zero,
                        emptySelectionAllowed: false,
                        multiSelectionEnabled: false,
                        showSelectedIcon: false,
                      ),
                      Slider(
                        value: customBeerSizeValue,
                        onChanged: beerSizeSelected != BeerSize.custom
                            ? null
                            : (double value) {
                                setState(() {
                                  customBeerSizeValue = value;
                                  customBeerSizeName = doubleToBeerSizeStr(
                                    customBeerSizeValue,
                                  );
                                });
                              },
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                      ),

                      // = Price =
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Cena",
                          suffixIcon: SuffixSvgIcon(icon: SvgIcons.money),
                        ),
                        controller: priceTEC,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: DialogCommon.bodyMarginBottom),

              Row(
                children: [
                  // = Is draft checkbox =
                  Expanded(
                    child: LabeledCheckbox(
                      isEnabled: true,
                      label: "Čepované",
                      padding: EdgeInsets.all(0),
                      value: isDraft,
                      onChanged: (bool value) {
                        setState(() {
                          isDraft = value;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                  // = Button to add/edit beerConsumption =
                  FloatingActionButton.extended(
                    label: Text(isEdit ? "Potvrdit" : "Přidat"),
                    icon: Icon(isEdit ? Icons.check : Icons.add),
                    backgroundColor: isValid
                        ? appColorPrimaryContainer
                        : appColorDisabledFAB,
                    disabledElevation: 0,
                    onPressed: !isValid
                        ? null
                        : !isEdit
                        // ---  Add new beerConsumption  --- --- --- --- --- --- --- --- --- --- ---
                        ? () async {
                            // Resolve Beer
                            final beerId =
                                selectedBeer != null && selectedBeer!.id != null
                                // User has selected valid BeerCardMini => use that beer
                                ? selectedBeer!.id!
                                // User has selected BeerCardMiniNew => create new beer and use its ID
                                : await beerAdd(
                                    Beer(
                                      breweryName: breweryNameTextTrim,
                                      description: beerDescTextTrim,
                                      epm: Beer.epmOrDefault(epmTEC.text),
                                      abv: Beer.abvOrDefault(abvTEC.text),
                                      color: colorToHexString(beerColor),
                                    ),
                                  );

                            // Resolve litres
                            final litres = switch (beerSizeSelected) {
                              BeerSize.small => 0.3,
                              BeerSize.large => 0.5,
                              BeerSize.custom => customBeerSizeValue,
                            };

                            // Resolve price
                            final price = int.tryParse(priceTEC.text) ?? 0;

                            // Add beer consumption to DB
                            await beerConsumptionAdd(
                              BeerConsumption(
                                timestamp: secondsSinceEpoch(),
                                eventId: widget.eventId,
                                beerId: beerId,
                                litres: litres,
                                price: price,
                                isDraft: isDraft,
                              ),
                            );

                            // Update event stats (total beers and total price)
                            if (widget.eventId != null) {
                              eventUpdateTotals(
                                eventId: widget.eventId!,
                                totalBeersIncrease: 1,
                                totalCostIncrease: price,
                              );
                            }

                            // Close the dialog
                            if (context.mounted) {
                              if (selectedBeer == null) {
                                context.read<BeerNotifier>().refresh();
                              }
                              Navigator.of(context).pop(true);
                            }
                          }
                        // --- Edit existing beerConsumption --- --- --- --- --- --- --- --- --- ---
                        : () async {
                            // Firm: id, timestamp, eventId
                            // Can change: beerId, litres, price, isDraft

                            // BeerConsumption we are edititng
                            final bc = widget.beerConsumption!;
                            // Original beer of that BeerConsumption
                            final b = widget.beer!;
                            // Should never be null but check just in case
                            if (b.id == null ||
                                (selectedBeer != null &&
                                    selectedBeer!.id == null)) {
                              return;
                            }

                            // Resolve beer
                            final isBeerChange =
                                // [b] definitely isn't null so [selectedBeer] being null means change (we'll be adding new beer)
                                selectedBeer == null ||
                                // Different IDs => change
                                selectedBeer!.id! != b.id!;

                            int beerId = b.id!; // Valid if beer is not edited
                            bool doCreateNewBeer = false;

                            if (isBeerChange) {
                              if (selectedBeer != null) {
                                beerId = selectedBeer!.id!;
                              } else {
                                doCreateNewBeer = true;
                              }
                            }

                            // Resolve litres
                            final litres = switch (beerSizeSelected) {
                              BeerSize.small => 0.3,
                              BeerSize.large => 0.5,
                              BeerSize.custom => customBeerSizeValue,
                            };
                            final isLitresChange = litres != bc.litres;

                            // Resolve price
                            final price = int.tryParse(priceTEC.text) ?? 0;
                            final isPriceChange = price != bc.price;

                            // Resolve isDraft
                            final isIsDraftChange = isDraft != bc.isDraft;

                            // Apply changes
                            if (!isBeerChange &&
                                !isLitresChange &&
                                !isPriceChange &&
                                !isIsDraftChange) {
                              // No changes
                              if (context.mounted) {
                                Navigator.of(context).pop(false);
                              }
                            } else {
                              // Create summary of the beerConsumption changes
                              String editSummary = "";
                              if (isBeerChange) {
                                final newBeerStr = selectedBeer != null
                                    ? selectedBeer!.toDisplayString()
                                    : "Nové pivo";
                                editSummary +=
                                    "Pivo: ${b.toDisplayString()} → $newBeerStr\n";
                              }
                              if (isLitresChange) {
                                editSummary +=
                                    "Objem: ${bc.litres} L → $litres\n";
                              }
                              if (isPriceChange) {
                                editSummary +=
                                    "Cena: ${bc.price} Kč → $price Kč\n";
                              }
                              if (isIsDraftChange) {
                                editSummary +=
                                    "Čepované: ${bc.isDraft} → $isDraft\n";
                              }

                              // Show edit summary dialog
                              if (context.mounted) {
                                final result =
                                    await showDialog<EditSummaryAction>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          BeerConsumptionEditOptionsDialog(
                                            editSummary: editSummary,
                                            isOneoff: widget.eventId == null,
                                          ),
                                    ) ??
                                    EditSummaryAction.cancel;
                                switch (result) {
                                  case EditSummaryAction.applyOne:
                                    // New beer?
                                    if (doCreateNewBeer) {
                                      beerId = await beerAdd(
                                        Beer(
                                          breweryName: breweryNameTextTrim,
                                          description: beerDescTextTrim,
                                          epm: Beer.epmOrDefault(epmTEC.text),
                                          abv: Beer.abvOrDefault(abvTEC.text),
                                          color: colorToHexString(beerColor),
                                        ),
                                      );
                                    }
                                    // Edit beerConsumption in DB
                                    await beerConsumptionUpdate(
                                      bc.copyWith(
                                        beerId: () => beerId,
                                        litres: () => litres,
                                        price: () => price,
                                        isDraft: () => isDraft,
                                      ),
                                    );
                                    // Update totals
                                    if (widget.eventId != null &&
                                        isPriceChange) {
                                      eventUpdateTotals(
                                        eventId: widget.eventId!,
                                        totalBeersIncrease: 0,
                                        totalCostIncrease: -bc.price + price,
                                      );
                                    }
                                    // Close the dialog
                                    if (context.mounted) {
                                      if (isBeerChange) {
                                        context.read<BeerNotifier>().refresh();
                                      }
                                      Navigator.of(context).pop(true);
                                    }
                                    break;
                                  case EditSummaryAction.applyAll:
                                    // New beer?
                                    if (doCreateNewBeer) {
                                      beerId = await beerAdd(
                                        Beer(
                                          breweryName: breweryNameTextTrim,
                                          description: beerDescTextTrim,
                                          epm: Beer.epmOrDefault(epmTEC.text),
                                          abv: Beer.abvOrDefault(abvTEC.text),
                                          color: colorToHexString(beerColor),
                                        ),
                                      );
                                    }
                                    // Edit beerConsumptions in DB
                                    final nRows =
                                        await beerConsumptionUpdateIdentical(
                                          old: bc,
                                          newBeerId: beerId,
                                          newLitres: litres,
                                          newPrice: price,
                                          newIsDraft: isDraft,
                                        );
                                    // Update totals
                                    if (widget.eventId != null &&
                                        isPriceChange) {
                                      eventUpdateTotals(
                                        eventId: widget.eventId!,
                                        totalBeersIncrease: 0,
                                        totalCostIncrease:
                                            -(nRows * bc.price) +
                                            (nRows * price),
                                      );
                                    }
                                    // Close the dialog
                                    if (context.mounted) {
                                      if (isBeerChange) {
                                        context.read<BeerNotifier>().refresh();
                                      }
                                      Navigator.of(context).pop(true);
                                    }
                                    break;
                                  case EditSummaryAction.cancel:
                                    // Do nothing
                                    break;
                                }
                              }
                            }
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
