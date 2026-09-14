import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/dialog/beer_consumption_dialog.dart";
import "package:my_beer_diary/dialog/event_dialog.dart";
import "package:my_beer_diary/model/beer_consumption.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/form/dropdown_menu_small.dart";
import "package:my_beer_diary/widget/home_part/home_drawer.dart";
import "package:my_beer_diary/widget/home_part/event_list.dart";
import "package:my_beer_diary/widget/home_part/oneoff_list.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomBarIndex = 0;

  void _onBottomBarTap(int index) {
    setState(() {
      bottomBarIndex = index;
    });
  }

  bool isEventFilterEnabled = false;
  Tag selectedFilterTag = Tag.unknownTag;

  @override
  Widget build(BuildContext context) {
    final bottomBarColorSelected = appColorPrimary;
    final bottomBarColorUnselected = appColorSecondary;

    final isEventPageSelected = bottomBarIndex == 0;

    final tags = context.watch<TagNotifier>().itemMap;
    final tagSelectItems = [
      for (final tag in tags.values)
        DropdownMenuEntry(value: tag, label: tag.name),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Můj pivní deníček"),
        actions: [
          if (isEventPageSelected)
            Padding(
              padding: EdgeInsets.only(
                right: CardListCommon.listPaddingHorizontal,
              ),
              child: IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    isEventFilterEnabled = !isEventFilterEnabled;
                  });
                },
                icon: Icon(
                  !isEventFilterEnabled
                      ? Icons.filter_alt
                      : Icons.filter_alt_off,
                ),
              ),
            ),
        ],
        bottom: !isEventFilterEnabled
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Padding(
                  padding: CardListCommon.horizontalPaddingOnly,
                  child: Row(
                    children: [
                      Spacer(),
                      DropdownMenuSmall<Tag>(
                        enabled: true,
                        dropdownMenuEntries: tagSelectItems,
                        initialSelection: selectedFilterTag,
                        onSelected: (Tag value) {
                          setState(() {
                            selectedFilterTag = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
      // = Body with selected page =
      body: isEventPageSelected
          ? EventList(
              isEventFilterEnabled: isEventFilterEnabled,
              filterTagId: selectedFilterTag != Tag.unknownTag
                  ? selectedFilterTag.id
                  : null,
            )
          : OneoffList(),
      // = BottomNavigationBar =
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgIcon(
              icon: SvgIcons.event,
              color: isEventPageSelected
                  ? bottomBarColorSelected
                  : bottomBarColorUnselected,
            ),
            label: "Události",
          ),
          BottomNavigationBarItem(
            icon: SvgIcon(
              icon: SvgIcons.oneoff,
              color: !isEventPageSelected
                  ? bottomBarColorSelected
                  : bottomBarColorUnselected,
            ),
            label: "Jednorázové",
          ),
        ],
        currentIndex: bottomBarIndex,
        onTap: _onBottomBarTap,
      ),
      // = Hamburger menu =
      drawer: HomeDrawer(),
      // = Plus button in the middle of BottomNavigationBar =
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isEventPageSelected) {
            // = Add new event =
            // It currently seems cleaner to pass [tags] to [EventDialog] instead of letting it read them for itself
            final tags = context.read<TagNotifier>().itemMap;

            final result = await showDialog(
              context: context,
              builder: (_) => EventDialog(tags: tags),
            );
            if (context.mounted) {
              if (result ?? false) {
                // Refresh both events and tags, because tag could have been added in the dialog
                if (context.mounted) {
                  await context.read<EventNotifier>().refresh();
                }
                if (context.mounted) {
                  await context.read<TagNotifier>().refresh();
                }
              }
            }
          } else {
            // = Add new oneoff beer =
            final result = await showDialog(
              context: context,
              builder: (_) => BeerConsumptionDialog(
                eventId: null,
                beer: null,
                beerConsumption: null,
              ),
            );
            if (context.mounted && (result ?? false)) {
              await context.read<BeerConsumptionNotifier>().refresh();
            }
          }
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
