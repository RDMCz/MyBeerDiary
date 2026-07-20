import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_add_edit.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/screen/event.dart";
import "package:my_beer_diary/widget/tag_chip.dart";

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
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                // Makes Wrap start from left side of the Card
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (tag != null) TagChip(tagName: tag.name),
                    Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    secondsToDateString(event.timestamp),
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    "${event.totalBeers} piv, ${event.totalCost} Kč",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => EventScreen(event: event, tag: tag),
          );
        },
        onLongPress: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => EventAddEditDialog(tags: tags, event: event),
          );
          if (result ?? false) {
            // Event was either edited or deleted => refresh list
            refreshEvents();
          }
        },
      ),
    );
  }
}
