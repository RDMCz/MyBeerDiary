import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_edit.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";

class EventCard extends StatelessWidget {
  final Event event;
  final Map<int, Tag> tags;
  final VoidCallback refreshEvents;

  const EventCard({
    super.key,
    required this.event,
    required this.tags,
    required this.refreshEvents,
  });

  @override
  Widget build(BuildContext context) {
    final tagId = event.tagId;
    final tag = tags.containsKey(tagId) ? tags[tagId] : null;

    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        child: Column(
          children: [
            Row(
              children: [
                Chip(
                  avatar: Icon(Icons.tag),
                  label: Text(tag == null ? "NULL" : tag.name),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
            Text("$event"),
          ],
        ),
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
