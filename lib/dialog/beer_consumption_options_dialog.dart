import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class BeerConsumptionOptionsDialog extends StatelessWidget {
  final Beer beer;
  final BeerConsumption beerConsumption;

  const BeerConsumptionOptionsDialog({
    super.key,
    required this.beer,
    required this.beerConsumption,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(beer.toDisplayString(), style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // = Button :: Edit BeerConsumption =
                    TextButton.icon(
                      label: Text("Upravit záznam"),
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //TODO
                      },
                    ),
                    // = Button :: Edit Beer =
                    TextButton.icon(
                      label: Text("Upravit pivo globálně"),
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //TODO
                      },
                    ),
                    // = Button :: Delete BeerConsumption =
                    TextButton.icon(
                      label: Text("Smazat záznam"),
                      icon: Icon(Icons.delete_forever),
                      onPressed: () async {
                        if (beerConsumption.id == null) {
                          return;
                        }

                        final result = await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Smazat záznam"),
                            content: Text(
                              "Opravdu si přejete smazat vypití piva „${beer.toDisplayString()}“?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Zrušit"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Smazat"),
                              ),
                            ],
                          ),
                        );

                        if (result ?? false) {
                          await beerConsumptionDelete(beerConsumption.id!);

                          if (beerConsumption.eventId != null) {
                            eventUpdateTotals(
                              eventId: beerConsumption.eventId!,
                              totalBeersIncrease: -1,
                              totalCostIncrease: -beerConsumption.price,
                            );
                          }

                          if (context.mounted) {
                            // BeerConsuption was deleted, so refresh list and close this options dialog
                            context.read<BeerConsumptionNotifier>().refresh();
                            Navigator.of(context).pop(true);
                          }
                        }
                      },
                    ),
                  ],
                ),
                Spacer(),
                // = Button :: Repeat =
                FloatingActionButton.extended(
                  label: Text("Znovu"),
                  icon: SvgIcon(
                    icon: SvgIcons.repeat,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  onPressed: () {
                    //TODO
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Button :: Close =
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Zavřít"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
