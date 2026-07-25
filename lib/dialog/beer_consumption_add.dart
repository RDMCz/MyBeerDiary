import "dart:ui";

import "package:escape_parent_padding/escapable_padding.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/beer_card_mini.dart";
import "package:my_beer_diary/widget/brewery_input.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

enum BeerSize { small, large, custom }

class BeerConsumptionAddDialog extends StatefulWidget {
  final List<Beer> beers;

  const BeerConsumptionAddDialog({super.key, required this.beers});

  @override
  State<BeerConsumptionAddDialog> createState() =>
      _BeerConsumptionAddDialogState();
}

class _BeerConsumptionAddDialogState extends State<BeerConsumptionAddDialog> {
  String breweryNameStr = "";
  final beerDescTEC = TextEditingController();
  BeerSize beerSizeSelected = BeerSize.large;

  @override
  void dispose() {
    beerDescTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          children: [
            // = Header =
            Row(
              children: [
                Text(
                  "Další pivo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
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
              onTextChanged: (value) {
                setState(() {
                  breweryNameStr = value;
                });
              },
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Beer suggestions horizontal scroll =
            EscapablePadding.lite(
              height: 95,
              child: ScrollConfiguration(
                behavior: MaterialScrollBehavior().copyWith(
                  dragDevices: {...PointerDeviceKind.values},
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final beer in widget.beers.where(
                      (e) => e.breweryName.toLowerCase().contains(
                        breweryNameStr.toLowerCase(),
                      ),
                    ))
                      BeerCardMini(beer: beer),
                  ],
                ),
              ),
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Rest of the beer form =
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
                  label: Text("Čtyřka"),
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
          ],
        ),
      ),
    );
  }
}
