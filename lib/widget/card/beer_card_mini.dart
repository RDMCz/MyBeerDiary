// Selecting this card allows user to reference existing beer in [BeerConsumptionDialog]

import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";
import "package:my_beer_diary/model/beer.dart";
import "package:my_beer_diary/widget/svg_icon.dart";

class BeerCardMini extends StatelessWidget {
  final Beer beer;
  final bool isSelected;
  final VoidCallback onTap;

  const BeerCardMini({
    super.key,
    required this.beer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: CardCommon.miniPadding,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${beer.breweryName} ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),

                  Text(beer.description, style: TextStyle(fontSize: 17)),

                  Text(
                    "${beer.epm}° @ ${beer.abv} %",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(width: 12),

              Stack(
                alignment: AlignmentGeometry.bottomRight,
                children: [
                  SvgCardIcon(icon: SvgCardIcons.beerLarge, color: beer.color),
                  IgnorePointer(
                    // Checkbox checking is handled on InkWell tapping, hence the empty function here
                    child: Checkbox(value: isSelected, onChanged: (_) {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
