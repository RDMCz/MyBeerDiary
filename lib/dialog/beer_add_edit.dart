import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";

class BeerAddEditDialog extends StatefulWidget {
  const BeerAddEditDialog({super.key});

  @override
  State<BeerAddEditDialog> createState() => _BeerAddEditDialogState();
}

class _BeerAddEditDialogState extends State<BeerAddEditDialog> {
  @override
  Widget build(BuildContext context) {
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
            Text("Přidat pivo", style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Form body =
            // - breweryName
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název pivovaru",
              ),
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            // - description
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Název/styl/popis piva",
              ),
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),
            Row(
              children: [
                // - epm
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Stupňovitost",
                    ),
                  ),
                ),
                //SizedBox(width: 12),
                Text("⇝", style: TextStyle(fontSize: 40)),
                //SizedBox(width: 12),
                // - abv
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Alkohol",
                    ),
                  ),
                ),
              ],
            ),

            // - color

            // = Buttons =
          ],
        ),
      ),
    );
  }
}
