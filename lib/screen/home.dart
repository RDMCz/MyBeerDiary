import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_add_edit.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/screen/settings.dart";
import "package:my_beer_diary/widget/event_list.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // = BottomNavigationBar =
  int _bottomBarIndex = 0;

  void _onBottomBarTap(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  // = Events list =
  List<Event> _events = [];
  Map<int, Tag> _tags = {}; // Needed to get tag names and pictures for events

  Future<void> _refreshEvents() async {
    final events = await eventList();
    final tags = await tagMap();
    setState(() {
      _events = events;
      _tags = tags;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initial [_bottomBarIndex] value is 0 => events tab is the default one
    _refreshEvents();
  }

  // = One-offs list =

  // = GUI =
  @override
  Widget build(BuildContext context) {
    final bottomBarColorSelected = Theme.of(context).colorScheme.primary;
    final bottomBarColorUnselected = Theme.of(context).colorScheme.secondary;

    final isEventPageSelected = _bottomBarIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text("Můj pivní deníček")),
      // = Body with selected page =
      body: isEventPageSelected
          ? EventList(
              events: _events,
              tags: _tags,
              refreshEvents: _refreshEvents,
            )
          : Text("Index 1"),
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
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Nastavení"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
                // Refresh list after coming back from the settings (user may have changed some tags)
                _refreshEvents();
              },
            ),
          ],
        ),
      ),
      // = Plus button in the middle of BottomNavigationBar =
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isEventPageSelected) {
            final result = await showDialog(
              context: context,
              builder: (_) => EventAddEditDialog(tags: _tags),
            );
            if (result ?? false) {
              _refreshEvents();
            }
          } else {
            //
          }
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
