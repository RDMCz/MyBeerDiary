import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/model/user_settings.dart";
import "package:my_beer_diary/widget/event_card.dart";

class EventList extends StatelessWidget {
  final UserSettings userSettings;
  final List<Event> events;
  final Map<int, Tag> tags;
  final VoidCallback refreshEvents;

  const EventList({
    super.key,
    required this.userSettings,
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
          userSettings: userSettings,
          event: events[idx],
          tags: tags,
          refreshEvents: refreshEvents,
        ),
      ),
    );
  }
}
