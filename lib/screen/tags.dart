import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/dialog/tag_add_edit.dart";
import "package:my_beer_diary/model/tag.dart";
import "package:my_beer_diary/widget/tag_card.dart";

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  List<Tag> _tags = [];

  Future<void> _refreshTags() async {
    final tags = await tagList();
    setState(() {
      _tags = tags;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Správa tagů")),
      body: ListView.builder(
        padding: CardListCommon.listPadding,
        itemCount: _tags.length,
        itemBuilder: (_, int idx) => Padding(
          padding: CardListCommon.itemPadding,
          child: TagCard(tag: _tags[idx], refreshTags: _refreshTags),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => TagAddEditDialog(),
          );
          if (result ?? false) {
            _refreshTags();
          }
        },
        tooltip: "Přidat nový tag",
        child: Icon(Icons.add),
      ),
    );
  }
}
