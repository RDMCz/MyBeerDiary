import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

enum BeerConsumptionEditOption { editRecord, editBeerGlobally, deleteRecord }

class BeerConsumptionOptionsDialog extends StatelessWidget {
  final Beer beer;
  final BeerConsumption beerConsumption;

  BeerConsumptionOptionsDialog({
    super.key,
    required this.beer,
    required this.beerConsumption,
  });

  final editMenuKey =
      GlobalKey<PopupMenuButtonState<BeerConsumptionEditOption>>();

  @override
  Widget build(BuildContext context) {
    final fabForegroundColor = Theme.of(
      context,
    ).colorScheme.onSecondaryContainer;

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

            // = Two FABS =
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // = FAB :: Edit =
                PopupMenuButton(
                  key: editMenuKey,
                  tooltip: "",
                  popUpAnimationStyle: AnimationStyle.noAnimation,
                  onSelected: (value) async {
                    switch (value) {
                      // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
                      case BeerConsumptionEditOption.editRecord:
                        // TODO: Handle this case.
                        break;
                      // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
                      case BeerConsumptionEditOption.editBeerGlobally:
                        // TODO: Handle this case.
                        break;
                      // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
                      case BeerConsumptionEditOption.deleteRecord:
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
                            // BeerConsumption was deleted, so refresh list and close this options dialog
                            context.read<BeerConsumptionNotifier>().refresh();
                            Navigator.of(context).pop(true);
                          }
                        }
                        break;
                      // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
                    }
                  },
                  itemBuilder: (_) =>
                      <PopupMenuEntry<BeerConsumptionEditOption>>[
                        PopupMenuItem(
                          value: BeerConsumptionEditOption.editRecord,
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("Upravit záznam"),
                          ),
                        ),
                        PopupMenuItem(
                          value: BeerConsumptionEditOption.editBeerGlobally,
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text("Upravit pivo globálně"),
                          ),
                        ),
                        PopupMenuItem(
                          value: BeerConsumptionEditOption.deleteRecord,
                          child: ListTile(
                            leading: Icon(Icons.delete_forever),
                            title: Text("Smazat záznam"),
                          ),
                        ),
                      ],
                  child: FloatingActionButton.extended(
                    clipBehavior: Clip.hardEdge,
                    onPressed: () => editMenuKey.currentState?.showButtonMenu(),
                    label: Text("Upravit"),
                    icon: SvgIcon(
                      icon: SvgIcons.edit,
                      color: fabForegroundColor,
                    ),
                  ),
                ),
                SizedBox(width: 24.0),
                // = FAB :: Repeat =
                FloatingActionButton.extended(
                  label: Text("Znovu"),
                  icon: SvgIcon(
                    icon: SvgIcons.repeat,
                    color: fabForegroundColor,
                  ),
                  onPressed: () async {
                    // Clone the beerConsumption with current timestamp and null ID (DB will assign new ID)
                    await beerConsumptionAdd(
                      beerConsumption.copyWith(
                        id: () => null,
                        timestamp: () => secondsSinceEpoch(),
                      ),
                    );
                    // Update totals if necessary
                    if (beerConsumption.eventId != null) {
                      eventUpdateTotals(
                        eventId: beerConsumption.eventId!,
                        totalBeersIncrease: 1,
                        totalCostIncrease: beerConsumption.price,
                      );
                    }
                    // BeerConsumption was added, so refresh list and close this options dialog
                    if (context.mounted) {
                      context.read<BeerConsumptionNotifier>().refresh();
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
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
