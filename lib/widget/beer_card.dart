import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/beer_add_edit.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerCard extends StatelessWidget {
  final Beer beer;
  final VoidCallback refreshBeers;

  const BeerCard({super.key, required this.beer, required this.refreshBeers});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6),
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
                  //Text("$beer"),
                ],
              ),
            ),
            Row(
              children: [
                // = Beer Icon =
                SvgCardIcon(filename: "_card_beer_large", color: beer.color),
                // = Edit Button =
                IconButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => BeerAddEditDialog(beer: beer),
                    );
                    if (result ?? false) {
                      refreshBeers();
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
                      refreshBeers();
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
