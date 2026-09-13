import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:my_beer_diary/data.dart";
import "package:my_beer_diary/logic/cz.dart";

class BeerHistogram extends StatelessWidget {
  final Map<int, int> data;

  /// true if [data] is weekday histogram, false if [data] is month histogram
  final bool isWeekday;

  final double barWidth;

  const BeerHistogram({
    super.key,
    required this.data,
    required this.isWeekday,
    required this.barWidth,
  });

  @override
  Widget build(BuildContext context) {
    const hideAxisTitles = AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    );

    return BarChart(
      BarChartData(
        // Columns
        barGroups: [
          for (final item in data.entries)
            BarChartGroupData(
              x: item.key,
              barRods: [
                BarChartRodData(
                  toY: item.value.toDouble(),
                  // Label showing value above the column
                  label: BarChartRodLabel(text: "${item.value}"),
                  // No rounded corners
                  borderRadius: BorderRadius.zero,
                  width: barWidth,
                  color: beerColorAmber,
                ),
              ],
            ),
        ],
        // No grid, border and popup
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: false),
        // Axis labels
        titlesData: FlTitlesData(
          show: true,
          leftTitles: hideAxisTitles,
          rightTitles: hideAxisTitles,
          topTitles: hideAxisTitles,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  isWeekday
                      ? intToWeekdayStr(value.toInt())
                      : intToMonthStr(value.toInt()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
