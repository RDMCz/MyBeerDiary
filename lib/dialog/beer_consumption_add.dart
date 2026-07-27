import "dart:ui";
import "package:escape_parent_padding/escapable_padding.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/beer_size.dart";
import "package:my_beer_diary/logic/color.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/beer_card_mini.dart";
import "package:my_beer_diary/widget/beer_card_mini_new.dart";
import "package:my_beer_diary/widget/beer_form.dart";
import "package:my_beer_diary/widget/brewery_input.dart";
import "package:my_beer_diary/widget/checkbox.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

const _initialCustomBeerSizeValue = 0.4;

enum BeerSize { small, large, custom }

class BeerConsumptionAddDialog extends StatefulWidget {
  final List<Beer> beers;

  const BeerConsumptionAddDialog({super.key, required this.beers});

  @override
  State<BeerConsumptionAddDialog> createState() =>
      _BeerConsumptionAddDialogState();
}

class _BeerConsumptionAddDialogState extends State<BeerConsumptionAddDialog> {
  static const _outlineCardPadding = EdgeInsets.symmetric(
    horizontal: 11,
    vertical: 13,
  );

  String breweryNameStr = "";
  final beerDescTEC = TextEditingController();
  final epmTEC = TextEditingController();
  final abvTEC = TextEditingController();
  final priceTEC = TextEditingController();
  Color beerColor = beerColorGold;

  BeerSize beerSizeSelected = BeerSize.large;
  double customBeerSizeValue = _initialCustomBeerSizeValue;
  String customBeerSizeName = doubleToBeerSizeStr(_initialCustomBeerSizeValue);

  Beer? selectedBeer;

  @override
  void dispose() {
    beerDescTEC.dispose();
    epmTEC.dispose();
    abvTEC.dispose();
    priceTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    "Další pivo",
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
              BreweryInput(
                initialValue: breweryNameStr,
                onTextChanged: (value) {
                  setState(() {
                    breweryNameStr = value;
                  });
                },
              ),
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
                        breweryNameStr: breweryNameStr,
                        isSelected: selectedBeer == null,
                        onTap: () {
                          setState(() {
                            selectedBeer = null;
                            //breweryNameStr = ""; // Not desired
                            beerDescTEC.text = "";
                            epmTEC.text = "";
                            abvTEC.text = "";
                            beerColor = beerColorGold;
                          });
                        },
                      ),

                      // - Beer suggestion cards -
                      if (breweryNameStr.length >= 2)
                        for (final beer in widget.beers.where(
                          (e) => e.breweryName.toLowerCase().contains(
                            breweryNameStr.toLowerCase(),
                          ),
                        ))
                          BeerCardMini(
                            beer: beer,
                            isSelected:
                                selectedBeer != null &&
                                selectedBeer!.id == beer.id,
                            onTap: () {
                              setState(() {
                                selectedBeer = beer;
                                breweryNameStr = beer.breweryName;
                                beerDescTEC.text = beer.description;
                                epmTEC.text = doubleToTextField(beer.epm);
                                abvTEC.text = doubleToTextField(beer.abv);
                                beerColor = hexStringToColor(beer.color);
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
                    beerDescTEC: beerDescTEC,
                    epmTEC: epmTEC,
                    abvTEC: abvTEC,
                    initialColor: beerColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        beerColor = color;
                      });
                    },
                    //initialIsAbvGuess: true,
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
                      label: "Čepované",
                      padding: .all(0),
                      value: true,
                      onChanged: (_) {},
                    ),
                  ),
                  Spacer(),
                  // = Button to add beer consumption =
                  FloatingActionButton.extended(
                    label: Text("Přidat"),
                    icon: Icon(Icons.add),
                    onPressed: () {},
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
