import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class AlcoholChart extends StatelessWidget {
  final List<(int, double)> chartPoints;

  const AlcoholChart({super.key, required this.chartPoints});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (final point in chartPoints)
                FlSpot(point.$1.toDouble(), point.$2),
            ],
          ),
        ],
      ),
    );
  }
}
