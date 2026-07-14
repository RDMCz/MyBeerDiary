import "package:flutter/material.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/event_card.dart";

class EventList extends StatelessWidget {
  final List<Event> events;
  final Map<int, Tag> tags;
  final VoidCallback refreshEvents;

  const EventList({
    super.key,
    required this.events,
    required this.tags,
    required this.refreshEvents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12),
      children: [
        for (final event in events)
          Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: EventCard(
              event: event,
              tags: tags,
              refreshEvents: refreshEvents,
            ),
          ),
      ],
    );
  }
}
