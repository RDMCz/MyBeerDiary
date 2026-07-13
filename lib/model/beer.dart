// Beers can be reused in multiple events and in the one-off page

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

  @override
  String toString() =>
      "id=$id, breweryName=$breweryName, description=$description, epm=$epm, abv=$abv, color=$color";
}
