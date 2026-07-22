import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
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
  List<BeerConsumption> _beers = [];

  Future<void> _refreshBeers() async {
    final beers = await beerConsumptionList(); //TODO only this event beers
    setState(() {
      _beers = beers;
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
          for (final _ in _beers) Padding(padding: CardListCommon.listPadding),
        ],
      ),
    );
  }
}
