int secondsSinceEpoch() =>
    DateTime.now().toUtc().millisecondsSinceEpoch ~/
    Duration.millisecondsPerSecond;

DateTime _secondsToDateTime(int s) =>
    DateTime.fromMillisecondsSinceEpoch(s * Duration.millisecondsPerSecond);

String secondsToDateString(int s) {
  final date = _secondsToDateTime(s);
  return "${date.day}. ${date.month}. ${date.year}";
}

String secondsToDateTimeString(int s) {
  final date = _secondsToDateTime(s);
  return "${date.day}. ${date.month}. ${date.year} – ${date.hour}:${date.minute.toString().padLeft(2, "0")}";
}
