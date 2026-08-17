import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_consumption_options_dialog.dart";
import "package:my_beer_diary/logic/beer_size.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class BeerConsumptionCard extends StatelessWidget {
  final int? eventId;
  final Beer beer;
  final BeerConsumption beerConsumption;

  const BeerConsumptionCard({
    super.key,
    required this.eventId,
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
        child: Padding(
          padding: CardCommon.normalPadding,
          child: Column(
            children: [
              // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
              Row(
                children: [
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
              Row(
                children: [
                  SvgIcon(icon: beerSizeToIcon(beerSize), size: 20),
                  Text(" $beerSizeStr", style: detailsTextStyle),
                  Spacer(),
                  Text("${beer.epm}°", style: detailsTextStyle),
                ],
              ),
              Row(
                children: [
                  SvgIcon(icon: SvgIcons.money, size: 20),
                  Text(" ${beerConsumption.price} Kč", style: detailsTextStyle),
                  Spacer(),
                  Text("${beer.abv} %", style: detailsTextStyle),
                ],
              ),
              // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
            ],
          ),
        ),
        onLongPress: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => BeerConsumptionOptionsDialog(
              eventId: eventId,
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
      ),
    );
  }
}
