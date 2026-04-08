import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fat_burner/theme/app_colors.dart';
import 'package:animate_do/animate_do.dart';

class WeeklyChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color baseColor;

  const WeeklyChart({
    super.key,
    required this.dataPoints,
    this.baseColor = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final maxVal = dataPoints.reduce((curr, next) => curr > next ? curr : next);
    
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: maxVal == 0 ? 100 : maxVal * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => baseColor.withValues(alpha: 0.8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.toY.round().toString(),
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    if (value.toInt() < 0 || value.toInt() >= days.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                         days[value.toInt()],
                         style: TextStyle(
                           color: Theme.of(context).brightness == Brightness.dark 
                              ? AppColors.textOnDarkMuted 
                              : AppColors.textSecondary,
                           fontWeight: FontWeight.w600,
                           fontSize: 12
                         ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxVal == 0 ? 25 : maxVal / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.borderDark 
                    : AppColors.borderLight,
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(dataPoints.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: dataPoints[index],
                    color: baseColor,
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxVal == 0 ? 100 : maxVal * 1.2,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.surfaceElevatedDk
                          : AppColors.surfaceElevated,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
