import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/brewery_input.dart";

class BeerConsumptionAddDialog extends StatefulWidget {
  final List<Beer> beers;

  const BeerConsumptionAddDialog({super.key, required this.beers});

  @override
  State<BeerConsumptionAddDialog> createState() =>
      _BeerConsumptionAddDialogState();
}

class _BeerConsumptionAddDialogState extends State<BeerConsumptionAddDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Další pivo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                Spacer(),
                IconButton.filledTonal(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: DialogCommon.headerMarginBottom),

            BreweryInput(
              onTextChanged: (value) {
                setState(() {
                  //breweryNameStr = value;
                });
              },
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            /*
            ...[
              for (final beer in widget.beers.where(
                (e) => e.breweryName == "Braník",
              ))
                Text("$beer"),
            ],
            */
          ],
        ),
      ),
    );
  }
}
