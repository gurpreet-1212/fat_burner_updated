import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fat_burner/theme/app_colors.dart';
import 'package:fat_burner/theme/app_typography.dart';
import 'package:fat_burner/theme/app_spacing.dart';

class CaloriesScreen extends StatelessWidget {
  const CaloriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: SafeArea(
        child: FadeIn(
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "Diet & Calories",
                    style: AppTypography.h1(color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
                  ),
                ),

                const SizedBox(height: 4),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "Fuel your body proper",
                    style: AppTypography.body(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                  ),
                ),

                const SizedBox(height: 30),

                /// Big stat card
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1,850",
                                style: AppTypography.statLarge(color: Colors.white).copyWith(fontSize: 48),
                              ),
                              Text(
                                "kcal consumed",
                                style: AppTypography.body(color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: 0.74,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "74% of 2,500 goal",
                                style: AppTypography.caption(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 40),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// Week label
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "THIS WEEK",
                        style: AppTypography.label(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                      ),
                      Text(
                        "Avg 2,100 kcal",
                        style: AppTypography.caption(color: AppColors.warning).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Chart
                Expanded(
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                      ),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceEvenly,
                          maxY: 3000,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1000,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  if (v.toInt() >= days.length || v.toInt() < 0) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      days[v.toInt()],
                                      style: AppTypography.caption(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            for (int i = 0; i < 7; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: [2200, 1800, 2500, 2100, 1900, 2800, 1850][i].toDouble(),
                                    color: AppColors.warning,
                                    width: 14,
                                    borderRadius: BorderRadius.circular(4),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: 3000,
                                      color: isDark ? AppColors.surfaceElevatedDk : AppColors.surfaceElevated,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
