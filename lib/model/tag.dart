// Event can have one tag associated with it, eg. name of the pub (#Azyl) or activity (#čundr).
// User can assign same tag to multiple events to categorize them.

import "package:flutter/foundation.dart";
import "package:my_beer_diary/db.dart";
import "package:my_beer_diary/model/event.dart";
import "package:sqflite/sqlite_api.dart";

const String tagTable = "Tags";
const String tagColId = "_id";
const String tagColName = "name";
const String tagColColor = "color";

const String tagTableCreate =
    "CREATE TABLE $tagTable ("
    "$tagColId INTEGER PRIMARY KEY AUTOINCREMENT," // Surrogate key
    "$tagColName TEXT NOT NULL UNIQUE," // Name of the tag
    "$tagColColor TEXT NOT NULL" // Background color of the chip
    ")";

const String tagTableDrop = "DROP TABLE IF EXISTS $tagTable";

class Tag {
  final int? id;
  final String name;
  final String color;

  const Tag({this.id, required this.name, required this.color});

  Map<String, Object?> toMap() {
    return {tagColId: id, tagColName: name, tagColColor: color};
  }

  static Tag fromMap(Map<String, Object?> m) => Tag(
    id: m[tagColId] as int?,
    name: m[tagColName] as String,
    color: m[tagColColor] as String,
  );

  Tag copyWith({
    int? Function()? id,
    String Function()? name,
    String Function()? color,
  }) => Tag(
    id: id != null ? id() : this.id,
    name: name != null ? name() : this.name,
    color: color != null ? color() : this.color,
  );

  @override
  String toString() => "id=$id, name=$name, color=$color";
}

Future<int> tagAdd(Tag tag) async {
  final db = await AppDatabase.instance.database;
  final result = await db.insert(
    tagTable,
    tag.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );

  if (result != 0) {
    return result;
  }

  // Result==0 => tag with this name already exists (UNIQUE)
  final existing = await db.query(
    tagTable,
    columns: [tagColId],
    where: "$tagColName = ?",
    whereArgs: [tag.name],
    limit: 1,
  );

  if (existing.isNotEmpty) {
    return existing.first[tagColId] as int;
  }

  return 0;
}

Future<List<Tag>> tagList() async {
  const orderBy = "$tagColName ASC";
  final db = await AppDatabase.instance.database;
  final maps = await db.query(tagTable, orderBy: orderBy);
  return [for (final m in maps) Tag.fromMap(m)];
}

/*
Future<Map<int, Tag>> tagMap() async {
  final db = await AppDatabase.instance.database;
  final maps = await db.query(tagTable);
  return {for (final m in maps) m[tagColId] as int: Tag.fromMap(m)};
}
*/

Future<void> tagUpdate(Tag tag) async {
  final db = await AppDatabase.instance.database;
  await db.update(
    tagTable,
    tag.toMap(),
    where: "$tagColId = ?",
    whereArgs: [tag.id],
    // conflictAlgorithm is needed because UNIQUE name constraint
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<void> tagDelete(int id) async {
  final db = await AppDatabase.instance.database;
  await db.delete(tagTable, where: "$tagColId = ?", whereArgs: [id]);

  // Set fkTagId to NULL in Events table
  await db.update(
    eventTable,
    {eventColTagId: null},
    where: "$eventColTagId = ?",
    whereArgs: [id],
  );
}

class TagNotifier extends ChangeNotifier {
  List<Tag> itemList = [];
  Map<int, Tag> itemMap = {};

  Future<void> refresh() async {
    itemList = await tagList();
    itemMap = {
      for (final item in itemList)
        if (item.id != null) item.id!: item,
    };

    notifyListeners();
  }
}
