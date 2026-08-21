import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:provider/provider.dart";

class BeerConsumptionMoveDialog extends StatefulWidget {
  final BeerConsumption beerConsumption;

  const BeerConsumptionMoveDialog({super.key, required this.beerConsumption});

  @override
  State<BeerConsumptionMoveDialog> createState() =>
      _BeerConsumptionMoveDialogState();
}

class _BeerConsumptionMoveDialogState extends State<BeerConsumptionMoveDialog> {
  int? selectedEventId;

  @override
  Widget build(BuildContext context) {
    final events = context.read<EventNotifier>().itemList;
    final tags = context.read<TagNotifier>().itemMap;

    return Dialog(
      insetPadding: DialogCommon.insetPadding,
      shape: DialogCommon.shape,
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text(
              "Přesunout záznam do události",
              style: DialogCommon.headerStyle,
            ),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            SizedBox(
              height: 200.0,
              child: RadioGroup<int?>(
                groupValue: selectedEventId,
                onChanged: (int? value) {
                  setState(() {
                    selectedEventId = value;
                  });
                },
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (_, int idx) {
                    final event = events[idx];
                    final Tag? tag = tags[event.tagId];
                    return RadioListTile(
                      title: Text(event.toDisplayString(tag)),
                      value: event.id,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Buttons =
            Row(
              children: [
                Spacer(),

                // = Button :: Cancel =
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Zrušit"),
                ),
                SizedBox(width: DialogCommon.buttonSpace),

                // = Button :: Confirm =
                TextButton(
                  onPressed: selectedEventId == null
                      ? null
                      : () async {
                          final eventId = selectedEventId!;

                          await beerConsumptionUpdate(
                            widget.beerConsumption.copyWith(
                              eventId: () => eventId,
                            ),
                          );

                          await eventUpdateTotals(
                            eventId: eventId,
                            totalBeersIncrease: 1,
                            totalCostIncrease: widget.beerConsumption.price,
                          );

                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        },
                  child: Text("Přesunout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
