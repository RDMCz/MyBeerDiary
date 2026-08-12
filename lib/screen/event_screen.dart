import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_consumption_dialog.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/model/user_settings.dart";
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
    final title = tag == null ? event.name : "${tag!.name} ${event.name}";

    final beers = context.watch<BeerNotifier>().itemMap;

    final beerConsumptions = context
        .watch<BeerConsumptionNotifier>()
        .itemsForEvent(event.id);

    final userSettings = context.watch<UserSettingsNotifier>().value;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      // = Body with beerConsumption card list =
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: CardListCommon.listPaddingHorizontal,
        ),
        itemCount: beerConsumptions.length,
        itemBuilder: (_, int idx) => Padding(
          padding: CardListCommon.itemPadding,
          child: BeerConsumptionCard(
            beer: beers[beerConsumptions[idx].beerId] ?? Beer.defaultBeer,
            beerConsumption: beerConsumptions[idx],
          ),
        ),
      ),
      // = Bottom bar with stats and FAB =
      bottomNavigationBar: BottomAppBar(
        color: Color(0xfff4f1e7),
        height: 112,
        child: Row(
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventStat(icon: SvgIcons.beer, text: "? piv"),
                EventStat(icon: SvgIcons.money, text: "? Kč"),
                EventStat(
                  icon: SvgIcons.permille,
                  text: "? promile, ${userSettings.weight}",
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: 72,
              height: 72,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => BeerConsumptionDialog(
                        eventId: event.id,
                        beers: beers.values.toList(),
                      ),
                    );
                    if (context.mounted && (result ?? false)) {
                      // New beer could have been created
                      context.read<BeerNotifier>().refresh();
                      context.read<BeerConsumptionNotifier>().refresh();
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
