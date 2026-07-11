import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_edit.dart";
import "package:my_beer_diary/model/event.dart";

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback refreshEvents;

  const EventCard({
    super.key,
    required this.event,
    required this.refreshEvents,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        child: Text("$event"),
        onTap: () async {
          //temp (will be moved to longPress)
          final result = await showDialog(
            context: context,
            builder: (_) => EventEditDialog(event: event),
          );
          if (result ?? false) {
            // Event was either edited or deleted => refresh list
            refreshEvents();
          }
        },
        onLongPress: () {
          //
        },
      ),
    );
  }
}
