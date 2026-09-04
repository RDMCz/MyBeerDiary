// Selecting this card allows user to add new beer in [BeerConsumptionDialog]

import "package:flutter/material.dart";
import "package:my_beer_diary/common.dart";

class BeerCardMiniNew extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const BeerCardMiniNew({
    super.key,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nové pivo ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),                  
                  Text("Přidat nové pivo od\nzadaného pivovaru"),
                ],
              ),
              IgnorePointer(
                child: Checkbox(
                  value: isSelected,
                  // Checkbox checking is handled on InkWell tapping, hence the empty function here
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
