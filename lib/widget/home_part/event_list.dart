import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/card/event_card.dart";
import "package:provider/provider.dart";

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch because this widget might change on Events change
    final events = context.watch<EventNotifier>().itemList;

    return ListView.builder(
      padding: CardListCommon.listPadding,
      itemCount: events.length,
      itemBuilder: (_, int idx) => Padding(
        padding: CardListCommon.itemPadding,
        child: EventCard(event: events[idx]),
      ),
    );
  }
}
