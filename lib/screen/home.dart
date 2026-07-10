import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/event_add.dart";

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _bottomBarIndex = 0;

  static const List<Widget> _bottomBarPages = <Widget>[
    Text("Index 0"),
    Text("Index 1"),
  ];

  void _onBottomBarTap(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Můj pivní deníček")),
      body: Center(child: _bottomBarPages.elementAt(_bottomBarIndex)),
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
        onPressed: () {
          showDialog(context: context, builder: (_) => EventAddDialog());
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
