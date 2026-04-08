import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fat_burner/screens/login_screen.dart';
import 'package:fat_burner/screens/main_screen.dart';
import 'package:fat_burner/services/auth_service.dart';

/// Centralized routing configuration.
/// Add new routes here to keep navigation scalable.
class AppRouter {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String verify = '/verify';
  static const String signup = '/signup';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: true,
    refreshListenable: AuthService.instance.authState,
    redirect: (context, state) {
      final isLoggedIn = AuthService.instance.isLoggedIn;
      final isAuthRoute = state.matchedLocation == login || state.matchedLocation == signup;

      if (isLoggedIn && isAuthRoute) {
        return dashboard;
      }
      if (!isLoggedIn && !isAuthRoute) {
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
        path: signup,
        name: 'signup',
        builder: (context, state) => const LoginScreen(), // TODO: replace with SignupScreen
      ),
      GoRoute(
        path: verify,
        name: 'verify',
        builder: (context, state) => const MainScreen(), // TODO: replace with PurchaseGateScreen
      ),
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const MainScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
