// Dialog to edit user settings

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
  final birthyearTEC = TextEditingController();
  final heightTEC = TextEditingController();
  final weightTEC = TextEditingController();

  Future<void> _init() async {
    final userSettings = await userSettingsGet();
    setState(() {
      isMale = userSettings.isMale;
      birthyearTEC.text = userSettings.birthyear.toString();
      heightTEC.text = userSettings.height.toString();
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
    birthyearTEC.dispose();
    heightTEC.dispose();
    weightTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 12.0 from DialogCommon.bodyMarginBottom feels to little here...
    const marginBottom = 15.0;

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
            SizedBox(height: marginBottom),

            // = Birthyear =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Rok narození",
              ),
              controller: birthyearTEC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: marginBottom),

            // = height =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Výška v centimetrech",
                suffixText: "cm",
              ),
              controller: heightTEC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: marginBottom),

            // = Weight =
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Váha v kilogramech",
                suffixText: "kg",
              ),
              controller: weightTEC,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: marginBottom),

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
                        birthyear:
                            int.tryParse(birthyearTEC.text) ??
                            UserSettings.defaultUserSettings.birthyear,
                        height:
                            int.tryParse(heightTEC.text) ??
                            UserSettings.defaultUserSettings.height,
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
