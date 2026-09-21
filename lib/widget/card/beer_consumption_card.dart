// Shows one beer consumption, used in event screen, oneoffs list, stats (average beer)

import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_consumption_options_dialog.dart";
import "package:my_beer_diary/logic/beer_size.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/svg_icon_with_text.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class BeerConsumptionCard extends StatelessWidget {
  final Beer beer;
  final BeerConsumption beerConsumption;

  const BeerConsumptionCard({
    super.key,
    required this.beer,
    required this.beerConsumption,
  });

  @override
  Widget build(BuildContext context) {
    const detailsTextStyle = TextStyle(fontSize: 15.5);

    final BeerSize beerSize = doubleToBeerSize(beerConsumption.litres);
    final String beerSizeStr = doubleToBeerSizeStr(beerConsumption.litres);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        // Show dialog with options on long press
        onLongPress: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => BeerConsumptionOptionsDialog(
              beer: beer,
              beerConsumption: beerConsumption,
            ),
          );
          if (result ?? false) {
            if (context.mounted) {
              await context.read<BeerConsumptionNotifier>().refresh();
            }
            if (context.mounted) {
              await context.read<EventNotifier>().refresh();
            }
          }
        },
        child: Padding(
          padding: CardCommon.normalPadding,
          child: Column(
            children: [
              // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
              Row(
                children: [
                  // Date, brewery name, beer description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        secondsToDateTimeString(beerConsumption.timestamp),
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        beer.breweryName,
                        style: TextStyle(
                          fontSize: 20.25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(beer.description, style: TextStyle(fontSize: 17.5)),
                    ],
                  ),
                  Spacer(),
                  // Big beer icon
                  SizedBox(
                    height: 70,
                    child: SvgCardIcon(
                      icon: beerSizeToCardIcon(
                        beerSize,
                        beerConsumption.isDraft,
                      ),
                      color: beer.color,
                    ),
                  ),
                ],
              ),
              // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
              Divider(),
              // Litres and EPM
              Row(
                children: [
                  SvgIconWithText(
                    icon: beerSizeToIcon(beerSize),
                    text: beerSizeStr,
                    textStyle: detailsTextStyle,
                    iconSize: 20,
                  ),
                  Spacer(),
                  Text(
                    "${beer.epm.toStringAsFixed(1)}°",
                    style: detailsTextStyle,
                  ),
                ],
              ),
              // Price and ABV
              Row(
                children: [
                  SvgIconWithText(
                    icon: SvgIcons.money,
                    text: "${beerConsumption.price} Kč",
                    textStyle: detailsTextStyle,
                    iconSize: 20,
                  ),
                  Spacer(),
                  Text(
                    "${beer.abv.toStringAsFixed(1)} %",
                    style: detailsTextStyle,
                  ),
                ],
              ),
              // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
            ],
          ),
        ),
      ),
    );
  }
}
