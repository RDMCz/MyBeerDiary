import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/user_settings.dart";
import "package:my_beer_diary/screen/beers.dart";
import "package:my_beer_diary/screen/tags.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class HomeDrawer extends StatelessWidget {
  final VoidCallback refreshEvents;
  final VoidCallback refreshOneoffs;
  final VoidCallback refreshUserSettings;

  const HomeDrawer({
    super.key,
    required this.refreshEvents,
    required this.refreshOneoffs,
    required this.refreshUserSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Nastavení uživatele"),
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => UserSettingsDialog(),
              );
              if (result ?? false) {
                refreshUserSettings();
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.tag),
            title: Text("Správa tagů"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TagsScreen()),
              );
              refreshEvents();
            },
          ),
          ListTile(
            leading: SvgIcon(icon: SvgIcons.beer, size: 22),
            title: Text("Správa piv"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BeersScreen()),
              );
              refreshOneoffs();
            },
          ),
        ],
      ),
    );
  }
}
