/// Returns unix timestamp in seconds
int secondsSinceEpoch() =>
    DateTime.now().toUtc().millisecondsSinceEpoch ~/
    Duration.millisecondsPerSecond;

/// Returns DateTime object for given unix timestamp in seconds
DateTime secondsToDateTime(int s) =>
    DateTime.fromMillisecondsSinceEpoch(s * Duration.millisecondsPerSecond);

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
