import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/time.dart";

class AlcoholChart extends StatelessWidget {
  final List<(int, double)> chartPoints;
  final int durationHours;

  const AlcoholChart({
    super.key,
    required this.chartPoints,
    required this.durationHours,
  });

  @override
  Widget build(BuildContext context) {
    const hideAxisTitles = AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    );

    final currentTimestamp = secondsSinceEpoch();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            // Points
            spots: [
              for (final point in chartPoints)
                FlSpot(point.$1.toDouble(), point.$2),
            ],
            // Do not show dots at points
            dotData: FlDotData(show: false),
            // Chart visuals
            color: Colors.red,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.2),
                  Colors.orange.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ],
        // Axis labels
        titlesData: FlTitlesData(
          //
          topTitles: hideAxisTitles,
          //
          rightTitles: hideAxisTitles,
          //
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              minIncluded: false,
              maxIncluded: false,
            ),
          ),
          //
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval:
                  ((durationHours / (MediaQuery.sizeOf(context).width / 80)) *
                          Duration.secondsPerHour)
                      .toDouble(),
              reservedSize: 44,
              minIncluded: false,
              maxIncluded: false,
              getTitlesWidget: (value, meta) {
                final date = secondsToDateTime(value.round());
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    "${date.hour}:${date.minute.toString().padLeft(2, "0")}\n${date.day}. ${date.month}.",
                  ),
                );
              },
            ),
          ),
        ),
        // Popup
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => appColorInverseSurface,
            getTooltipItems: (touchedSpots) => [
              for (final spot in touchedSpots)
                LineTooltipItem(
                  "${spot.y.toStringAsFixed(2)} ‰",
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          getTouchedSpotIndicator: (_, spotIndexes) => [
            for (final spot in spotIndexes)
              TouchedSpotIndicatorData(
                FlLine(strokeWidth: 0),
                FlDotData(
                  getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                    radius: 6,
                    color: appColorInverseSurface,
                  ),
                ),
              ),
          ],
        ),
        // Vertical line showing current timestamp
        extraLinesData: ExtraLinesData(
          verticalLines: [
            VerticalLine(
              x: currentTimestamp.toDouble(),
              color: Colors.blueAccent,
              dashArray: [5, 10],
            ),
          ],
        ),
        // Grid
        gridData: FlGridData(drawVerticalLine: false),
      ),
      // Chart interaction
      transformationConfig: FlTransformationConfig(
        scaleAxis: FlScaleAxis.horizontal,
        minScale: 1.0,
        maxScale: 25.0,
        panEnabled: true,
        scaleEnabled: true,
      ),
    );
  }
}
