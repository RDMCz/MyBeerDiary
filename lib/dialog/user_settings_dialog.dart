import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/user_settings.dart";

class UserSettingsDialog extends StatefulWidget {
  const UserSettingsDialog({super.key});

  @override
  State<UserSettingsDialog> createState() => _UserSettingsDialogState();
}

class _UserSettingsDialogState extends State<UserSettingsDialog> {
  bool isMale = UserSettings.defaultUserSettings.isMale;
  final weightTEC = TextEditingController();

  Future<void> _init() async {
    final userSettings = await userSettingsGet();
    setState(() {
      isMale = userSettings.isMale;
      weightTEC.text = userSettings.weight.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    weightTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: DialogCommon.insetPadding,
      shape: DialogCommon.shape,
      child: Padding(
        padding: DialogCommon.contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // = Header =
            Text("Nastavení uživatele", style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Gender =
            SegmentedButton(
              segments: [
                ButtonSegment(
                  value: true,
                  label: Text("Muž"),
                  icon: Icon(Icons.male),
                ),
                ButtonSegment(
                  value: false,
                  label: Text("Žena"),
                  icon: Icon(Icons.female),
                ),
              ],
              selected: {isMale},
              onSelectionChanged: (final newSelection) {
                setState(() {
                  isMale = newSelection.first;
                });
              },
              expandedInsets: EdgeInsets.zero,
              emptySelectionAllowed: false,
              multiSelectionEnabled: false,
              showSelectedIcon: false,
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Weight =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Váha v kilogramech",
                suffixText: "Kg",
              ),
              controller: weightTEC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
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
                  onPressed: () async {
                    await userSettingsSet(
                      UserSettings(
                        isMale: isMale,
                        weight:
                            int.tryParse(weightTEC.text) ??
                            UserSettings.defaultUserSettings.weight,
                      ),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text("Uložit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
