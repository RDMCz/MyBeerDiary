class EventStats {
  //
  final double maxPermille;
  final int soberTimestamp;
  final double totalLitres;
  final double durationHours;
  //
  final double averageEPM;
  final double averageABV;
  //
  final List<MapEntry<bool, int>> topIsDrafts;
  final List<MapEntry<String, int>> topBreweryNames;
  final List<MapEntry<String, int>> topDescriptions;
  final List<MapEntry<String, int>> topColors;
  final List<MapEntry<int?, int>> topBeerIds;
  //
  final List<(int, double)> chartPoints;
  final int durationWithSoberingHours;

  const EventStats({
    //
    required this.maxPermille,
    required this.soberTimestamp,
    required this.totalLitres,
    required this.durationHours,
    //
    required this.averageEPM,
    required this.averageABV,
    //
    required this.topIsDrafts,
    required this.topBreweryNames,
    required this.topDescriptions,
    required this.topColors,
    required this.topBeerIds,
    //
    required this.chartPoints,
    required this.durationWithSoberingHours,
  });
}
