import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/tag_add_edit.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/tag_chip.dart";

class TagCard extends StatelessWidget {
  final Tag tag;
  final VoidCallback refreshTags;

  const TagCard({super.key, required this.tag, required this.refreshTags});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            // = Tag name =
            TagChip(tagName: tag.name),
            Spacer(),
            // = Edit button =
            IconButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => TagAddEditDialog(tag: tag),
                );
                if (result ?? false) {
                  refreshTags();
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
                      "Opravdu si přejete smazat tag „#${tag.name}“?\nUdálosti s tímto tagem budou zachovány.",
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
                  refreshTags();
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
