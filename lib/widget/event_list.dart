import "package:flutter/material.dart";
import "package:my_beer_diary/model/event.dart";

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final events = await eventList();
    setState(() {
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("We have ${_events.length} events:"),
        for (final event in _events) Text("* $event"),
      ],
    );
  }
}
