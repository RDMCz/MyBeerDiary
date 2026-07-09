// Event can have one tag associated with it, eg. name of the pub (#Azyl) or activity (#čundr).
// User can assign same tag to multiple events to categorize them.

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
}
