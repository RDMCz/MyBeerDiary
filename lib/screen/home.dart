import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_add.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/widget/event_list.dart";

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // = Bottom app bar =
  int _bottomBarIndex = 0;

  void _onBottomBarTap(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  // = Events list =
  List<Event> _events = [];

  Future<void> _refreshEvents() async {
    final events = await eventList();
    setState(() {
      _events = events;
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
    final isEventPageSelected = _bottomBarIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text("Můj pivní deníček")),
      body: isEventPageSelected ? EventList(events: _events) : Text("Index 1"),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration),
            label: "Události",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: "Jednorázové",
          ),
        ],
        currentIndex: _bottomBarIndex,
        onTap: _onBottomBarTap,
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isEventPageSelected) {
            final result = await showDialog(
              context: context,
              builder: (_) => EventAddDialog(),
            );
            if (result) {
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
