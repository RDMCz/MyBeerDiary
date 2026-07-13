import "package:flutter/material.dart";
import "package:my_beer_diary/dialog/dialog_common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";

enum EventTagScenario { noTag, useExisting, createNew }

class EventAddDialog extends StatefulWidget {
  final Map<int, Tag> tags;

  const EventAddDialog({super.key, required this.tags});

  @override
  State<EventAddDialog> createState() => _EventAddDialogState();
}

class _EventAddDialogState extends State<EventAddDialog> {
  final nameTextEditController = TextEditingController();
  final tagTextEditController = TextEditingController();
  Tag? selectedTag;

  @override
  void initState() {
    super.initState();
    nameTextEditController.addListener(() => setState(() {}));
    tagTextEditController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameTextEditController.dispose();
    tagTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagItems = [
      for (final tag in widget.tags.values)
        DropdownMenuEntry(value: tag, label: tag.name),
    ];

    final nameTextTrim = nameTextEditController.text.trim();
    final tagTextTrim = tagTextEditController.text.trim();

    final isValid = nameTextTrim.isNotEmpty || tagTextTrim.isNotEmpty;

    final EventTagScenario tagScenario = tagTextTrim.isEmpty
        ? .noTag // No tag will be assigned to this event because textfield is empty
        : selectedTag != null && tagTextTrim == selectedTag!.name
        ? .useExisting // User selected tag from list and haven't edited it, so existing tag will be used
        : .createNew; // User typed into empty textfield or edited name of selected tag, so new tag will be created
    // "Edge" case: user selects tag and then rewrites textfield to another valid tag name, this is handled in [tagAdd] method

    return Dialog(
      insetPadding: DialogCommon.insetPadding,
      shape: DialogCommon.shape,
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text("Nová událost", style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název události",
              ),
              controller: nameTextEditController,
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            DropdownMenu(
              dropdownMenuEntries: tagItems,
              expandedInsets: EdgeInsets.zero,
              enableFilter: true,
              controller: tagTextEditController,
              label: Text("Tag události"),
              onSelected: (Tag? tag) {
                setState(() {
                  selectedTag = tag;
                });
              },
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom / 2),

            Text(switch (tagScenario) {
              EventTagScenario.noTag => "Události nebude přidělen žádný tag.",
              EventTagScenario.useExisting =>
                "Události bude přidělen existující tag „#${selectedTag!.name}“.",
              EventTagScenario.createNew =>
                "Pro událost bude vytvořen nový tag „#$tagTextTrim“.",
            }),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Buttons =
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // = Button :: Cancel =
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Zrušit"),
                ),
                SizedBox(width: DialogCommon.buttonSpace),

                // = Button :: Confirm =
                TextButton(
                  onPressed: !isValid
                      ? null
                      : () async {
                          final int? tagId = switch (tagScenario) {
                            EventTagScenario.noTag => null,
                            EventTagScenario.useExisting => selectedTag!.id,
                            EventTagScenario.createNew => await tagAdd(
                              Tag(name: tagTextTrim),
                            ),
                          };

                          await eventAdd(
                            Event(
                              name: nameTextTrim,
                              tagId: tagId,
                              timestamp: secondsSinceEpoch(),
                              totalBeers: 0,
                              totalCost: 0,
                            ),
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        },
                  child: Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
