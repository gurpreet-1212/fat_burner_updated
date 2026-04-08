import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fat_burner/core/core.dart';
import 'package:fat_burner/core/firebase_messaging_service.dart';
import 'package:fat_burner/providers/providers.dart';

// ✅ Import your screens
import 'package:fat_burner/screens/login_screen.dart';
import 'package:fat_burner/screens/main_screen.dart';
import 'package:fat_burner/theme/app_theme.dart';

import 'firebase_options.dart';

/// 🔥 REQUIRED: Background handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint("Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Initialize Firebase Safely (Bypasses white screen on missing config)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init missing: $e");
  }

  /// 🔥 Register background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// 🔥 Initialize FCM safely
  try {
    await FirebaseMessagingService.instance.initialize();
  } catch (e) {
    debugPrint("FCM init error: $e");
  }

  runApp(const FatBurnerApp());
}

class FatBurnerApp extends StatelessWidget {
  const FatBurnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PurchaseStatusProvider.instance,
        ),
      ],
      child: MaterialApp.router(
        title: 'BetterAlt',
        debugShowCheckedModeBanner: false,

        /// 🎨 Theme
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.dark, // Defaulting to dark as per plan

        /// 🔐 Auth Gate via GoRouter
        routerConfig: AppRouter.router,
      ),
    );
  }
}

/// 🔐 AUTH GATE (Auto-login logic)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
        
        /// 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ✅ User already logged in → go to main app
        if (snapshot.hasData) {
          return const MainScreen();
        }

        /// ❌ Not logged in → go to login
        return const LoginScreen();
      },
      );
    } catch (e) {
      // Fallback if Firebase is completely unconfigured
      return const LoginScreen();
    }
  }
}