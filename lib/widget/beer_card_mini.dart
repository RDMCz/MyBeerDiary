import "package:flutter/material.dart";
import "package:my_beer_diary/model/beer.dart";

class BeerCardMini extends StatelessWidget {
  final Beer beer;

  const BeerCardMini({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(children: [Text("${beer.breweryName}")]),
      ),
    );
  }
}
