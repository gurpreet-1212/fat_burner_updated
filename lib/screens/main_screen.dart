import 'package:flutter/material.dart';
import 'package:fat_burner/theme/app_colors.dart';
import 'package:fat_burner/theme/app_typography.dart';

import 'home_screen.dart';
import 'steps_screen.dart';
import 'calories_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    StepsScreen(),
    CaloriesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            elevation: 0,
            indicatorColor: AppColors.accent.withValues(alpha: 0.2), // Light highlight pill
            backgroundColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTypography.caption(color: AppColors.accent).copyWith(fontWeight: FontWeight.w700);
              }
              return AppTypography.caption(color: isDark ? AppColors.textOnDarkMuted : AppColors.textTertiary);
            }),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.accent),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_walk_outlined),
                selectedIcon: Icon(Icons.directions_walk_rounded, color: AppColors.accent),
                label: 'Steps',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_fire_department_outlined),
                selectedIcon: Icon(Icons.local_fire_department_rounded, color: AppColors.accent),
                label: 'Diet',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded, color: AppColors.accent),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
