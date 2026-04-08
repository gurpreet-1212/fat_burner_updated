import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fat_burner/theme/app_colors.dart';
import 'package:fat_burner/theme/app_typography.dart';
import 'package:fat_burner/theme/app_spacing.dart';

class StepsScreen extends StatelessWidget {
  const StepsScreen({super.key});

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
                    "Steps",
                    style: AppTypography.h1(color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
                  ),
                ),

                const SizedBox(height: 4),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "Keep moving champion!",
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
                      gradient: const LinearGradient(
                        colors: AppColors.gradientPrimary,
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
                                "4,880",
                                style: AppTypography.statLarge(color: Colors.white).copyWith(fontSize: 48),
                              ),
                              Text(
                                "steps today",
                                style: AppTypography.body(color: Colors.white70),
                              ),
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: 0.49,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.accentGlow),
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "49% of 10,000 goal",
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
                          child: const Icon(Icons.directions_walk_rounded, color: Colors.white, size: 40),
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
                        "Avg 5,240/day",
                        style: AppTypography.caption(color: AppColors.accent).copyWith(fontWeight: FontWeight.w700),
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
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2,
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
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              curveSmoothness: 0.35,
                              spots: const [
                                FlSpot(0, 1), FlSpot(1, 4), FlSpot(2, 2.5),
                                FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 7), FlSpot(6, 6)
                              ],
                              color: AppColors.accent,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                                  radius: 6,
                                  color: AppColors.accent,
                                  strokeColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                  strokeWidth: 3,
                                ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [AppColors.accent.withValues(alpha: 0.3), AppColors.accent.withValues(alpha: 0)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
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
