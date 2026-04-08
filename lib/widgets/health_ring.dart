import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fat_burner/theme/app_colors.dart';
import 'package:fat_burner/theme/app_typography.dart';
import 'package:animate_do/animate_do.dart';

class HealthRing extends StatelessWidget {
  final double current;
  final double max;
  final String label;
  final String unit;
  final Color color;

  const HealthRing({
    super.key,
    required this.current,
    required this.max,
    required this.label,
    required this.unit,
    this.color = AppColors.chartGreen,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double percent = (current / max).clamp(0.0, 1.0);

    return ZoomIn(
      duration: const Duration(milliseconds: 700),
      child: CircularPercentIndicator(
        radius: 80.0,
        lineWidth: 18.0,
        animation: true,
        animationDuration: 1200,
        percent: percent,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: isDark ? AppColors.surfaceElevatedDk : AppColors.surfaceElevated,
        progressColor: color,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              current.toInt().toString(),
              style: AppTypography.statLarge(color: isDark ? AppColors.textOnDark : AppColors.textPrimary).copyWith(fontSize: 28),
            ),
            Text(
              unit,
              style: AppTypography.caption(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
