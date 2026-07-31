import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/beer_dialog.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/card/beer_card.dart";

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
      body: ListView.builder(
        padding: CardListCommon.listPadding,
        itemCount: _beers.length,
        itemBuilder: (_, int idx) => Padding(
          padding: CardListCommon.itemPadding,
          child: BeerCard(beer: _beers[idx], refreshBeers: _refreshBeers),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => BeerDialog(),
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
