// Event can have one tag associated with it, eg. name of the pub (#Azyl) or activity (#čundr).
// User can assign same tag to multiple events to categorize them.

import "package:my_beer_diary/db.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

const String _tagTable = "Tags";
const String _tagColId = "_id";
const String _tagColName = "name";
const String _tagColPictureId = "pictureId";

const String tagTableCreate =
    "CREATE TABLE $_tagTable ("
    "$_tagColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$_tagColName TEXT NOT NULL UNIQUE," // Name of the tag
    "$_tagColPictureId TEXT" // User can assign a stock picture to a tag
    ")";

const String tagTableDrop = "DROP TABLE IF EXISTS $_tagTable";

class Tag {
  final int? id;
  final String name;
  final String? pictureId;

  Tag({this.id, required this.name, this.pictureId});

  Map<String, Object?> toMap() {
    return {_tagColId: id, _tagColName: name, _tagColPictureId: pictureId};
  }

  static Tag fromMap(Map<String, Object?> m) => Tag(
    id: m[_tagColId] as int?,
    name: m[_tagColName] as String,
    pictureId: m[_tagColPictureId] as String?,
  );

  Tag copyWith({
    int? Function()? id,
    String Function()? name,
    String? Function()? pictureId,
  }) => Tag(
    id: id != null ? id() : this.id,
    name: name != null ? name() : this.name,
    pictureId: pictureId != null ? pictureId() : this.pictureId,
  );

  @override
  String toString() => "id=$id, name=$name, pictureId=$pictureId";
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

Future<Map<int, Tag>> tagMap() async {
  final db = await AppDatabase.instance.database;
  final maps = await db.query(_tagTable);
  return {for (final m in maps) m[_tagColId] as int: Tag.fromMap(m)};
}

Future<void> tagUpdate(Tag tag) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    _tagTable,
    tag.toMap(),
    where: "$_tagColId = ?",
    whereArgs: [tag.id],
    // conflictAlgorithm is needed because UNIQUE name constraint
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<void> tagDelete(int id) async {
  final db = await AppDatabase.instance.database;
  await db.delete(_tagTable, where: "$_tagColId = ?", whereArgs: [id]);
  //TODO smaž z eventů
}
