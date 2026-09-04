// This dialog is shown on long press on the beer consumption card.
// It allows to edit/delete/... selected beer consumption.

import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_consumption_dialog.dart";
import "package:my_beer_diary/dialog/beer_consumption_move_dialog.dart";
import "package:my_beer_diary/dialog/beer_dialog.dart";
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
                        final result = await showDialog(
                          context: context,
                          builder: (_) => BeerConsumptionDialog(
                            eventId: beerConsumption.eventId,
                            beer: beer,
                            beerConsumption: beerConsumption,
                          ),
                        );
                        if (context.mounted && (result ?? false)) {
                          // Pop true, caller of this dialog will refresh beerConsumptions and Events
                          Navigator.of(context).pop(true);
                        }
                        break;
                      // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
                      case BeerConsumptionEditOption.editBeerGlobally:
                        final result = await showDialog(
                          context: context,
                          builder: (_) => BeerDialog(beer: beer),
                        );
                        if (context.mounted && (result ?? false)) {
                          // Beer was changed
                          context.read<BeerNotifier>().refresh();
                          // BeerConsumptions haven't changed, but pop true anyways, alcohol needs to be recalculated (beer ABV may have changed)
                          Navigator.of(context).pop(true);
                        }
                        // (Do not close this dialog on edit beer abort)
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
                            // Pop true, caller of this dialog will refresh beerConsumptions and Events
                            Navigator.of(context).pop(true);
                          }
                        }
                        // (Do not close this dialog on delete abort)
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
                    if (context.mounted) {
                      // Pop true, caller of this dialog will refresh beerConsumptions and Events
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            if (beerConsumption.eventId == null) ...[
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => BeerConsumptionMoveDialog(
                        beerConsumption: beerConsumption,
                      ),
                    );
                    if (context.mounted && (result ?? false)) {
                      // Pop true, caller of this dialog will refresh beerConsumptions and Events
                      Navigator.of(context).pop(true);
                    }
                  },
                  label: Text("Přesunout záznam do události"),
                  icon: Icon(Icons.move_down_rounded),
                ),
              ),
              SizedBox(height: DialogCommon.bodyMarginBottom),
            ],

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
