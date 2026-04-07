import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fat_burner/firebase_options.dart';

/// Handles FCM setup: permissions, token, foreground/background message handlers.
/// Call [initialize] from main.dart after Firebase.initializeApp().
class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize FCM: request permissions, set handlers, get token.
  Future<void> initialize() async {
    await _requestPermission();

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // User taps notification when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Get FCM token (e.g. to store on your backend)
    await _updateFcmToken();
    _messaging.onTokenRefresh.listen((_) => _updateFcmToken());
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    // settings: authorized, denied, notDetermined, provisional
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Handle message when app is in foreground
    // You can show an in-app banner or update UI
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on message.data, e.g. message.data['route']
  }

  Future<void> _updateFcmToken() async {
    String? token;
    if (Platform.isIOS) {
      // On iOS, APNs token must be available first
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        token = await _messaging.getToken();
      }
    } else {
      token = await _messaging.getToken();
    }
    if (token != null) {
      // TODO: Send token to your backend
    }
  }
}

/// Background message handler - must be top-level function.
/// Called when a message is received while app is terminated or in background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Handle background/terminated message (e.g. update local DB)
}
