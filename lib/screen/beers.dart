import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_add_edit.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/beer_card.dart";

class BeersScreen extends StatefulWidget {
  const BeersScreen({super.key});

  @override
  State<BeersScreen> createState() => _BeersScreenState();
}

class _BeersScreenState extends State<BeersScreen> {
  List<Beer> _beers = [];

  Future<void> _refreshBeers() async {
    final beers = await beerList();
    setState(() {
      _beers = beers;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshBeers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Správa piv")),
      body: ListView(
        padding: CardListCommon.listPadding,
        children: [
          for (final beer in _beers)
            Padding(
              padding: CardListCommon.itemPadding,
              child: BeerCard(beer: beer),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => BeerAddEditDialog(),
          );
          if (result ?? false) {
            _refreshBeers();
          }
        },
        tooltip: "Přidat nové pivo",
        child: Icon(Icons.add),
      ),
    );
  }
}
