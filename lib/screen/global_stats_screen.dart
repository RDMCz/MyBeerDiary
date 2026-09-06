import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/global_stats.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/card/beer_consumption_card.dart";
import "package:my_beer_diary/widget/form/checkbox.dart";
import "package:my_beer_diary/widget/form/dropdown_menu_small.dart";
import "package:my_beer_diary/widget/stat_list_tile.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class GlobalStatsScreen extends StatefulWidget {
  const GlobalStatsScreen({super.key});

  @override
  State<GlobalStatsScreen> createState() => _GlobalStatsScreenState();
}

class _GlobalStatsScreenState extends State<GlobalStatsScreen> {
  bool isFilterYear = false;
  int selectedYear = DateTime.now().year;

  bool isFilterTag = false;
  Tag selectedTag = Tag(name: "—", color: "");

  GlobalStats? stats;

  Future<void> refreshStats() async {
    final stats = await globalStats();
    setState(() {
      this.stats = stats;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshStats();
  }

  @override
  Widget build(BuildContext context) {
    const dropdownMenuWidth = 130.0;

    const firstYear = 2000;
    final lastYear = DateTime.now().year;
    final yearSelectItems = [
      for (int year = firstYear; year <= lastYear; year++)
        DropdownMenuEntry(value: year, label: "$year"),
    ];

    final tags = context.read<TagNotifier>().itemMap;
    final tagSelectItems = [
      for (final tag in tags.values)
        DropdownMenuEntry(value: tag, label: tag.name),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Celková statistika")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card.outlined(
                child: Padding(
                  padding: CardCommon.outlineCardPadding,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: LabeledCheckbox(
                              isEnabled: true,
                              label: "Filtrovat dle roku",
                              value: isFilterYear,
                              onChanged: (bool value) {
                                setState(() {
                                  isFilterYear = value;
                                });
                              },
                            ),
                          ),
                          DropdownMenuSmall<int>(
                            enabled: isFilterYear,
                            dropdownMenuEntries: yearSelectItems,
                            initialSelection: lastYear,
                            onSelected: (int value) {
                              setState(() {
                                selectedYear = value;
                              });
                            },
                            width: dropdownMenuWidth,
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: LabeledCheckbox(
                              isEnabled: true,
                              label: "Filtrovat dle tagu",
                              value: isFilterTag,
                              onChanged: (bool value) {
                                setState(() {
                                  isFilterTag = value;
                                });
                              },
                            ),
                          ),
                          DropdownMenuSmall<Tag>(
                            enabled: isFilterTag,
                            dropdownMenuEntries: tagSelectItems,
                            initialSelection: selectedTag,
                            onSelected: (Tag value) {
                              setState(() {
                                selectedTag = value;
                              });
                            },
                            width: dropdownMenuWidth,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.6),
            if (stats == null)
              Text("Žádná data", style: boldTextStyle)
            else ...[
              StatListTile(
                leading: SvgIcon(icon: SvgIcons.beer),
                text: "Celkem vypito ${stats!.totalBeers} piv",
              ),
              Divider(height: 0),
              StatListTile(
                leading: SvgIcon(icon: SvgIcons.beerSizeCustom),
                text: "Celkem vypito ${stats!.totalLitres} litrů",
              ),
              Divider(height: 0),
              StatListTile(
                leading: SvgIcon(icon: SvgIcons.money),
                text: "Celková útrata: ${stats!.totalPrice} Kč",
              ),
              Divider(height: 0),
              SizedBox(height: 6.6),
              Padding(
                padding: CardListCommon.horizontalPaddingOnly,
                child: BeerConsumptionCard(
                  beer: Beer.unknownBeer,
                  beerConsumption: stats!.averageBeerConsumption,
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
          ],
        ),
      ),
    );
  }
}
