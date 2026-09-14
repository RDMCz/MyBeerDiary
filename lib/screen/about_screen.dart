import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:url_launcher/url_launcher.dart" show launchUrl;

final Uri githubURL = Uri.parse("https://github.com/RDMCz/MyBeerDiary");

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("O aplikaci")),
      body: Padding(
        padding: CardListCommon.horizontalPaddingOnly,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "\nMůj pivní deníček\n",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
              ),
              DefaultTextStyle.merge(
                style: TextStyle(fontSize: 16.0),
                child: Column(
                  children: [
                    Text("verze 0.1.0\n"),
                    InkWell(
                      onTap: () async => await launchUrl(githubURL),
                      child: Text(
                        "github.com/RDMCz/MyBeerDiary",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blueAccent
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
