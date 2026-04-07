import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fat_burner/screens/login_screen.dart';
import 'package:fat_burner/screens/dashboard_screen.dart';
import 'package:fat_burner/services/auth_service.dart';

/// Centralized routing configuration.
/// Add new routes here to keep navigation scalable.
class AppRouter {
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: true,
    refreshListenable: AuthService.instance.authState,
    redirect: (context, state) {
      final isLoggedIn = AuthService.instance.isLoggedIn;
      final isLoginRoute = state.matchedLocation == login;

      if (isLoggedIn && isLoginRoute) {
        return dashboard;
      }
      if (!isLoggedIn && !isLoginRoute) {
        return login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
