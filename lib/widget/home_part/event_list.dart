import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/card/event_card.dart";
import "package:provider/provider.dart";

class EventList extends StatelessWidget {
  final bool isEventFilterEnabled;
  final int? filterTagId;

  const EventList({
    super.key,
    required this.isEventFilterEnabled,
    required this.filterTagId,
  });

  @override
  Widget build(BuildContext context) {
    // Watch because this widget might change on Events change
    final allEvents = context.watch<EventNotifier>().itemList;

    final events = isEventFilterEnabled && filterTagId != null
        ? allEvents.where((item) => item.tagId == filterTagId).toList()
        : allEvents;

    return ListView.builder(
      padding: CardListCommon.listOnHomeScreenPadding,
      itemCount: events.length,
      itemBuilder: (_, int idx) => Padding(
        padding: CardListCommon.itemPadding,
        child: EventCard(event: events[idx], isInteractable: true),
      ),
    );
  }
}
