import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/event_stats.dart";
import "package:my_beer_diary/widget/card/beer_consumption_card.dart";
import "package:my_beer_diary/widget/card/event_card.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class EventStatsScreen extends StatelessWidget {
  final Event event;
  final EventStats stats;

  const EventStatsScreen({super.key, required this.event, required this.stats});

  @override
  Widget build(BuildContext context) {
    final averageBeer = Beer(
      id: -1,
      breweryName: "",
      description: "",
      epm: stats.averageEPM,
      abv: stats.averageABV,
      color: "",
    );

    final averageBeerConsumption = BeerConsumption(
      timestamp: 0,
      beerId: -1,
      litres: stats.totalLitres / event.totalBeers,
      price: event.totalCost ~/ event.totalBeers,
      isDraft: true,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Statistika události")),
      body: Column(
        children: [
          // = Event card =
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: CardListCommon.listPaddingHorizontal,
            ),
            child: EventCard(event: event, isInteractable: false),
          ),
          SizedBox(height: 6.6),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
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
            padding: EdgeInsets.symmetric(
              horizontal: CardListCommon.listPaddingHorizontal,
            ),
            child: BeerConsumptionCard(
              beer: averageBeer,
              beerConsumption: averageBeerConsumption,
              isStats: true,
            ),
          ),
        ],
      ),
    );
  }
}
