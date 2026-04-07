# Fat Burner – Dependencies Overview

## Summary

| Category | Package | Purpose |
|----------|---------|---------|
| **Firebase** | firebase_core | Required base for all Firebase services |
| | firebase_auth | Email/password, Google, Apple, etc. sign-in |
| | cloud_firestore | NoSQL database with offline support |
| | firebase_messaging | Push notifications (FCM) |
| **Health** | health | HealthKit (iOS) + Health Connect (Android) |
| **HTTP** | dio | REST APIs, interceptors, timeouts |
| **State** | provider | Simple, official state management |

---

## Firebase

### firebase_core `^4.5.0`
- **Role:** Required for all Firebase plugins.
- **Usage:** Initialize with `await Firebase.initializeApp()` before any Firebase calls.

### firebase_auth `^6.2.0`
- **Role:** Sign-in (email/password, Google, Apple, phone, etc.).
- **Usage:** Replace the placeholder `AuthService` with `FirebaseAuth.instance`.

### cloud_firestore `^6.1.3`
- **Role:** Cloud NoSQL database, real-time sync, offline cache.
- **Usage:** Store users, health logs, goals, etc. via `FirebaseFirestore.instance`.

### firebase_messaging `^16.1.2`
- **Role:** Push notifications via Firebase Cloud Messaging (FCM).
- **Usage:** Handle foreground/background messages and notification taps.

**Setup:** Run `dart run flutterfire_cli:flutterfire configure` to generate platform config (`google-services.json`, `GoogleService-Info.plist`).

---

## Health Data

### health `^13.3.1`
- **Role:** Read/write health data on iOS (HealthKit) and Android (Health Connect).
- **Usage:** Steps, calories, weight, heart rate, workouts, etc.

**Platform setup:**
- **iOS:** Add HealthKit capability and `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription` in `Info.plist`.
- **Android:** Declare Health Connect queries/permissions in `AndroidManifest.xml`; Health Connect must be installed on the device.

---

## HTTP

### dio `^5.9.2`
- **Role:** HTTP client (REST APIs).
- **Why Dio:** Interceptors, timeouts, form data, multipart, cancellation, global config.
- **Alternative:** `http` (simpler, built-in) if you don't need advanced features.

---

## State Management

### provider `^6.1.5`
- **Role:** Provide and consume state across the widget tree.
- **Usage:** Wrap `MaterialApp` with `MultiProvider`, expose `ChangeNotifier` for auth, health data, etc.
- **Why Provider:** Minimal boilerplate, recommended by Flutter docs, easy to migrate to Riverpod later.

---

## Next Steps

1. Run `dart run flutterfire_cli:flutterfire configure` (requires Firebase project).
2. Add Health Connect / HealthKit config in Android and iOS.
3. Implement `AuthService` with `FirebaseAuth`.
4. Implement `HealthService` with the `health` package.
5. Add `MultiProvider` in `main.dart` and providers for auth and health data.
