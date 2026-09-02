import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/event_stats.dart";
import "package:my_beer_diary/widget/alcohol_chart.dart";
import "package:my_beer_diary/widget/card/beer_consumption_card.dart";
import "package:my_beer_diary/widget/card/event_card.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:my_beer_diary/widget/text_divider.dart";

class EventStatsScreen extends StatelessWidget {
  final Event event;
  final EventStats stats;
  final Map<int, Beer> beers;

  const EventStatsScreen({
    super.key,
    required this.event,
    required this.stats,
    required this.beers,
  });

  @override
  Widget build(BuildContext context) {
    final averageBeer = Beer(
      id: -1,
      breweryName: stats.topBreweryNames.first.key,
      description: stats.topDescriptions.first.key,
      epm: stats.averageEPM,
      abv: stats.averageABV,
      color: stats.topColors.first.key,
    );

    final averageBeerConsumption = BeerConsumption(
      timestamp: 0,
      beerId: -1,
      litres: stats.totalLitres / event.totalBeers,
      price: event.totalCost ~/ event.totalBeers,
      isDraft: stats.topIsDrafts.first.key,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Statistika události")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // = Event card =
            Padding(
              padding: CardListCommon.horizontalPaddingOnly,
              child: EventCard(event: event, isInteractable: false),
            ),
            SizedBox(height: 6.6),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // = Max permille =
                ListTile(
                  leading: SvgIcon(icon: SvgIcons.permille),
                  title: Text(
                    "Max promile: ${stats.maxPermille.toStringAsFixed(2)} ‰",
                    style: boldTextStyle,
                  ),
                ),
                Divider(height: 0),
                // = Sober in =
                ListTile(
                  leading: SvgIcon(icon: SvgIcons.sober),
                  title: Text(
                    "Vystřízlivění v ${secondsToDateTimeString(stats.soberTimestamp)}",
                    style: boldTextStyle,
                  ),
                ),
                Divider(height: 0),
                // = Total litres =
                ListTile(
                  leading: SvgIcon(icon: SvgIcons.beerSizeCustom),
                  title: Text(
                    "Celkem vypito ${stats.totalLitres.toStringAsFixed(2)} litrů",
                    style: boldTextStyle,
                  ),
                ),
                Divider(height: 0),
                // = Litres per hour =
                ListTile(
                  leading: Icon(Icons.speed),
                  title: Text(
                    "Průměrně vypito ${(stats.totalLitres / stats.durationHours).toStringAsFixed(2)} litrů za hodinu",
                    style: boldTextStyle,
                  ),
                ),
                Divider(height: 0),
              ],
            ),
            SizedBox(height: 6.6),
            // = Average beer card =
            Padding(
              padding: CardListCommon.horizontalPaddingOnly,
              child: BeerConsumptionCard(
                beer: averageBeer,
                beerConsumption: averageBeerConsumption,
                isStats: true,
              ),
            ),
            SizedBox(height: 20),
            // = Permille graph =
            SizedBox(
              height: 300,
              child: AlcoholChart(chartPoints: stats.chartPoints),
            ),
            SizedBox(height: 20),
            // = Top brewery names =
            TextDivider(text: "TOP PIVOVARY"),
            DefaultTextStyle.merge(
              style: TextStyle(fontSize: 16.0),
              child: Padding(
                padding: CardListCommon.horizontalPaddingOnly,
                child: Column(
                  children: [
                    for (final (index, breweryNamePair)
                        in stats.topBreweryNames.take(5).indexed)
                      Row(
                        children: [
                          Text("#${index + 1}  ${breweryNamePair.key}"),
                          Spacer(),
                          Text("${breweryNamePair.value} x"),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            // = Top beers =
            TextDivider(text: "TOP PIVA"),
            DefaultTextStyle.merge(
              style: TextStyle(fontSize: 16.0),
              child: Padding(
                padding: CardListCommon.horizontalPaddingOnly,
                child: Column(
                  children: [
                    for (final (index, beerPair)
                        in stats.topBeerIds.take(5).indexed)
                      Row(
                        children: [
                          Text(
                            "#${index + 1}  ${(beers[beerPair.key] ?? Beer.unknownBeer).toDisplayString()}",
                          ),
                          Spacer(),
                          Text("${beerPair.value} x"),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
