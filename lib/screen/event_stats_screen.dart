import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/beer_size.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/event_stats.dart";
import "package:my_beer_diary/widget/chart/alcohol_chart.dart";
import "package:my_beer_diary/widget/card/event_card.dart";
import "package:my_beer_diary/widget/chart/chart_container.dart";
import "package:my_beer_diary/widget/svg_icon_with_text.dart";
import "package:my_beer_diary/widget/stat_leaderboard.dart";
import "package:my_beer_diary/widget/stat_list_tile.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

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
    const eventStatTextStyle = TextStyle(fontSize: 16.0);

    // Average beer stats
    final averageBeerSize = doubleToBeerSize(
      stats.totalLitres / event.totalBeers,
    );

    final averageLitresStr = (stats.totalLitres / event.totalBeers)
        .toStringAsFixed(2);

    final averagePriceStr = (event.totalCost ~/ event.totalBeers).toString();
    final averageEpmStr = stats.averageEPM.toStringAsFixed(2);
    final averageAbvStr = stats.averageABV.toStringAsFixed(2);
    final averageIsDraft = stats.topIsDrafts.first.key;
    final averageColor = stats.topColors.first.key;

    // Permille info row
    final maxPermilleStr =
        "Max promile: ${stats.maxPermille.toStringAsFixed(2)} ‰";
    final permilleStr = stats.currentPermille > 0
        ? "$maxPermilleStr, aktuálně: ${stats.currentPermille.toStringAsFixed(2)} ‰"
        : maxPermilleStr;

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
            // = Max permille =
            StatListTile(
              leading: SvgIcon(icon: SvgIcons.permille),
              text: permilleStr,
            ),
            // = Sober in =
            StatListTile(
              leading: SvgIcon(icon: SvgIcons.sober),
              text:
                  "Vystřízlivění v ${secondsToDateTimeString(stats.soberTimestamp)}",
            ),
            // = Total litres =
            StatListTile(
              leading: SvgIcon(icon: SvgIcons.beerSizeCustom),
              text:
                  "Celkem vypito ${stats.totalLitres.toStringAsFixed(2)} litrů",
            ),
            // = Litres per hour =
            StatListTile(
              leading: Icon(Icons.speed),
              text:
                  "Průměrně vypito ${(stats.totalLitres / stats.durationHours).toStringAsFixed(2)} litrů za hodinu",
            ),
            SizedBox(height: 6.6),
            // = Average beer card =
            Padding(
              padding: CardListCommon.horizontalPaddingOnly,
              child: Card(
                child: Padding(
                  padding: CardCommon.normalPadding,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Průměrné pivo"),
                          SizedBox(height: 6),
                          SvgIconWithText(
                            icon: beerSizeToIcon(averageBeerSize),
                            text: "$averageLitresStr L",
                            textStyle: eventStatTextStyle,
                            iconSize: 20,
                          ),
                          SvgIconWithText(
                            icon: SvgIcons.money,
                            text: "$averagePriceStr Kč",
                            textStyle: eventStatTextStyle,
                            iconSize: 20,
                          ),
                          SvgIconWithText(
                            icon: SvgIcons.epm,
                            text: "$averageEpmStr°",
                            textStyle: eventStatTextStyle,
                            iconSize: 20,
                          ),
                          SvgIconWithText(
                            icon: SvgIcons.abv,
                            text: "$averageAbvStr %",
                            textStyle: eventStatTextStyle,
                            iconSize: 20,
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        height: 80,
                        child: SvgCardIcon(
                          icon: beerSizeToCardIcon(
                            averageBeerSize,
                            averageIsDraft,
                          ),
                          color: averageColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // = Permille graph =
            ChartContainer(
              padding: EdgeInsets.only(
                right: CardListCommon.listPaddingHorizontal + 4,
              ),
              height: 300,
              child: AlcoholChart(
                chartPoints: stats.chartPoints,
                durationHours: stats.durationWithSoberingHours,
              ),
            ),
            SizedBox(height: 20),
            // = Top brewery names =
            StatLeaderboard(
              headerText: "TOP PIVOVARY",
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
            // = Top beers =
            StatLeaderboard(
              headerText: "TOP PIVA",
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
            // (Some empty space at the end so the last text isn't near the screen edge)
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
