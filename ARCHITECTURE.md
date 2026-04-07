# Fat Burner – Project Architecture

A production-ready, scalable Flutter health tracking app using clean architecture.

## Folder Structure

```
lib/
├── core/           # App-wide config: router, theme, constants
├── models/         # Data models (User, HealthData, etc.)
├── screens/        # Full-page screens (Login, Dashboard)
├── services/       # Business logic & API (Auth, Health)
├── widgets/        # Reusable UI components
└── main.dart       # App entry point
```

## Quick Start

1. **Run the app:** `flutter run`
2. **Login:** Use any email (e.g. `test@test.com`) and password (min 6 chars)
3. **Dashboard:** View placeholder stats; logout via the app bar icon

## Where to Add New Features

| Feature | Location | Example |
|---------|----------|---------|
| New screen | `screens/` | `weight_tracking_screen.dart` |
| API / logic | `services/` | `nutrition_service.dart` |
| Data type | `models/` | `meal_model.dart` |
| Reusable UI | `widgets/` | `stat_card.dart` |
| New route | `core/app_router.dart` | Add `GoRoute` |

## Next Steps

- Replace `AuthService` with Firebase Auth or your backend
- Integrate Health Connect (Android) / HealthKit (iOS) in `HealthService`
- Add state management (Riverpod/Bloc) when complexity grows
- Add unit tests for services and models
