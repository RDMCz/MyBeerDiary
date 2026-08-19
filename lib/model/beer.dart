// Beers can be reused in multiple events and in the one-off page

import "package:flutter/material.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/db.dart";
import "package:my_beer_diary/logic/alcohol.dart";
import "package:my_beer_diary/model/beer_consumption.dart";

const String beerTable = "Beers";
const String beerColId = "_id";
const String beerColBreweryName = "breweryName";
const String beerColDescription = "description";
const String beerColEPM = "epm";
const String beerColABV = "abv";
const String beerColColor = "color";

const String beerTableCreate =
    "CREATE TABLE $beerTable ("
    "$beerColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$beerColBreweryName TEXT NOT NULL,"
    "$beerColDescription TEXT NOT NULL,"
    "$beerColEPM REAL NOT NULL,"
    "$beerColABV REAL NOT NULL,"
    "$beerColColor TEXT NOT NULL"
    ")";

const String beerTableDrop = "DROP TABLE IF EXISTS $beerTable";

class Beer {
  final int? id;
  final String breweryName;
  final String description;
  final double epm;
  final double abv;
  final String color;

  const Beer({
    this.id,
    required this.breweryName,
    required this.description,
    required this.epm,
    required this.abv,
    required this.color,
  });

  Map<String, Object?> toMap() {
    return {
      beerColId: id,
      beerColBreweryName: breweryName,
      beerColDescription: description,
      beerColEPM: epm,
      beerColABV: abv,
      beerColColor: color,
    };
  }

  static Beer fromMap(Map<String, Object?> m) => Beer(
    id: m[beerColId] as int?,
    breweryName: m[beerColBreweryName] as String,
    description: m[beerColDescription] as String,
    epm: m[beerColEPM] as double,
    abv: m[beerColABV] as double,
    color: m[beerColColor] as String,
  );

  Beer copyWith({
    int? Function()? id,
    String Function()? breweryName,
    String Function()? description,
    double Function()? epm,
    double Function()? abv,
    String Function()? color,
  }) => Beer(
    id: id != null ? id() : this.id,
    breweryName: breweryName != null ? breweryName() : this.breweryName,
    description: description != null ? description() : this.description,
    epm: epm != null ? epm() : this.epm,
    abv: abv != null ? abv() : this.abv,
    color: color != null ? color() : this.color,
  );

  @override
  String toString() =>
      "id=$id, breweryName=$breweryName, description=$description, epm=$epm, abv=$abv, color=$color";

  String toDisplayString() =>
      switch ((breweryName.isNotEmpty, description.isNotEmpty)) {
        (false, false) => "",
        (false, true) => description,
        (true, false) => breweryName,
        (true, true) => "$breweryName $description",
      };

  // Fallback beer if can't find proper one in DB (shouldn't happen)
  static const Beer unknownBeer = Beer(
    breweryName: "Neznámé pivo",
    description: "",
    epm: 11.0,
    abv: 4.4,
    color: beerColorGoldStr,
  );

  // If user does not fill these fields, default values will be used
  static double epmOrDefault(String s) =>
      s.isNotEmpty ? textFieldToDouble(s) : unknownBeer.epm;

  static double abvOrDefault(String s) =>
      s.isNotEmpty ? textFieldToDouble(s) : unknownBeer.abv;
}

Future<int> beerAdd(Beer beer) async {
  final db = await AppDatabase.instance.database;
  return await db.insert(beerTable, beer.toMap());
}

Future<List<Beer>> beerList() async {
  const orderBy =
      "$beerColBreweryName ASC, $beerColEPM ASC, $beerColDescription ASC";

  final db = await AppDatabase.instance.database;
  final maps = await db.query(beerTable, orderBy: orderBy);
  return [for (final m in maps) Beer.fromMap(m)];
}

/*
Future<Map<int, Beer>> beerMap() async {
  final db = await AppDatabase.instance.database;
  final maps = await db.query(beerTable);
  return {for (final m in maps) m[beerColId] as int: Beer.fromMap(m)};
}
*/

Future<void> beerUpdate(Beer beer) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    beerTable,
    beer.toMap(),
    where: "$beerColId = ?",
    whereArgs: [beer.id],
  );
}

/*
Future<void> beerDelete(int id) async {
  final db = await AppDatabase.instance.database;
  await db.delete(beerTable, where: "$beerColId = ?", whereArgs: [id]);

  await db.update(
    beerConsumptionTable,
    {beerConsumptionColBeerId: null},
    where: "$beerConsumptionColBeerId = ?",
    whereArgs: [id],
  );
}
*/

class BeerNotifier extends ChangeNotifier {
  List<Beer> itemList = [];
  Map<int, Beer> itemMap = {};

  Future<void> refresh() async {
    itemList = await beerList();
    itemMap = {
      for (final item in itemList)
        if (item.id != null) item.id!: item,
    };

    notifyListeners();
  }
}
