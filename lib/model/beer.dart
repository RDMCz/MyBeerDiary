// Beers can be reused in multiple events and in the one-off page

const String _beerTable = "Beers";
const String _beerColId = "_id";
const String _beerColBreweryName = "breweryName";
const String _beerColDescription = "description";
const String _beerColEPM = "epm";
const String _beerColABV = "abv";
const String _beerColColor = "color";

const String beerTableCreate =
    "CREATE TABLE $_beerTable ("
    "$_beerColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$_beerColBreweryName TEXT NOT NULL,"
    "$_beerColDescription TEXT NOT NULL,"
    "$_beerColEPM REAL NOT NULL,"
    "$_beerColABV REAL NOT NULL,"
    "$_beerColColor TEXT NOT NULL"
    ")";

class Beer {
  final int? id;
  final String breweryName;
  final String description;
  final double epm;
  final double abv;
  final String color;

  Beer({
    this.id,
    required this.breweryName,
    required this.description,
    required this.epm,
    required this.abv,
    required this.color,
  });

  Map<String, Object?> toMap() {
    return {
      _beerColId: id,
      _beerColBreweryName: breweryName,
      _beerColDescription: description,
      _beerColEPM: epm,
      _beerColABV: abv,
      _beerColColor: color,
    };
  }
}
