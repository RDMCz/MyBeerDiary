class EventStats {
  //final int nBeers; // Already stored in event
  final double maxPermille;
  final int soberTimestamp;
  final double totalLitres;
  final double durationHours;
  //
  final double averageEPM;
  final double averageABV;

  const EventStats({
    //required this.nBeers,
    required this.maxPermille,
    required this.soberTimestamp,
    required this.totalLitres,
    required this.durationHours,
    //
    required this.averageEPM,
    required this.averageABV,
  });
}
