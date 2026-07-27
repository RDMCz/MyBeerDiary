import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
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
    return ListView.builder(
      padding: CardListCommon.listPadding,
      itemCount: events.length,
      itemBuilder: (_, int idx) => Padding(
        padding: CardListCommon.itemPadding,
        child: EventCard(
          event: events[idx],
          tags: tags,
          refreshEvents: refreshEvents,
        ),
      ),
    );
  }
}
