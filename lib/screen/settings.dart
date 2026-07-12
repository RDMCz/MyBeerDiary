import "package:flutter/material.dart";
import "package:my_beer_diary/screen/tags.dart";

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
        ],
      ),
    );
  }
}
