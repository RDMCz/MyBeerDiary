import "package:flutter/material.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/event_card.dart";

class EventList extends StatelessWidget {
  final List<Event> events;
  final VoidCallback refreshEvents;

  const EventList({
    super.key,
    required this.events,
    required this.refreshEvents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("We have ${events.length} events:"),
        for (final event in events)
          EventCard(event: event, refreshEvents: refreshEvents),
      ],
    );
  }
}
