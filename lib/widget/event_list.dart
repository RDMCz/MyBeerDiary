import "package:flutter/material.dart";
import "package:my_beer_diary/model/event.dart";

class EventList extends StatelessWidget {
  final List<Event> events;
  
  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("We have ${events.length} events:"),
        for (final event in events) Text("* $event"),
      ],
    );
  }
}