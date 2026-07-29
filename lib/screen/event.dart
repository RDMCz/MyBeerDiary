import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_consumption_add.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/beer_consumption_card.dart";
import "package:my_beer_diary/widget/event_stat.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class EventScreen extends StatefulWidget {
  final Event event;
  final Tag? tag;

  const EventScreen({super.key, required this.event, required this.tag});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<Beer> _beers = [];
  List<BeerConsumption> _beerConsumptions = [];

  Future<void> _refreshBeers() async {
    final beers = await beerList();
    final beerConsumptions = await beerConsumptionList(widget.event.id);

    setState(() {
      _beers = beers;
      _beerConsumptions = beerConsumptions;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshBeers();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.tag == null
        ? widget.event.name
        : "${widget.tag!.name} ${widget.event.name}";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: CardListCommon.listPaddingHorizontal,
        ),
        itemCount: _beerConsumptions.length,
        itemBuilder: (_, int idx) => Padding(
          padding: CardListCommon.itemPadding,
          child: BeerConsumptionCard(beerConsumption: _beerConsumptions[idx]),
        ),
      ),
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
                EventStat(icon: SvgIcons.permille, text: "? promile"),
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
                      builder: (_) => BeerConsumptionAddDialog(
                        eventId: widget.event.id,
                        beers: _beers,
                      ),
                    );
                    if (result ?? false) {
                      _refreshBeers();
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
