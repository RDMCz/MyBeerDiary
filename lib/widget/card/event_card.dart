import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_dialog.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/screen/event_screen.dart";
import "package:my_beer_diary/widget/tag_chip.dart";
import "package:provider/provider.dart";

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Watch because this widget might change on Tags change
    final tags = context.watch<TagNotifier>().itemMap;

    final tagId = event.tagId;
    final Tag? tag = tags[tagId];

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
                    if (tag != null) TagChip(tag: tag),
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
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventScreen(event: event, tag: tag),
            ),
          );
          // Refresh events here because event totals (nBeers, cost) could get updated
          if (context.mounted) {
            context.read<EventNotifier>().refresh();
          }
        },
        onLongPress: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => EventDialog(tags: tags, event: event),
          );
          if (context.mounted && (result ?? false)) {
            // Event was either edited or deleted => refresh list
            context.read<EventNotifier>().refresh();
            // New tag could have created in the dialog too
            context.read<TagNotifier>().refresh();
          }
        },
      ),
    );
  }
}
