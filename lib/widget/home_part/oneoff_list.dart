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
    final oneoffs = context.watch<BeerConsumptionNotifier>().itemsOneoffs();

    return ListView.builder(
      reverse: true,
      padding: CardListCommon.listOnHomeScreenPadding,
      itemCount: oneoffs.length,
      itemBuilder: (_, int idxR) {
        final idx = oneoffs.length - 1 - idxR;
        return Padding(
          padding: CardListCommon.itemPadding,
          child: BeerConsumptionCard(
            beer: beers[oneoffs[idx].beerId] ?? Beer.unknownBeer,
            beerConsumption: oneoffs[idx],
            isStats: false,
          ),
        );
      },
    );
  }
}
