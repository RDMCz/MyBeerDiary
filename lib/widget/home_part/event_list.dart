import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/user_settings.dart";
import "package:my_beer_diary/widget/card/event_card.dart";
import "package:provider/provider.dart";

class EventList extends StatelessWidget {
  final UserSettings userSettings;

  const EventList({super.key, required this.userSettings});

  @override
  Widget build(BuildContext context) {
    // Watch because this widget might change on Events change
    final events = context.watch<EventNotifier>().items;

    return ListView.builder(
      padding: CardListCommon.listPadding,
      itemCount: events.length,
      itemBuilder: (_, int idx) => Padding(
        padding: CardListCommon.itemPadding,
        child: EventCard(userSettings: userSettings, event: events[idx]),
      ),
    );
  }
}
