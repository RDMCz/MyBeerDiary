import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_consumption_add.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";

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
    final beerConsumptions =
        await beerConsumptionList(); //TODO only this event beers
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final _ in _beerConsumptions)
            Padding(padding: CardListCommon.listPadding),
        ],
      ),
      bottomNavigationBar: BottomAppBar(color: Colors.amber),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => BeerConsumptionAddDialog(beers: _beers),
          );
          if (result ?? false) {
            //
          }
        },
        child: Icon(Icons.add),
      ),
      // (https://github.com/flutter/flutter/issues/140733)
      // This FAB placement crashes while debugging on desktop and in browser, but not in emulator:
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
