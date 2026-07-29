import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer_consumption.dart";

class BeerConsumptionCard extends StatelessWidget {
  final BeerConsumption beerConsumption;

  const BeerConsumptionCard({super.key, required this.beerConsumption});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: CardCommon.normalPadding,
        child: Text("$beerConsumption"),
      ),
    );
  }
}
