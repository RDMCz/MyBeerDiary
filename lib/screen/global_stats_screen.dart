import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/model/global_stats.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/chart/beer_histogram.dart";
import "package:my_beer_diary/widget/chart/chart_container.dart";
import "package:my_beer_diary/widget/form/checkbox.dart";
import "package:my_beer_diary/widget/form/dropdown_menu_small.dart";
import "package:my_beer_diary/widget/stat_leaderboard.dart";
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
  Tag selectedTag = Tag.unknownTag;

  bool isFilterOneoffs = false;

  GlobalStats? stats;

  Future<void> refreshStats() async {
    final stats = await globalStats(
      isFilterYear: isFilterYear,
      selectedYear: selectedYear,
      isFilterTag: isFilterTag,
      selectedTag: selectedTag,
      isFilterOneoffs: isFilterOneoffs,
    );
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

    final beers = context.read<BeerNotifier>().itemMap;

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
                                refreshStats();
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
                              refreshStats();
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
                              isEnabled: !isFilterOneoffs,
                              label: "Filtrovat dle tagu",
                              value: isFilterTag,
                              onChanged: (bool value) {
                                setState(() {
                                  isFilterTag = value;
                                });
                                refreshStats();
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
                              refreshStats();
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
                              isEnabled: !isFilterTag,
                              label: "Pouze jednorázová pití",
                              value: isFilterOneoffs,
                              onChanged: (bool value) {
                                setState(() {
                                  isFilterOneoffs = value;
                                });
                                refreshStats();
                              },
                            ),
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
              Text("\nŽádná data", style: boldTextStyle)
            else ...[
              if (!isFilterOneoffs)
                StatListTile(
                  leading: SvgIcon(icon: SvgIcons.event),
                  text: "Zaznamenáno ${stats!.distinctEvents} událostí",
                ),
              StatListTile(
                leading: SvgIcon(icon: SvgIcons.beer),
                text: "Vypito ${stats!.totalBeers} piv",
                subtext:
                    "${stats!.totalDraftBeers} čepovaných, ${stats!.distinctBeers} unikátních",
              ),
              StatListTile(
                leading: SvgIcon(icon: SvgIcons.beerSizeCustom),
                text: "Objem ${stats!.totalLitres} litrů",
                subtext: isFilterTag && selectedTag != Tag.unknownTag
                    ? "Průměr ${(stats!.totalLitres / stats!.distinctEvents).toStringAsFixed(2)} L/událost"
                          " a ${(stats!.totalLitres / stats!.totalBeers).toStringAsFixed(2)} L/pivo"
                    : "Průměr ${(stats!.totalLitres / stats!.totalBeers).toStringAsFixed(2)} L/pivo",
              ),
              StatListTile(
                leading: SvgIcon(icon: SvgIcons.money),
                text: "Útrata ${stats!.totalPrice} Kč",
                subtext: isFilterTag && selectedTag != Tag.unknownTag
                    ? "Průměr ${(stats!.totalPrice / stats!.distinctEvents).toStringAsFixed(0)} Kč/událost"
                          " a ${(stats!.totalPrice / stats!.totalBeers).toStringAsFixed(0)} Kč/pivo"
                    : "Průměr ${(stats!.totalPrice / stats!.totalBeers).toStringAsFixed(0)} Kč/pivo",
              ),
              SizedBox(height: 6.6),
              ChartContainer(
                padding: EdgeInsets.zero,
                height: 200,
                child: BeerHistogram(
                  data: stats!.monthCounter,
                  isWeekday: false,
                  barWidht: 30,
                ),
              ),
              ChartContainer(
                padding: EdgeInsets.zero,
                height: 200,
                child: BeerHistogram(
                  data: stats!.weekdayCounter,
                  isWeekday: true,
                  barWidht: 30,
                ),
              ),
              Text(stats!.weekdayCounter.toString()),
              SizedBox(height: 20),
              StatLeaderboard(
                headerText: "TOP PIVA",
                children: [
                  for (final (index, item) in stats!.topBeers.indexed)
                    Row(
                      children: [
                        Text(
                          "#${index + 1}  ${(beers[item.$1] ?? Beer.unknownBeer).toDisplayString()}",
                        ),
                        Spacer(),
                        Text("${item.$2} x"),
                      ],
                    ),
                ],
              ),
              if (!isFilterTag && !isFilterOneoffs)
                StatLeaderboard(
                  headerText: "TOP TAGY",
                  children: [
                    for (final (index, item) in stats!.topTags.indexed)
                      Row(
                        children: [
                          Text("#${index + 1} ${tags[item.$1]?.name}"),
                          Spacer(),
                          Text(
                            "${item.$2} záznamů, ${item.$3} piv, ${item.$4} Kč",
                          ),
                        ],
                      ),
                  ],
                ),
              // (Some empty space at the end so the last text isn't near the screen edge)
              SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
