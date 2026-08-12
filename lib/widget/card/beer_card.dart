import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_dialog.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class BeerCard extends StatelessWidget {
  final Beer beer;

  const BeerCard({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: CardCommon.normalPadding,
        child: Row(
          children: [
            // = Info column =
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        "${beer.breweryName} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(beer.description, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Text(
                    "${beer.epm}° @ ${beer.abv} %",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // = Beer Icon =
                SizedBox(
                  height: 70,
                  child: SvgCardIcon(
                    icon: SvgCardIcons.beerLarge,
                    color: beer.color,
                  ),
                ),
                SizedBox(width: 6),
                // = Edit Button =
                IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => BeerDialog(beer: beer),
                    );
                    if (context.mounted && (result ?? false)) {
                      context.read<BeerNotifier>().refresh();
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
                // = Delete Button =
                IconButton(
                  onPressed: () async {
                    final breweryNameWithSpace = beer.breweryName.isNotEmpty
                        ? "${beer.breweryName} "
                        : "";

                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Smazat pivo"),
                        content: Text(
                          "Opravdu si přejete smazat pivo „$breweryNameWithSpace${beer.description}“?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Zrušit"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Smazat"),
                          ),
                        ],
                      ),
                    );

                    if (result ?? false) {
                      await beerDelete(beer.id!);
                      if (context.mounted) {
                        context.read<BeerNotifier>().refresh();
                      }
                    }
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
