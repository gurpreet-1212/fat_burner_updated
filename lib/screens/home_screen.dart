import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';

import 'package:fat_burner/theme/app_colors.dart';
import 'package:fat_burner/theme/app_spacing.dart';
import 'package:fat_burner/theme/app_typography.dart';
import 'package:fat_burner/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool takenToday = false;

  @override
  void initState() {
    super.initState();
    _loadTodayStatus();
  }

  Future<void> _loadTodayStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final todayDoc = DateTime.now().toString().substring(0, 10);
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("daily")
        .doc(todayDoc)
        .get();
    if (doc.exists) {
      setState(() {
        takenToday = doc.data()?["fatBurnerTaken"] ?? false;
      });
    }
  }

  Future<void> _updateStatus(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final todayDoc = DateTime.now().toString().substring(0, 10);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("daily")
        .doc(todayDoc)
        .set({
      "fatBurnerTaken": value,
      "timestamp": Timestamp.now(),
    });
    setState(() => takenToday = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// App Bar Area
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 70,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "images/Betteralt_main_logo.jpeg",
                      height: 24,
                      errorBuilder: (ctx, err, stk) => Text(
                        "BetterAlt",
                        style: AppTypography.h3(color: isDark ? AppColors.textOnDark : AppColors.textPrimary)
                              .copyWith(fontFamily: 'Newsreader'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceElevatedDk : AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.notifications_none_rounded, color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Greeting Header
                    const GreetingHeader(),

                    const SizedBox(height: 30),

                    /// Custom Animated Horizontal Calendar Let's go!
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: const _HorizontalCalendarRow(),
                    ),

                    const SizedBox(height: 30),

                    /// Health Rings Overview
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: const Center(
                        child: HealthRing(
                          current: 1240,
                          max: 2000,
                          label: 'Steps',
                          unit: 'STEPS TODAY',
                          color: AppColors.accent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// Fat Burner Toggle Card
                    _fatBurnerCard(isDark),

                    const SizedBox(height: 35),

                    /// Stats Grid section
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        "METRICS",
                        style: AppTypography.label(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Expanded(child: StatCard(title: "Steps", value: "1,240", subtitle: "Goal: 2k", icon: Icons.directions_walk_rounded, colorOverride: AppColors.accent, index: 1)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: StatCard(title: "Calories", value: "320", subtitle: "Burned", icon: Icons.local_fire_department_rounded, colorOverride: AppColors.warning, index: 2)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        const Expanded(child: StatCard(title: "Sleep", value: "7.5h", subtitle: "Restful", icon: Icons.bedtime_rounded, colorOverride: AppColors.chartPurple, index: 3)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: StatCard(title: "Water", value: "1.2L", subtitle: "Goal: 2L", icon: Icons.water_drop_rounded, colorOverride: AppColors.chartBlue, index: 4)),
                      ],
                    ),

                    const SizedBox(height: 35),

                    /// Weekly Charts Area
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WEEKLY FAT BURN",
                            style: AppTypography.label(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                            ),
                            child: const WeeklyChart(
                              dataPoints: [20, 50, 40, 80, 60, 30, 90], // Demo data
                              baseColor: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // spacing for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fatBurnerCard(bool isDark) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: takenToday
                ? [AppColors.structurePrimary, AppColors.structureSecondary]
                : [isDark ? AppColors.surfaceDark : AppColors.surfaceLight, isDark ? AppColors.surfaceElevatedDk : AppColors.surfaceElevated],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: takenToday ? AppColors.accent.withValues(alpha: 0.5) : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: takenToday ? 1.5 : 1,
          ),
          boxShadow: takenToday
              ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5))]
              : [],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: takenToday ? Colors.white.withValues(alpha: 0.2) : (isDark ? Colors.white12 : Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medication_liquid_rounded,
                color: takenToday ? Colors.white : (isDark ? AppColors.textOnDark : AppColors.textPrimary),
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fat Burner Supplements",
                    style: AppTypography.h3(color: takenToday ? Colors.white : (isDark ? AppColors.textOnDark : AppColors.textPrimary)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    takenToday ? "Taken today. Great job!" : "Don't forget your dose today",
                    style: AppTypography.body(color: takenToday ? Colors.white70 : (isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary)).copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Switch(
              value: takenToday,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.accent,
              inactiveThumbColor: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary,
              inactiveTrackColor: isDark ? AppColors.canvasDark : AppColors.surfaceElevated,
              onChanged: _updateStatus,
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalCalendarRow extends StatefulWidget {
  const _HorizontalCalendarRow();

  @override
  State<_HorizontalCalendarRow> createState() => _HorizontalCalendarRowState();
}

class _HorizontalCalendarRowState extends State<_HorizontalCalendarRow> {
  int _selectedDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // 2 weeks
        itemBuilder: (context, index) {
          // Generate a moving date window (7 days back, 7 days forward)
          final date = now.subtract(const Duration(days: 6)).add(Duration(days: index));
          final isSelected = date.day == _selectedDay;
          final isToday = date.day == now.day && date.month == now.month;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDay = date.day);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.accent : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekdayShort(date.weekday),
                    style: AppTypography.caption(
                      color: isSelected ? AppColors.textOnAccent : (isDark ? AppColors.textOnDarkMuted : AppColors.textTertiary),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date.day.toString(),
                    style: AppTypography.h3(
                      color: isSelected ? AppColors.textOnAccent : (isDark ? AppColors.textOnDark : AppColors.textPrimary),
                    ).copyWith(fontSize: 20),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.textOnAccent : AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getWeekdayShort(int weekday) {
    switch (weekday) {
      case 1: return 'MON';
      case 2: return 'TUE';
      case 3: return 'WED';
      case 4: return 'THU';
      case 5: return 'FRI';
      case 6: return 'SAT';
      case 7: return 'SUN';
      default: return '';
    }
  }
}
