import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/widget/card/beer_consumption_card.dart";
import "package:provider/provider.dart";

class OneoffList extends StatelessWidget {
  const OneoffList({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch because this widget might change on Beer/Consumption change (oneoffs/beers CRUD)
    final beers = context.watch<BeerNotifier>().itemMap;
    final oneoffs = context.watch<BeerConsumptionNotifier>().items();

    return ListView.builder(
      padding: CardListCommon.listPadding,
      itemCount: oneoffs.length,
      itemBuilder: (_, int idx) => Padding(
        padding: CardListCommon.itemPadding,
        child: BeerConsumptionCard(
          beer: beers[oneoffs[idx].beerId] ?? Beer.defaultBeer,
          beerConsumption: oneoffs[idx],
        ),
      ),
    );
  }
}
