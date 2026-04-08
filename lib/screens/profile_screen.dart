import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fat_burner/theme/app_colors.dart';
import 'package:fat_burner/theme/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final initials = (user?.displayName?.isNotEmpty == true)
        ? user!.displayName!.substring(0, 1).toUpperCase()
        : (user?.email?.substring(0, 1).toUpperCase() ?? 'U');

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  "Profile",
                  style: AppTypography.h1(color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
                ),
              ),

              const SizedBox(height: 28),

              /// Avatar + name row
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.gradientPrimary,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.structurePrimary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: AppTypography.h2(color: Colors.white).copyWith(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'User',
                            style: AppTypography.h3(color: isDark ? AppColors.textOnDark : AppColors.textPrimary).copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: AppTypography.body(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// Stats row
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: Row(
                  children: [
                    Expanded(child: _miniStat("5", "Day Streak", "🔥", isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: _miniStat("24", "Workouts", "💪", isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: _miniStat("3.2kg", "Lost", "📉", isDark)),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              /// Settings section
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "ACCOUNT",
                  style: AppTypography.label(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                ),
              ),

              const SizedBox(height: 12),

              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: _settingsCard([
                  _settingsRow(Icons.person_outline_rounded, "Edit Profile", onTap: () {}, isDark: isDark),
                  _divider(isDark),
                  _settingsRow(Icons.notifications_outlined, "Notifications", onTap: () {}, isDark: isDark),
                  _divider(isDark),
                  _settingsRow(Icons.lock_outline_rounded, "Privacy", onTap: () {}, isDark: isDark),
                ], isDark),
              ),

              const SizedBox(height: 24),

              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  "SUPPORT",
                  style: AppTypography.label(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
                ),
              ),

              const SizedBox(height: 12),

              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: _settingsCard([
                  _settingsRow(Icons.help_outline_rounded, "Help & Support", onTap: () {}, isDark: isDark),
                  _divider(isDark),
                  _settingsRow(Icons.star_outline_rounded, "Rate the App", onTap: () {}, isDark: isDark),
                ], isDark),
              ),

              const SizedBox(height: 32),

              /// Logout
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: () async => await FirebaseAuth.instance.signOut(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Log out",
                          style: AppTypography.body(color: AppColors.error).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(String value, String label, String emoji, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDk : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.h2(color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption(color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsRow(IconData icon, String label, {required VoidCallback onTap, required bool isDark}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body(color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.textOnDarkMuted : AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
    height: 1,
    color: isDark ? AppColors.borderDark : AppColors.borderLight,
    indent: 52,
  );
}
