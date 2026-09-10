/// Returns unix timestamp in seconds for given datetime [dt]
int dateTimeToSeconds(DateTime dt) =>
    dt.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

/// Returns current unix timestamp in seconds
int secondsSinceEpoch() => dateTimeToSeconds(DateTime.now().toUtc());

/// Returns DateTime object for given unix timestamp in seconds
DateTime secondsToDateTime(int s) => DateTime.fromMillisecondsSinceEpoch(
  s * Duration.millisecondsPerSecond,
  isUtc: false,
);

/// Returns "DD. MM. YYYY" String for given unix timestamp in seconds
String secondsToDateString(int s) {
  final date = secondsToDateTime(s);
  return "${date.day}. ${date.month}. ${date.year}";
}

/// Returns "DD. MM. YYYY – hh:mm" String for given unix timestamp in seconds
String secondsToDateTimeString(int s) {
  final date = secondsToDateTime(s);
  return "${date.day}. ${date.month}. ${date.year} – ${date.hour}:${date.minute.toString().padLeft(2, "0")}";
}

/// Returns "hh:mm" String for given unix timestamp in seconds
String secondsToTimeString(int s) {
  final date = secondsToDateTime(s);
  return "${date.hour}:${date.minute.toString().padLeft(2, "0")}";
}

/// Returns "DD. MM." String for given unix timestamp in seconds
String secondsToDayMonthString(int s) {
  final date = secondsToDateTime(s);
  return "${date.day}. ${date.month}.";
}
