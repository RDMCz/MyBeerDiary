import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/widget/beer_consumption_card.dart";

class OneoffList extends StatelessWidget {
  final List<BeerConsumption> oneoffs;

  const OneoffList({super.key, required this.oneoffs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: CardListCommon.listPadding,
      itemCount: oneoffs.length,
      itemBuilder: (_, int idx) => Padding(
        padding: CardListCommon.itemPadding,
        child: BeerConsumptionCard(
          beers: {} /*TODO*/,
          beerConsumption: oneoffs[idx],
        ),
      ),
    );
  }
}
