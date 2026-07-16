import "package:flutter/material.dart";
import "package:my_beer_diary/model/beer.dart";

class BeerCard extends StatelessWidget {
  final Beer beer;

  const BeerCard({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${beer.breweryName} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(beer.description, style: TextStyle(fontSize: 20)),
                  ],
                ),
                Text(
                  "${beer.epm}° @ ${beer.abv} %",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
