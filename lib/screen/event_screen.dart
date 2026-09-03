import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/dialog/beer_consumption_dialog.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/logic/cz.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/model/user_settings.dart";
import "package:my_beer_diary/screen/event_stats_screen.dart";
import "package:my_beer_diary/widget/card/beer_consumption_card.dart";
import "package:my_beer_diary/widget/event_stat.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class EventScreen extends StatelessWidget {
  final Event event;
  final Tag? tag;

  const EventScreen({super.key, required this.event, required this.tag});

  @override
  Widget build(BuildContext context) {
    // We have to do this for total price and total beers to update at the bottom of this screen
    final events = context.watch<EventNotifier>().itemMap;
    // (Fallback to maybe outdated event, shouldn't happen)
    final freshEvent = events[event.id] ?? event;

    final beers = context.watch<BeerNotifier>().itemMap;

    final beerConsumptions = context
        .watch<BeerConsumptionNotifier>()
        .itemsForEvent(freshEvent.id);

    // Read is enough, no need to watch, because user settings cannot be changed from this screen or its children
    final userSettings = context.read<UserSettingsNotifier>().value;

    final stats = eventStats(
      beers: beers,
      beerConsumptions: beerConsumptions,
      userSettings: userSettings,
    );

    return Scaffold(
      appBar: AppBar(title: Text(freshEvent.toDisplayString(tag))),
      // = Body with beerConsumption card list =
      body: ListView.builder(
        reverse: true,
        padding: CardListCommon.horizontalPaddingOnly,
        itemCount: beerConsumptions.length,
        itemBuilder: (_, int idxR) {
          final idx = beerConsumptions.length - 1 - idxR;
          return Padding(
            padding: CardListCommon.itemPadding,
            child: BeerConsumptionCard(
              beer: beers[beerConsumptions[idx].beerId] ?? Beer.unknownBeer,
              beerConsumption: beerConsumptions[idx],
              isStats: false,
            ),
          );
        },
      ),
      // = Bottom bar with stats and FAB =
      bottomNavigationBar: BottomAppBar(
        color: Color(0xfff4f1e7),
        height: 112,
        child: Row(
          children: [
            // = Stats =
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventStat(
                  icon: SvgIcons.beer,
                  text:
                      "${freshEvent.totalBeers} ${beerDeclension(freshEvent.totalBeers)}",
                ),
                EventStat(
                  icon: SvgIcons.money,
                  text: "${freshEvent.totalCost} Kč",
                ),
                EventStat(
                  icon: SvgIcons.permille,
                  text:
                      "${stats != null ? stats.maxPermille.toStringAsFixed(2) : 0} max. promile",
                ),
              ],
            ),
            Spacer(),
            // = FAB =
            Padding(
              padding: EdgeInsets.only(top: 21),
              child: FloatingActionButton.small(
                heroTag: "eventfab1",
                backgroundColor: stats != null
                    ? Theme.of(context).colorScheme.primaryContainer
                    : appColorDisabledFAB,
                onPressed: stats == null
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventStatsScreen(
                              event: freshEvent,
                              stats: stats,
                              beers: beers,
                            ),
                          ),
                        );
                      },
                child: Icon(Icons.equalizer),
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 72,
              height: 72,
              child: FittedBox(
                child: FloatingActionButton(
                  heroTag: "eventfab2",
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => BeerConsumptionDialog(
                        eventId: freshEvent.id,
                        beer: null,
                        beerConsumption: null,
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
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
