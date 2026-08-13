import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/tag_dialog.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/tag_chip.dart";
import "package:provider/provider.dart";

class TagCard extends StatelessWidget {
  final Tag tag;

  const TagCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: CardCommon.normalPadding,
        child: Row(
          children: [
            // = Tag name =
            TagChip(tag: tag),
            Spacer(),
            // = Edit button =
            IconButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => TagDialog(tag: tag),
                );
                if (context.mounted && (result ?? false)) {
                  context.read<TagNotifier>().refresh();
                }
              },
              icon: Icon(Icons.edit),
            ),
            // = Delete button =
            IconButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Smazat tag"),
                    content: Text(
                      "Opravdu si přejete smazat tag „${tag.name}“?\n\nUdálosti s tímto tagem budou zachovány.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("Zrušit"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("Smazat"),
                      ),
                    ],
                  ),
                );

                if (result ?? false) {
                  await tagDelete(tag.id!);
                  if (context.mounted) {
                    context.read<TagNotifier>().refresh();
                  }
                }
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
