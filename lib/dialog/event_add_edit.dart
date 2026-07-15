import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/logic/time.dart";
import "package:my_beer_diary/model/event.dart";
import "package:my_beer_diary/model/tag.dart";

enum EventTagScenario { noTag, useExisting, createNew }

class EventAddEditDialog extends StatefulWidget {
  final Map<int, Tag> tags;
  final Event? event; // Determines the dialog variant (add/edit)

  const EventAddEditDialog({super.key, required this.tags, this.event});

  @override
  State<EventAddEditDialog> createState() => _EventAddEditDialogState();
}

class _EventAddEditDialogState extends State<EventAddEditDialog> {
  final nameTextEditController = TextEditingController();
  final tagTextEditController = TextEditingController();
  Tag? selectedTag;
  // To detect if there were any changes in edit dialog variant
  String initialTagName = "";

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      nameTextEditController.text = widget.event!.name;
      final tagId = widget.event!.tagId;
      if (widget.tags.containsKey(tagId)) {
        selectedTag = widget.tags[tagId];
        tagTextEditController.text = selectedTag!.name;
        initialTagName = selectedTag!.name;
      }
    }

    nameTextEditController.addListener(() => setState(() {}));
    tagTextEditController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameTextEditController.dispose();
    tagTextEditController.dispose();
    super.dispose();
  }

  Future<int?> resolveProperTagId(
    EventTagScenario tagScenario,
    String tagTextTrim,
  ) async {
    return switch (tagScenario) {
      EventTagScenario.noTag => null,
      EventTagScenario.useExisting => selectedTag!.id,
      EventTagScenario.createNew => await tagAdd(Tag(name: tagTextTrim)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.event != null;
    final headerActionText = isEdit ? "Upravit" : "Nová";
    final buttonActionText = isEdit ? "Potvrdit" : "OK";

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
            Text("$headerActionText událost", style: DialogCommon.headerStyle),
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
              requestFocusOnTap: true,
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
              children: [
                // = Button :: Delete =
                if (isEdit)
                  TextButton(
                    onPressed: () async {
                      if (widget.event!.id == null) {
                        return;
                      }

                      final tag = widget.event!.tagId != null
                          ? "#${widget.event!.tagId} "
                          : "";

                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Smazat událost"),
                          content: Text(
                            "Opravdu si přejete smazat „$tag${widget.event!.name}“?",
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
                        await eventDelete(widget.event!.id!);
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      }
                    },
                    child: Text("Smazat"),
                  ),

                Spacer(),

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
                      ? null // Either event name or tag must be non-null, disable confirm button otherwise
                      : !isEdit
                      // .: Adding new event :.
                      ? () async {
                          // Get proper tag ID
                          final tagId = await resolveProperTagId(
                            tagScenario,
                            tagTextTrim,
                          );
                          // Write event to DB
                          await eventAdd(
                            Event(
                              name: nameTextTrim,
                              tagId: tagId,
                              timestamp: secondsSinceEpoch(),
                              totalBeers: 0,
                              totalCost: 0,
                            ),
                          );
                          // Close the dialog
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      // .: Editing existing event :.
                      : () async {
                          final isNameChange =
                              widget.event!.name != nameTextTrim;

                          final isTagNameChange = initialTagName != tagTextTrim;

                          if (!isNameChange && !isTagNameChange) {
                            // No changes
                            Navigator.of(context).pop(false);
                          } else {
                            // Get proper tag ID
                            final tagId = await resolveProperTagId(
                              tagScenario,
                              tagTextTrim,
                            );
                            // Write update do DB
                            await eventUpdate(
                              widget.event!.copyWith(
                                name: () => nameTextTrim,
                                tagId: () => tagId,
                              ),
                            );
                            // Close the dialog
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          }
                        },
                  child: Text(buttonActionText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
