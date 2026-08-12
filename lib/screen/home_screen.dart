import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_dialog.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
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
  // = BottomNavigationBar =
  int _bottomBarIndex = 0;

  void _onBottomBarTap(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  // = GUI =
  @override
  Widget build(BuildContext context) {
    final bottomBarColorSelected = Theme.of(context).colorScheme.primary;
    final bottomBarColorUnselected = Theme.of(context).colorScheme.secondary;

    final isEventPageSelected = _bottomBarIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text("Můj pivní deníček")),
      // = Body with selected page =
      body: isEventPageSelected ? EventList() : OneoffList(),
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
        currentIndex: _bottomBarIndex,
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
                context.read<EventNotifier>().refresh();
                context.read<TagNotifier>().refresh();
              }
            }
          } else {
            // = Add new oneoff beer =
          }
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
