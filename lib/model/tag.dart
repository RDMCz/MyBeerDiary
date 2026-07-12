// Event can have one tag associated with it, eg. name of the pub (#Azyl) or activity (#čundr).
// User can assign same tag to multiple events to categorize them.

import "package:my_beer_diary/db.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

const String _tagTable = "Tags";
const String _tagColName = "name";
const String _tagColPictureId = "pictureId";

const String tagTableCreate =
    "CREATE TABLE $_tagTable ("
    "$_tagColName TEXT PRIMARY KEY," // Name of the tag
    "$_tagColPictureId TEXT" // User can assign a stock picture to a tag
    ")";

class Tag {
  final String name;
  final String? pictureId;

  Tag({required this.name, this.pictureId});

  Map<String, Object?> toMap() {
    return {_tagColName: name, _tagColPictureId: pictureId};
  }

  static Tag fromMap(Map<String, Object?> m) => Tag(
    name: m[_tagColName] as String,
    pictureId: m[_tagColPictureId] as String?,
  );

  @override
  String toString() => "name=$name, pictureId=$pictureId";
}

Future<void> tagAdd(Tag tag) async {
  final db = await AppDatabase.instance.database;
  await db.insert(
    _tagTable,
    tag.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<List<Tag>> tagList() async {
  const orderBy = "$_tagColName ASC";

  final db = await AppDatabase.instance.database;
  final maps = await db.query(_tagTable, orderBy: orderBy);
  return [for (final m in maps) Tag.fromMap(m)];
}

Future<void> tagUpdate(Tag tag) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    _tagTable,
    tag.toMap(),
    where: "$_tagColName = ?",
    whereArgs: [tag.name],
  );
  //TODO změň u eventů
}

Future<void> tagDelete(String name) async {
  final db = await AppDatabase.instance.database;
  await db.delete(_tagTable, where: "$_tagColName = ?", whereArgs: [name]);
  //TODO smaž z eventů
}
