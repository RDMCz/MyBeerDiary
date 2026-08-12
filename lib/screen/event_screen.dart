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

class EventScreen extends StatefulWidget {
  final UserSettings userSettings;
  final Event event;
  final Tag? tag;

  const EventScreen({
    super.key,
    required this.userSettings,
    required this.event,
    required this.tag,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    final title = widget.tag == null
        ? widget.event.name
        : "${widget.tag!.name} ${widget.event.name}";

    final beers = context.watch<BeerNotifier>().itemMap;

    final beerConsumptions = context
        .watch<BeerConsumptionNotifier>()
        .itemsForEvent(widget.event.id);

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
                  text: "? promile, ${widget.userSettings.weight}",
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
                        eventId: widget.event.id,
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
