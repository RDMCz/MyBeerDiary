import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/db.dart";
import "package:my_beer_diary/widget/text_divider.dart";
import "package:url_launcher/url_launcher.dart" show launchUrl;

final Uri githubURL = Uri.parse("https://github.com/RDMCz/MyBeerDiary");

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("O aplikaci")),
      body: SingleChildScrollView(
        child: Padding(
          padding: CardListCommon.horizontalPaddingOnly,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  "\nMůj pivní deníček\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                ),
                Image.asset("asset/icon/appicon.png", height: 150),
                DefaultTextStyle.merge(
                  style: TextStyle(fontSize: 16.0),
                  child: Column(
                    children: [
                      Text("\nverze 0.1.0\n"),
                      InkWell(
                        onTap: () async => await launchUrl(githubURL),
                        child: Text(
                          "github.com/RDMCz/MyBeerDiary",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      if (!kIsWeb) ...[
                        TextDivider(text: "ZÁLOHA DATABÁZE"),
                        Text(
                          "Přecházíte-li na nové zařízení, je možné do něj zkopírovat svá pivní data."
                          "\n1. Na starém zařízení zálohujte databázi do souboru"
                          "\n2. Soubor si pošlete do nového zařízení"
                          "\n3. Na novém zařízení obnovte databázi z tohoto souboru",
                        ),
                        SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: () async {
                            final dbBytes = await AppDatabase.instance
                                .exportBytes();
                            await FilePicker.saveFile(
                              dialogTitle: "Záloha databáze",
                              fileName: "MujPivniDenicek_Zaloha.db",
                              bytes: dbBytes,
                            );
                          },
                          label: Text("Zálohovat databázi do souboru"),
                          icon: Icon(Icons.backup_outlined),
                        ),
                        TextButton.icon(
                          onPressed: null,
                          label: Text("Obnovit databázi ze souboru"),
                          icon: Icon(Icons.restore),
                        ),
                      ],
                    ],
                  ),
                ),
                // (Some empty space at the end so the last text isn't near the screen edge)
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
