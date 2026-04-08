# BetterAlt Fat Burner — Master Product Requirements Document (PRD)

> Version: 1.0
> Date: 2026-04-07
> Status: In Development
> Platform: iOS + Android (Flutter)

---

## Table of Contents

1. [Product Vision](#1-product-vision)
2. [Target User](#2-target-user)
3. [Business Context](#3-business-context)
4. [Current State (What Has Been Built)](#4-current-state-what-has-been-built)
5. [Architecture Overview](#5-architecture-overview)
6. [Feature Specifications](#6-feature-specifications)
7. [Screens & Navigation](#7-screens--navigation)
8. [Backend & Infrastructure](#8-backend--infrastructure)
9. [What Is Working vs. What Is Not](#9-what-is-working-vs-what-is-not)
10. [Gap Analysis — What Needs to Be Built](#10-gap-analysis--what-needs-to-be-built)
11. [Technical Debt & Known Issues](#11-technical-debt--known-issues)
12. [Data Architecture](#12-data-architecture)
13. [Security & Privacy](#13-security--privacy)
14. [Build & Deployment](#14-build--deployment)
15. [Session History](#15-session-history)

---

## 1. Product Vision

BetterAlt Fat Burner is a mobile health companion app for customers of the BetterAlt brand who purchase the "Fat Burner" supplement product. The app serves two purposes:

1. **Supplement Accountability** — Help users track whether they've taken their daily fat burner supplement
2. **Health Tracking** — Surface daily health metrics (steps, calories burned, sleep, weight) pulled from the device's native health platform (HealthKit on iOS, Health Connect on Android)

The app is **gated** by a Shopify purchase verification system — only users who have purchased "Plant Protein" from the BetterAlt Shopify store get full access. This ties the app directly to the brand's e-commerce business.

---

## 2. Target User

- BetterAlt customers who have purchased the Fat Burner / Plant Protein product
- Health-conscious individuals tracking daily supplement intake
- Users who want a simple, branded companion app to their supplement routine
- iOS and Android users

---

## 3. Business Context

- **Brand:** BetterAlt (Distiled Tech project)
- **E-commerce:** Shopify store — sells "Plant Protein" and "Fat Burner" products
- **Business model:** App is a value-add for Shopify customers; not sold separately
- **Purchase verification:** Firebase Cloud Function calls Shopify Admin GraphQL API to confirm whether the signed-in user (by email or phone) has purchased "Plant Protein"
- **Firebase Project:** `fatburner---app`
- **App ID (Android):** `1:231893834616:android:e8e67e487c21caf4d2868d`

---

## 4. Current State (What Has Been Built)

As of 2026-04-07, the following has been scaffolded and partially implemented:

### Infrastructure (Complete)
- Flutter project initialized with Material3 green theme
- Firebase connected (Android configured, iOS pending)
- Firebase Auth — email/password login and sign-up fully working
- Cloud Firestore — user profiles and daily check-in data
- Firebase Cloud Messaging — permissions, token retrieval, foreground/background handlers
- Firebase Cloud Functions — `checkPlantProteinPurchase` deployed
- Shopify Admin GraphQL client — paginated order search by email and phone

### Flutter App (Partially Complete)
- Login / Sign-up screen with validation and Firebase Auth
- Bottom navigation shell (4 tabs: Home, Steps, Calories, Profile)
- Home screen with fat burner toggle (persisted to Firestore)
- Steps screen with line chart (hardcoded data)
- Calories screen with line chart (hardcoded data)
- Profile screen with logout
- Dashboard screen (separate route — currently unreachable due to routing bug)
- `HealthService` — complete implementation for HealthKit/Health Connect (not yet connected to UI)
- `ShopifyPurchaseService` — complete Shopify verification call (not yet called from any screen)
- `PurchaseStatusProvider` — state management for purchase check (not yet used)

---

## 5. Architecture Overview

```
┌────────────────────────────────────────────────────────┐
│                    Flutter App                          │
│                                                        │
│  Screens → Widgets → Providers → Services → Firebase  │
│                                        ↕               │
│                                    HealthKit /          │
│                                   Health Connect        │
└────────────────────────────────────────────────────────┘
                          ↕
┌────────────────────────────────────────────────────────┐
│              Firebase (Backend)                         │
│  Auth | Firestore | Messaging | Cloud Functions        │
└────────────────────────────────────────────────────────┘
                          ↕
┌────────────────────────────────────────────────────────┐
│              Shopify Admin API                          │
│  GraphQL — orders, customers, line items               │
└────────────────────────────────────────────────────────┘
```

**State management:** Provider (ChangeNotifier pattern)
**Routing:** GoRouter defined but not yet wired (currently using AuthGate + BottomNavigationBar)
**Auth pattern:** Firebase Auth stream → AuthGate → MainScreen or LoginScreen

---

## 6. Feature Specifications

### F1 — Authentication

| Field | Detail |
|-------|--------|
| Status | Complete |
| Method | Firebase Email/Password |
| Login fields | Email, Password |
| Sign-up fields | Display Name (optional), Email, Phone (optional), Password |
| Validation | Email format check, password min 6 chars |
| Error handling | Human-readable Firebase error codes |
| Session | Firebase persists session automatically |
| Profile storage | Firestore `users/{uid}` — email, displayName, phone, createdAt |

**Auth flow:**
```
App launch → Firebase.initializeApp()
           → AuthGate (StreamBuilder on authStateChanges)
           → Logged in? → MainScreen
           → Not logged in? → LoginScreen
           → Login/Signup → Firebase Auth → AuthGate detects change → MainScreen
```

---

### F2 — Daily Fat Burner Check-In

| Field | Detail |
|-------|--------|
| Status | Complete (HomeScreen only) |
| UI | Switch widget in HomeScreen fat burner card |
| Persistence | Firestore `users/{uid}/daily/{YYYY-MM-DD}/fatBurnerTaken: bool` |
| Load | Reads today's document on screen `initState` |
| Save | Writes on every toggle |

**Gap:** `DashboardScreen` has the same toggle UI but it is **local state only** — not persisted to Firestore.

---

### F3 — Health Metrics Dashboard

| Field | Detail |
|-------|--------|
| Status | UI built (hardcoded) — service layer ready but not connected |
| Metrics | Steps, Calories Burned, Sleep, Weight |
| UI | 2x2 grid of stat cards with circular progress rings |
| Data source | Should come from `HealthService` |
| Current state | All values hardcoded: 1240 steps, 320 cal, 7.5h sleep, 72kg |

**Required work:**
- Call `HealthService.requestAuthorization()` on first launch
- Replace hardcoded values with `HealthService.fetchBasicHealthData()`
- Add sleep data type to `HealthService` (currently not tracked)
- Display real weight from `getLatestWeight()`

---

### F4 — Steps Tracking

| Field | Detail |
|-------|--------|
| Status | UI built (hardcoded) |
| Screen | StepsScreen — line chart, summary card |
| Chart | fl_chart LineChart, 6 hardcoded data points |
| Chart color | Green |
| Data source | Should come from `HealthService.getTodaySteps()` + weekly history |

**Required work:**
- Connect to `HealthService` for real-time today's steps
- Implement weekly steps history (currently only today is available in service)
- Add day labels to x-axis of chart

---

### F5 — Calories Tracking

| Field | Detail |
|-------|--------|
| Status | UI built (hardcoded) |
| Screen | CaloriesScreen — line chart, summary card |
| Chart | fl_chart LineChart, 6 hardcoded data points |
| Chart color | Orange |
| Data source | Should come from `HealthService.getTodayCaloriesBurned()` |

**Required work:** Same as F4 — connect to real HealthService data + weekly history.

---

### F6 — Shopify Purchase Verification Gate

| Field | Detail |
|-------|--------|
| Status | Backend complete — frontend gate NOT built |
| Function | `checkPlantProteinPurchase` (Firebase CF) |
| Input | Email and/or phone from authenticated user |
| Output | `{ purchased: true/false }` |
| Provider | `PurchaseStatusProvider` — state ready, never called |

**Required work (critical feature):**
- Build a "verification" screen or gate that appears after login
- Call `PurchaseStatusProvider.checkPurchase(email, phone)` with current user's details
- Show loading state while checking
- If `hasPurchased = true` → allow access to full app
- If `hasPurchased = false` → show "Purchase Required" screen with link to Shopify store
- Handle errors gracefully (network failure, Shopify down, etc.)

---

### F7 — Push Notifications (FCM)

| Field | Detail |
|-------|--------|
| Status | Infrastructure complete — no notifications sent yet |
| Setup | Permissions requested on launch, FCM token retrieved |
| Handlers | Foreground + background + tap handlers exist as stubs |
| Backend | No notification sending logic implemented |

**Required work:**
- Store FCM token per user in Firestore (`users/{uid}/fcmToken`)
- Implement daily supplement reminder notification (e.g., "Have you taken your Fat Burner today?")
- Implement Cloud Function to send scheduled reminders
- Handle notification tap → deep link to HomeScreen

---

### F8 — User Profile

| Field | Detail |
|-------|--------|
| Status | Basic — shows name/email, logout only |
| Screen | ProfileScreen |
| Data | Read from `FirebaseAuth.instance.currentUser` |
| Logout | `FirebaseAuth.instance.signOut()` — works correctly |

**Required work:**
- Edit profile (display name, phone)
- Show purchase status badge
- Notification preferences

---

## 7. Screens & Navigation

### Navigation Structure (Current)
```
AuthGate
├── LoginScreen (not logged in)
└── MainScreen (logged in)
    ├── Tab 0: HomeScreen
    ├── Tab 1: StepsScreen
    ├── Tab 2: CaloriesScreen
    └── Tab 3: ProfileScreen

DashboardScreen (exists but unreachable — routing bug)
```

### Navigation Structure (Intended with GoRouter)
```
/login          → LoginScreen
/dashboard      → DashboardScreen (post-login redirect target)
```

### Routing Issue
`AppRouter` (GoRouter) is configured but `MaterialApp` uses `home: AuthGate()` instead of `routerConfig: AppRouter.router`. The `LoginScreen` calls `context.go(AppRouter.dashboard)` which will throw at runtime because GoRouter is not active. This needs to be resolved by either:
- Option A: Wire GoRouter into `MaterialApp.router()` and remove `AuthGate`
- Option B: Remove GoRouter references from `LoginScreen` and navigate via `AuthGate` stream

---

## 8. Backend & Infrastructure

### Firebase Services

| Service | Status | Usage |
|---------|--------|-------|
| Firebase Auth | Active | Login/signup/logout |
| Cloud Firestore | Active | User profiles, daily check-ins, health data |
| Firebase Messaging | Initialized | Token retrieved; no messages sent yet |
| Cloud Functions | Deployed | `checkPlantProteinPurchase` |

### Cloud Function: checkPlantProteinPurchase

**Endpoint:** Firebase Callable
**Auth:** Required
**Environment variables needed:**
- `SHOPIFY_SHOP_DOMAIN` — your store's `.myshopify.com` domain
- `SHOPIFY_ACCESS_TOKEN` — Shopify Admin API token (stored in Secret Manager)

**Shopify API Scopes required:** `read_orders`, `read_customers`

**Logic:**
1. Searches orders by email → checks line items for "Plant Protein"
2. If not found by email, searches by phone (normalizes to digits only, finds customer, then fetches orders)
3. Returns `true` if any order contains "Plant Protein" in line item title

### Firestore Data Model

```
users/ {uid}
  email: string
  displayName: string?
  phone: string?
  createdAt: Timestamp
  updatedAt: Timestamp
  fcmToken: string?          ← TODO: not yet stored
  
  daily/ {YYYY-MM-DD}
    fatBurnerTaken: bool
    timestamp: Timestamp
    
  health_data/ {YYYY-MM-DD}
    steps: int
    calories: double
    distance: double          ← in km
    date: string
    updatedAt: Timestamp
```

---

## 9. What Is Working vs. What Is Not

### Working
| Feature | Notes |
|---------|-------|
| Firebase Auth login | Email/password, session persists |
| Firebase Auth signup | Creates user + saves to Firestore |
| Firebase Auth logout | Correctly redirects to login |
| Daily fat burner toggle | Reads + writes to Firestore (HomeScreen only) |
| FCM setup | Permissions + token retrieval |
| Steps screen UI | Chart renders (hardcoded data) |
| Calories screen UI | Chart renders (hardcoded data) |
| Profile screen | Shows user name/email, logout works |
| Shopify Cloud Function | Deployed and verifies orders |
| HealthService | Fully implemented (not connected to UI) |

### Not Working / Not Built
| Feature | Priority | Notes |
|---------|----------|-------|
| Real health data in UI | High | HealthService ready, not wired |
| Shopify purchase gate | High | Service + provider ready, no gate screen |
| GoRouter wiring | High | Routing is broken — LoginScreen .go() will crash |
| FCM token stored in Firestore | Medium | Token retrieved but not saved |
| Push notification sending | Medium | No scheduled reminders |
| Weekly health history | Medium | Only today available in service |
| iOS Firebase config | Medium | Only Android configured |
| DashboardScreen toggle persistence | Low | Uses local state, not Firestore |
| Edit profile | Low | Not implemented |
| Sleep tracking | Low | Not in HealthService |

---

## 10. Gap Analysis — What Needs to Be Built

### Priority 1 — Fix Routing (Blocker)

The GoRouter vs AuthGate conflict must be resolved before any further screen navigation can be reliably built.

**Recommended approach:**
- Remove `home: AuthGate()` from `MaterialApp`
- Switch to `MaterialApp.router(routerConfig: AppRouter.router)`
- Move `AuthGate` logic into GoRouter's `redirect` (already partially done)

---

### Priority 2 — Shopify Purchase Gate Screen

A verification screen that:
- Appears after login (before MainScreen is shown)
- Shows loading spinner while `PurchaseStatusProvider.checkPurchase()` runs
- On `hasPurchased = true` → proceeds to MainScreen
- On `hasPurchased = false` → shows "You need to purchase BetterAlt Fat Burner to use this app" + CTA button to store
- On error → shows retry button

---

### Priority 3 — Connect Real Health Data

- Request HealthKit/Health Connect permissions on first app launch
- Replace hardcoded values in `HomeScreen` stats grid with `HealthService.fetchBasicHealthData()`
- Replace hardcoded values in `StepsScreen` with real daily steps
- Replace hardcoded values in `CaloriesScreen` with real calories burned
- Save fetched health data to Firestore via `FirestoreService.saveHealthData()`

---

### Priority 4 — FCM Reminders

- Save FCM token to `users/{uid}/fcmToken` in Firestore after retrieval
- Build Cloud Function to send daily reminder at user's configured time (or fixed 9 AM)
- Handle notification tap → open HomeScreen fat burner card

---

### Priority 5 — Polish & iOS

- Configure Firebase for iOS (`GoogleService-Info.plist`, update `firebase.json`)
- Add HealthKit capability to iOS `Runner.xcodeproj`
- Add `NSHealthShareUsageDescription` to `ios/Runner/Info.plist`
- Add Health Connect queries to `android/app/src/main/AndroidManifest.xml`

---

## 11. Technical Debt & Known Issues

| # | Issue | File | Fix |
|---|-------|------|-----|
| 1 | GoRouter not wired to MaterialApp | `main.dart` | Switch to `MaterialApp.router()` |
| 2 | `LoginScreen` calls `context.go()` — will crash | `login_screen.dart` | Fix after routing resolved |
| 3 | DashboardScreen has hardcoded "Gurpreet" | `dashboard_screen.dart` | Use `AuthService.instance.currentUser?.displayName` |
| 4 | DashboardScreen toggle is local state | `dashboard_screen.dart` | Add Firestore read/write same as HomeScreen |
| 5 | FCM handlers are empty stubs | `firebase_messaging_service.dart` | Implement foreground banner + tap navigation |
| 6 | FCM token not stored | `firebase_messaging_service.dart` | Write to Firestore on token retrieval/refresh |
| 7 | `dio` package unused | `pubspec.yaml` | Remove or use for REST calls |
| 8 | iOS not in `firebase.json` | `firebase.json` | Run `flutterfire configure` for iOS |
| 9 | `android/functions/` appears to be a duplicate | `android/functions/` | Clarify if this is separate or should be deleted |
| 10 | `caloriesConsumed` always null | `health_data_model.dart` | Implement food logging or remove field |

---

## 12. Data Architecture

### Authentication Flow
```
User enters email + password
→ Firebase Auth signInWithEmailAndPassword
→ AuthService._onAuthStateChanged fires
→ Loads UserModel from Firestore (falls back to Firebase user object)
→ authState.value = true
→ GoRouter redirect / AuthGate detects change
→ Navigate to MainScreen
```

### Daily Check-In Flow
```
HomeScreen initState
→ Read Firestore users/{uid}/daily/{today}
→ setState(takenToday = doc["fatBurnerTaken"])

User toggles Switch
→ Write Firestore users/{uid}/daily/{today}/fatBurnerTaken = value
→ setState(takenToday = value)
```

### Shopify Verification Flow (designed, not connected)
```
User logs in
→ PurchaseStatusProvider.checkPurchase(email, phone)
→ ShopifyPurchaseService.hasPurchasedPlantProtein(email, phone)
→ FirebaseFunctions.httpsCallable("checkPlantProteinPurchase").call({email, phone})
→ Cloud Function validates auth, calls Shopify GraphQL
→ Returns { purchased: bool }
→ PurchaseStatusProvider updates hasPurchased
→ UI shows MainScreen (true) or Purchase Required screen (false)
```

---

## 13. Security & Privacy

| Area | Implementation |
|------|---------------|
| Auth | Firebase Auth — tokens managed by Firebase SDK |
| Shopify token | Stored in Firebase Secret Manager (not in code or .env in production) |
| Cloud Function auth | Rejects unauthenticated calls (`unauthenticated` HttpsError) |
| Input validation | Email/phone sanitized in Cloud Function before Shopify API call |
| Health data | Read-only permissions requested; data stored in user's own Firestore subcollection |
| .env files | `.env.example` committed (safe); actual `.env` should be in `.gitignore` |
| FCM token | Retrieved but not yet stored — when stored, must be in `users/{uid}` only |

**Privacy considerations:**
- Health data (steps, calories, weight) is stored per-user in Firestore — users own their data
- Phone numbers are passed to Shopify only for order verification; not stored by the Cloud Function
- No analytics SDK currently integrated

---

## 14. Build & Deployment

### Flutter App
```bash
# Install dependencies
flutter pub get

# Run on simulator/device
flutter run

# Build iOS
flutter build ios --release

# Build Android
flutter build appbundle --release
```

### Firebase Cloud Functions
```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

### Environment Setup (Cloud Functions)
```bash
# Set Shopify access token (production)
firebase functions:secrets:set SHOPIFY_ACCESS_TOKEN

# Set shop domain (not secret)
# Add to firebase.json or function environment config
SHOPIFY_SHOP_DOMAIN=your-store.myshopify.com

# Local development
cp functions/.env.example functions/.env
# Fill in SHOPIFY_SHOP_DOMAIN and SHOPIFY_ACCESS_TOKEN in .env
```

### Pending Setup (iOS)
```bash
# Add iOS to Firebase
dart run flutterfire_cli:flutterfire configure

# Add HealthKit capability in Xcode:
# Runner → Signing & Capabilities → + → HealthKit

# Add to ios/Runner/Info.plist:
# NSHealthShareUsageDescription
# NSHealthUpdateUsageDescription
```

---

## 15. Session History

### Session 1 — 2026-04-07

**What happened:**
- Explored the codebase for the first time
- Investigated adding shadcn/ui components to Flutter — determined direct port not possible
- Found `shadcn_flutter` package (Flutter-native shadcn-inspired components)
- Attempted full UI reskin of all screens with `shadcn_flutter ^0.1.6`
- Discovered version `0.1.6` does not exist on pub.dev (latest is `^0.0.52`)
- User decided not to pursue shadcn approach — all UI changes reverted via `git restore`
- Discovered `functions/` files were deleted from disk (not by Claude) — restored via `git restore functions/`
- Installed Flutter SDK via git clone at `~/development/flutter`
- Downloaded iOS 26.4 Simulator runtime (8.46 GB) via `xcodebuild -downloadPlatform iOS`
- Xcode confirmed installed at `/Applications/Xcode.app`
- iOS Simulator runtime requires Xcode GUI setup (Xcode → Settings → Platforms) — not automatable headlessly

**Current state at end of session:**
- All code is at original initial commit state (all UI changes reverted)
- Flutter SDK installed at `~/development/flutter/bin/flutter`
- Xcode installed, iOS simulator runtime downloading/pending
- `functions/` files restored
- This CODEBASE.md and PRD.md created

**Decisions made:**
- No shadcn/ui — stay with Flutter Material3 for UI
- Simulator setup: user must complete via Xcode GUI (Platforms tab)
- All backend code preserved untouched throughout session

**Next steps agreed:**
- Fix GoRouter routing bug (Priority 1)
- Build Shopify purchase gate screen (Priority 2)
- Connect HealthService to UI (Priority 3)
- Improve UI with Material3 design (no shadcn)
