import "package:flutter/material.dart";
import "package:my_beer_diary/model/beer.dart";

class BeerCard extends StatelessWidget {
  final Beer beer;

  const BeerCard({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(0), child: Text("$beer")),
    );
  }
}
