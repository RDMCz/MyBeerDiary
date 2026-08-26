import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_dialog.dart";
import "package:my_beer_diary/dialog/beer_merge_dialog.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
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
                    final result = await showDialog(
                      context: context,
                      builder: (_) => BeerMergeDialog(beer: beer),
                    );
                    if (result ?? false) {
                      if (context.mounted) {
                        await context.read<BeerNotifier>().refresh();
                      }
                      if (context.mounted) {
                        await context.read<BeerConsumptionNotifier>().refresh();
                      }
                    }
                  },
                  icon: Icon(Icons.move_down_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
