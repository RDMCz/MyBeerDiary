import "package:flutter/material.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerCardMini extends StatelessWidget {
  final Beer beer;

  const BeerCardMini({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${beer.breweryName} ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(beer.description, style: TextStyle(fontSize: 17)),

                Text(
                  "${beer.epm}° @ ${beer.abv} %",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SvgCardIcon(filename: "_card_beer_large", color: beer.color),
          ],
        ),
      ),
    );
  }
}
