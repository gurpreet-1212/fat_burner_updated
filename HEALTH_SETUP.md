# Health Plugin Setup – HealthKit & Health Connect

This app uses the [health](https://pub.dev/packages/health) package to read and write health data on **iOS (HealthKit)** and **Android (Health Connect)**.

---

## Android – Health Connect

### 1. Prerequisites

- **minSdk:** 23 (already set)
- **Health Connect app:** Users must have [Health Connect](https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata) installed (Google Play Services). If not, prompt them to install via `HealthService.instance.isAvailable()` and `health.installHealthConnect()`.

### 2. Configuration (already done)

The following are configured in this project:

| Item | Location | Status |
|------|----------|--------|
| Health Connect queries | `AndroidManifest.xml` | ✅ Added |
| Permissions (steps, calories, weight) | `AndroidManifest.xml` | ✅ Added |
| Activity recognition | `AndroidManifest.xml` | ✅ Added |
| Permissions rationale intent | `MainActivity` | ✅ Added |
| View permission usage | `activity-alias` | ✅ Added |
| MainActivity extends FlutterFragmentActivity | `MainActivity.kt` | ✅ Required for Android 14+ |
| AndroidX / Jetifier | `gradle.properties` | ✅ Added |

### 3. Permissions declared

```
READ_STEPS / WRITE_STEPS
READ_ACTIVE_CALORIES_BURNED / WRITE_ACTIVE_CALORIES_BURNED
READ_WEIGHT / WRITE_WEIGHT
READ_HEALTH_DATA_HISTORY
ACTIVITY_RECOGNITION
```

### 4. Runtime permissions

**ACTIVITY_RECOGNITION** is a dangerous permission. Before reading steps, request it:

```dart
import 'package:permission_handler/permission_handler.dart';

// Before first health data read
await Permission.activityRecognition.request();
```

Add `permission_handler` to `pubspec.yaml` if not already present, and follow its setup for Android.

### 5. Play Store declaration

For Play Store submission, declare health data use in the Play Console:

- Data safety form: indicate access to steps, calories, weight
- Health Connect declaration: declare the data types your app reads/writes

---

## iOS – HealthKit

### 1. Prerequisites

- Xcode project
- Apple Developer account
- Device or simulator with Health app

### 2. Info.plist (already done)

These keys are already in `ios/Runner/Info.plist`:

```xml
<key>NSHealthShareUsageDescription</key>
<string>Fat Burner syncs your steps, calories, and weight with Apple Health to track your fitness progress.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>Fat Burner syncs your steps, calories, and weight with Apple Health to track your fitness progress.</string>
```

### 3. Enable HealthKit capability

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target.
3. Go to **Signing & Capabilities**.
4. Click **+ Capability**.
5. Add **HealthKit**.
6. Enable **Clinical Health Records** only if you need them (not required for steps/calories/weight).

### 4. HealthKit background delivery (optional)

For background updates, enable **Background Modes** and add **Background fetch** and configure HealthKit background delivery in code.

---

## Usage

### Initialize and request authorization

```dart
final healthService = HealthService.instance;

// Configure (call once)
await healthService.configure();

// Request permissions
final granted = await healthService.requestAuthorization();
if (!granted) {
  // User denied or Health Connect not installed (Android)
  return;
}

// Read data
final steps = await healthService.getTodaySteps();
final calories = await healthService.getTodayCaloriesBurned();
final weight = await healthService.getLatestWeight();
```

### Check availability (Android)

```dart
final available = await healthService.isAvailable();
if (!available && Platform.isAndroid) {
  // Health Connect not installed – consider calling:
  // await Health().installHealthConnect();
}
```

---

## Data types

| Data | HealthDataType | Android permission | iOS |
|------|----------------|--------------------|-----|
| Steps | `STEPS` | READ_STEPS, WRITE_STEPS | ✅ |
| Active calories | `ACTIVE_ENERGY_BURNED` | READ_ACTIVE_CALORIES_BURNED, WRITE_* | ✅ |
| Weight | `WEIGHT` | READ_WEIGHT, WRITE_WEIGHT | ✅ |
| Nutrition | `NUTRITION` | (add if needed) | ✅ |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Protected health data is inaccessible" (iOS) | Unlock the device before reading. |
| Health Connect not found (Android) | Ensure Health Connect is installed; use `installHealthConnect()` to prompt install. |
| Permission denied | Call `requestAuthorization()` before reads/writes. |
| No data returned | Check that the Health/Health Connect app has data for the requested types and date range. |
| Android 14 permission dialog fails | Confirm `MainActivity` extends `FlutterFragmentActivity`. |

---

## Adding more data types

1. Add the matching permission to `AndroidManifest.xml` (see [Health Connect permissions](https://developer.android.com/reference/android/health/connect/HealthPermissions)).
2. Add the `HealthDataType` to `_typesToRead` and `_permissions` in `lib/services/health_service.dart`.
3. On iOS, no extra Info.plist entries are needed for standard types.
4. Update `NSHealthShareUsageDescription` / `NSHealthUpdateUsageDescription` if the data is sensitive.
