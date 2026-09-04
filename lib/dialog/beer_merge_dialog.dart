// Dialog to "merge" beers: deletes some beer A and sets all beer consumptions of beer A to some other beer B

import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:provider/provider.dart";

class BeerMergeDialog extends StatefulWidget {
  final Beer beer;

  const BeerMergeDialog({super.key, required this.beer});

  @override
  State<BeerMergeDialog> createState() => _BeerMergeDialogState();
}

class _BeerMergeDialogState extends State<BeerMergeDialog> {
  int? selectedBeerId;

  @override
  Widget build(BuildContext context) {
    final beers = context.read<BeerNotifier>().itemList;

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
            Text("Sloučit pivo", style: DialogCommon.headerStyle),
            SizedBox(height: DialogCommon.headerMarginBottom),

            // = Explanation text =
            Text(
              "Toto pivo bude smazáno a záznamy o jeho vypití budou přenastaveny na pivo vybrané níže:",
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Form body =
            SizedBox(
              height: 200.0,
              child: RadioGroup<int?>(
                groupValue: selectedBeerId,
                onChanged: (int? value) {
                  setState(() {
                    selectedBeerId = value;
                  });
                },
                child: ListView.builder(
                  itemCount: beers.length,
                  itemBuilder: (_, int idx) {
                    final radioBeer = beers[idx];
                    return RadioListTile(
                      title: Text(radioBeer.toDisplayString()),
                      value: radioBeer.id,
                      enabled: radioBeer.id != widget.beer.id,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: DialogCommon.bodyMarginBottom),

            // = Buttons =
            Row(
              children: [
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
                  onPressed: selectedBeerId == null
                      ? null
                      : () async {
                          if (widget.beer.id == null ||
                              selectedBeerId == null) {
                            return;
                          }

                          await beerMerge(widget.beer.id!, selectedBeerId!);

                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        },
                  child: Text("Sloučit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
