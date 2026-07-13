import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/model/tag.dart";

enum TagChoiceOption { none, existing, create }

class TagChoice extends StatefulWidget {
  final Map<int, Tag> tags;

  const TagChoice({super.key, required this.tags});

  @override
  State<TagChoice> createState() => _TagChoiceState();
}

class _TagChoiceState extends State<TagChoice> {
  TagChoiceOption selected = .existing;
  final textEditController = TextEditingController();

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagItems = [
      for (final tag in widget.tags.values)
        DropdownMenuEntry(value: tag, label: tag.name),
    ];

    return Column(
      children: [
        SizedBox(
          child: SegmentedButton(
            segments: [
              ButtonSegment(
                value: TagChoiceOption.none,
                label: Text("Žádný"),
                icon: Icon(Icons.cancel_outlined),
              ),
              ButtonSegment(
                value: TagChoiceOption.existing,
                label: Text("Existující"),
                icon: Icon(Icons.tag),
              ),
              ButtonSegment(
                value: TagChoiceOption.create,
                label: Text("Nový"),
                icon: Icon(Icons.add),
              ),
            ],
            selected: {selected},
            onSelectionChanged: (final newSelection) {
              setState(() {
                selected = newSelection.first;
              });
            },
            expandedInsets: EdgeInsets.zero,
            emptySelectionAllowed: false,
            multiSelectionEnabled: false,
            showSelectedIcon: false,
          ),
        ),
        SizedBox(height: DialogCommon.bodyMarginBottom),
        switch (selected) {
          TagChoiceOption.none => Text("..."),
          TagChoiceOption.existing => DropdownMenu(
            dropdownMenuEntries: tagItems,
            expandedInsets: EdgeInsets.zero,
            //selectOnly: true,
            enableFilter: true,
            controller: textEditController,
          ),
          TagChoiceOption.create => TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Název tagu",
            ),
            //controller: textEditController,
          ),
        },
        TextButton(onPressed: () {
          debugPrint("> ${textEditController.text}");
        }, child: Text("HUH")),
      ],
    );
  }
}
