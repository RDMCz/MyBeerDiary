import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/user_settings_dialog.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/model/user_settings.dart";
import "package:my_beer_diary/screen/about_screen.dart";
import "package:my_beer_diary/screen/beers_screen.dart";
import "package:my_beer_diary/screen/global_stats_screen.dart";
import "package:my_beer_diary/screen/help_screen.dart";
import "package:my_beer_diary/screen/tags_screen.dart";
import "package:my_beer_diary/widget/svg_icon.dart";
import "package:provider/provider.dart";

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(height: 160),
          // .::.
          ListTile(
            leading: Icon(Icons.equalizer),
            title: Text("Celková statistika"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GlobalStatsScreen()),
              );
            },
          ),
          Divider(),
          // .::.
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Nastavení uživatele"),
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => UserSettingsDialog(),
              );
              if (context.mounted && (result ?? false)) {
                context.read<UserSettingsNotifier>().refresh();
              }
            },
          ),
          // .::.
          ListTile(
            leading: Icon(Icons.tag),
            title: Text("Správa tagů"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TagsScreen()),
              );
              // Refresh both events and tags, because tag could be added/removed/edited in the tags screen
              if (context.mounted) {
                context.read<EventNotifier>().refresh();
                context.read<TagNotifier>().refresh();
              }
            },
          ),
          // .::.
          ListTile(
            leading: SvgIcon(icon: SvgIcons.beer, size: 22),
            title: Text("Správa piv"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BeersScreen()),
              );
            },
          ),
          Divider(),
          // .::.
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text("Nápověda"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpScreen()),
              );
            },
          ),
          // .::.
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("O aplikaci"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
