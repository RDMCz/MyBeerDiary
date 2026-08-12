import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/tag_dialog.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/card/tag_card.dart";
import "package:provider/provider.dart";

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagNotifier>().itemList;

    return Scaffold(
      appBar: AppBar(title: Text("Správa tagů")),
      body: ListView.builder(
        padding: CardListCommon.listPadding,
        itemCount: tags.length,
        itemBuilder: (_, int idx) => Padding(
          padding: CardListCommon.itemPadding,
          child: TagCard(tag: tags[idx]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => TagDialog(),
          );
          if (context.mounted && (result ?? false)) {
            context.read<TagNotifier>().refresh();
          }
        },
        tooltip: "Přidat nový tag",
        child: Icon(Icons.add),
      ),
    );
  }
}
