import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_dialog.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/card/beer_card.dart";
import "package:provider/provider.dart";

class BeersScreen extends StatelessWidget {
  const BeersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final beers = context.watch<BeerNotifier>().itemList;

    return Scaffold(
      appBar: AppBar(title: Text("Správa piv")),
      body: ListView.builder(
        padding: CardListCommon.listPadding,
        itemCount: beers.length,
        itemBuilder: (_, int idx) => Padding(
          padding: CardListCommon.itemPadding,
          child: BeerCard(beer: beers[idx]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => BeerDialog(),
          );
          if (context.mounted && (result ?? false)) {
            context.read<BeerNotifier>().refresh();
          }
        },
        tooltip: "Přidat nové pivo",
        child: Icon(Icons.add),
      ),
    );
  }
}
