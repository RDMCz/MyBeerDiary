import "package:flutter/material.dart";
import "package:my_beer_diary/screen/beers.dart";
import "package:my_beer_diary/screen/tags.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nastavení")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.tag),
            title: Text("Správa tagů"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TagsScreen()),
              );
            },
          ),
          ListTile(
            leading: SvgIcon(icon: SvgIcons.beer),
            title: Text("Správa piv"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BeersScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
