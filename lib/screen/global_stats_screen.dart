import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/widget/card/beer_consumption_card.dart";
import "package:my_beer_diary/widget/stat_list_tile.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

enum GlobalStatsVariant { all, year, tag }

class GlobalStatsScreen extends StatefulWidget {
  const GlobalStatsScreen({super.key});

  @override
  State<GlobalStatsScreen> createState() => _GlobalStatsScreenState();
}

class _GlobalStatsScreenState extends State<GlobalStatsScreen> {
  GlobalStatsVariant selectedVariant = GlobalStatsVariant.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Celková statistika")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RadioGroup<GlobalStatsVariant>(
              groupValue: selectedVariant,
              onChanged: (GlobalStatsVariant? value) {
                if (value != null) {
                  setState(() {
                    selectedVariant = value;
                  });
                }
              },
              child: Column(
                children: [
                  RadioListTile(
                    value: GlobalStatsVariant.all,
                    title: Text("Od počátku věků"),
                  ),
                  RadioListTile(
                    value: GlobalStatsVariant.year,
                    title: Text("Pro konkrétní rok"),
                  ),
                  RadioListTile(
                    value: GlobalStatsVariant.tag,
                    title: Text("Pro konkrétní tag"),
                  ),
                ],
              ),
            ),
            //Divider(),
            //SizedBox(height: 6.6),
            StatListTile(
              leading: SvgIcon(icon: SvgIcons.beer),
              text: "Celkem vypito ? piv",
            ),
            Divider(height: 0),
            StatListTile(
              leading: SvgIcon(icon: SvgIcons.beerSizeCustom),
              text: "Celkem vypito ? litrů",
            ),
            Divider(height: 0),
            StatListTile(
              leading: SvgIcon(icon: SvgIcons.money),
              text: "Celková útrata: ? Kč",
            ),
            Divider(height: 0),
            SizedBox(height: 6.6),
            Padding(
              padding: CardListCommon.horizontalPaddingOnly,
              child: BeerConsumptionCard(
                beer: Beer.unknownBeer,
                beerConsumption: BeerConsumption(
                  timestamp: 0,
                  beerId: 0,
                  litres: 0,
                  price: 0,
                  isDraft: false,
                ),
                isStats: true,
              ),
            ),
            SizedBox(height: 6.6),
            SizedBox(
              height: 300,
              child: Padding(
                padding: EdgeInsets.only(
                  right: CardListCommon.listPaddingHorizontal + 4,
                ),
                child: Text("zde bude graf?"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
