int secondsSinceEpoch() =>
    DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
