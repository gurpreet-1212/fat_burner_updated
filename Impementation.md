# BetterAlt Fat Burner — UI Implementation Guide

> Version: 2.0
> Date: 2026-04-08
> Scope: **UI-ONLY** — No backend, Firebase, or service layer changes
> Platform: Flutter/Dart (iOS + Android)
> Design Reference: CaFit UI Kit + BetterAlt Brand Language + 60-30-10 Framework

---

## ⚠️ CRITICAL RULES

1. **DO NOT** modify any file in `services/`, `providers/`, or `functions/`
2. **DO NOT** change Firebase configuration, Firestore reads/writes, or Auth logic
3. **DO NOT** alter `pubspec.yaml` dependencies related to backend (firebase_*, health, cloud_functions)
4. **ONLY** modify files in: `screens/`, `widgets/`, `theme/`, `routes/`, and `main.dart` (theme + router only)
5. All data bindings (Firestore toggle, health values, user profile) must remain — only the **presentation layer** wrapping them changes

---

## 1. Design System — BetterAlt × 60-30-10 Framework

### 1.1 Color Tokens

```dart
// File: lib/theme/app_colors.dart (NEW FILE)

class AppColors {
  // === 60% — THE CANVAS (Backgrounds, large surfaces) ===
  // Light Mode
  static const Color canvasLight       = Color(0xFFF7F7F2);  // warm off-white
  static const Color surfaceLight      = Color(0xFFFFFFFF);  // card backgrounds
  static const Color surfaceElevated   = Color(0xFFF0F0EA);  // secondary cards, input fields

  // Dark Mode
  static const Color canvasDark        = Color(0xFF0F1410);  // deep forest black
  static const Color surfaceDark       = Color(0xFF1A2118);  // card backgrounds dark
  static const Color surfaceElevatedDk = Color(0xFF232E22);  // secondary cards dark

  // === 30% — THE STRUCTURE (Headers, cards, borders, secondary text) ===
  static const Color structurePrimary  = Color(0xFF1A3C34);  // BetterAlt deep green (from brand)
  static const Color structureSecondary= Color(0xFF2D5A4E);  // medium green
  static const Color structureMuted    = Color(0xFF5F6350);  // neutral olive
  static const Color borderLight       = Color(0xFFE2E2DA);  // light borders
  static const Color borderDark        = Color(0xFF2E3A2C);  // dark borders

  // === 10% — THE ACCENT (CTAs, status, highlights) ===
  static const Color accent            = Color(0xFF7CB342);  // BetterAlt vibrant green
  static const Color accentGlow        = Color(0xFF9ACD5A);  // hover / light variant
  static const Color accentMuted       = Color(0xFF4A7C2E);  // pressed state

  // === SEMANTIC COLORS ===
  static const Color success           = Color(0xFF4CAF50);
  static const Color warning           = Color(0xFFF5A623);
  static const Color error             = Color(0xFFE24B4A);
  static const Color info              = Color(0xFF5B9BD5);

  // === TEXT COLORS ===
  static const Color textPrimary       = Color(0xFF1A1F18);  // near-black green-tint
  static const Color textSecondary     = Color(0xFF5F6350);  // muted olive
  static const Color textTertiary      = Color(0xFF9B9E8E);  // captions, labels
  static const Color textOnAccent      = Color(0xFFFFFFFF);
  static const Color textOnDark        = Color(0xFFE8EAE2);
  static const Color textOnDarkMuted   = Color(0xFF9BA38E);

  // === CHART COLORS ===
  static const Color chartGreen        = Color(0xFF7CB342);
  static const Color chartOrange       = Color(0xFFF5A623);
  static const Color chartBlue         = Color(0xFF5B9BD5);
  static const Color chartRed          = Color(0xFFE24B4A);
  static const Color chartPurple       = Color(0xFF8E6CC0);

  // === GRADIENT PRESETS ===
  static const List<Color> gradientPrimary = [
    Color(0xFF1A3C34),
    Color(0xFF2D5A4E),
  ];
  static const List<Color> gradientAccent = [
    Color(0xFF7CB342),
    Color(0xFF9ACD5A),
  ];
  static const List<Color> gradientCard = [
    Color(0xFFFFFFFF),
    Color(0xFFF7F7F2),
  ];
}
```

### 1.2 Typography

```dart
// File: lib/theme/app_typography.dart (NEW FILE)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // LEVEL 1 — THE HOOK (60% weight in hierarchy)
  // Large, bold headers — establishes brand voice
  static TextStyle h1({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: color,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: color,
  );

  // LEVEL 2 — THE CONTEXT (30% weight)
  // Subheaders, body text — high legibility
  static TextStyle h3({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle body({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: color,
  );

  // LEVEL 3 — THE DETAIL (10% weight)
  // Captions, labels, micro-copy
  static TextStyle caption({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color,
  );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: color,
  );

  // SPECIAL — Large stat numbers (steps, calories, weight)
  static TextStyle statLarge({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    color: color,
  );

  static TextStyle statMedium({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: color,
  );
}
```

### 1.3 Spacing & Radius

```dart
// File: lib/theme/app_spacing.dart (NEW FILE)

class AppSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppRadius {
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 24;
  static const double pill = 100;  // full pill shape
  static const double card = 20;   // CaFit-style rounded cards
}
```

### 1.4 Theme Configuration

```dart
// File: lib/theme/app_theme.dart (NEW FILE — replaces current theme in main.dart)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.canvasLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.structurePrimary,
      secondary: AppColors.accent,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTypography.h3(color: AppColors.textPrimary),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: AppColors.borderLight, width: 0.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.structurePrimary,
      unselectedItemColor: AppColors.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnAccent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.canvasDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accentGlow,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: AppColors.canvasDark,
      onSecondary: AppColors.canvasDark,
      onSurface: AppColors.textOnDark,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: AppColors.borderDark, width: 0.5),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textOnDarkMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
```

### 1.5 Required pubspec.yaml Additions (UI-only packages)

```yaml
# ADD these to pubspec.yaml under dependencies:
dependencies:
  google_fonts: ^6.1.0        # Plus Jakarta Sans + Inter
  flutter_svg: ^2.0.10        # SVG icon support
  shimmer: ^3.0.0             # Loading skeleton shimmer
  percent_indicator: ^4.2.3   # Circular progress rings (CaFit style)
  animate_do: ^3.3.4          # Entry animations (fade, slide, bounce)
  # fl_chart is already present — keep it
```

---

## 2. New File Structure

```
lib/
├── main.dart                          # UPDATE: theme only
├── theme/
│   ├── app_colors.dart                # NEW
│   ├── app_typography.dart            # NEW
│   ├── app_spacing.dart               # NEW
│   └── app_theme.dart                 # NEW
├── widgets/                           # NEW folder
│   ├── stat_card.dart                 # Reusable metric card (steps, cal, sleep, weight)
│   ├── health_ring.dart               # Circular progress ring widget
│   ├── fat_burner_card.dart           # Daily check-in card with toggle
│   ├── weekly_chart.dart              # Reusable line/bar chart wrapper
│   ├── greeting_header.dart           # "Hello {name}" + date + avatar
│   ├── branded_app_bar.dart           # Custom app bar with BetterAlt logo
│   ├── bottom_nav_bar.dart            # Custom bottom nav (CaFit style)
│   ├── section_header.dart            # "Steps" + "See All" pattern
│   └── shimmer_loading.dart           # Skeleton loading states
├── screens/
│   ├── login_screen.dart              # REWRITE
│   ├── signup_screen.dart             # REWRITE (split from login)
│   ├── onboarding_screen.dart         # NEW — 3-slide welcome (CaFit style)
│   ├── purchase_gate_screen.dart      # NEW — Shopify verification gate
│   ├── main_screen.dart               # REWRITE — new shell with custom nav
│   ├── home_screen.dart               # REWRITE — full dashboard redesign
│   ├── steps_screen.dart              # REWRITE — detailed steps view
│   ├── calories_screen.dart           # REWRITE — detailed calories view
│   └── profile_screen.dart            # REWRITE — expanded profile
├── services/                          # ❌ DO NOT TOUCH
├── providers/                         # ❌ DO NOT TOUCH
└── routes/
    └── app_router.dart                # UPDATE: fix GoRouter wiring
```

---

## 3. Screen-by-Screen Specifications

### 3.1 Onboarding Screen (NEW)

**File:** `lib/screens/onboarding_screen.dart`
**Trigger:** First launch only (store flag in SharedPreferences, NOT Firestore)
**Design reference:** CaFit welcome slides (Image 2 — left 3 screens)

```
┌─────────────────────────────┐
│                             │
│      [Illustration area]    │   ← Use a simple branded SVG
│      BetterAlt leaf/        │      or Lottie animation
│      mountain motif         │
│                             │
│                             │
│   ─────────────────────     │
│                             │
│    Welcome to BetterAlt     │   ← h1, structurePrimary
│    Fat Burner               │
│                             │
│    Track your supplement,   │   ← body, textSecondary
│    monitor your health,     │
│    see real results.        │
│                             │
│        ● ○ ○                │   ← Page indicator dots
│                             │
│   ┌───────────────────────┐ │
│   │      Get Started      │ │   ← 10% accent button
│   └───────────────────────┘ │
│                             │
└─────────────────────────────┘
```

**3 slides:**
1. "Track Your Supplement" — pill/supplement visual + "Never miss a day" copy
2. "Monitor Your Health" — heart/steps visual + "Steps, calories, sleep — all in one place"
3. "See Real Results" — chart visual + "Watch your progress over time"

**Behavior:**
- Swipeable PageView with smooth page indicator
- "Get Started" button on last slide → navigate to LoginScreen
- "Skip" text button on slides 1-2
- Save `hasSeenOnboarding: true` to SharedPreferences (local, not Firestore)

---

### 3.2 Login Screen (REWRITE)

**File:** `lib/screens/login_screen.dart`
**Preserves:** All Firebase Auth calls — `signInWithEmailAndPassword`, error handling
**Changes:** Visual layout only

```
┌─────────────────────────────┐
│                             │
│                             │
│    ┌──────┐                 │
│    │ LOGO │  BetterAlt●     │   ← Brand wordmark + green dot
│    └──────┘                 │
│                             │
│    Welcome back             │   ← h1
│    Sign in to continue      │   ← body, textSecondary
│                             │
│   ┌───────────────────────┐ │
│   │ 📧  Email             │ │   ← surfaceElevated bg, no border
│   └───────────────────────┘ │
│                             │
│   ┌───────────────────────┐ │
│   │ 🔒  Password       👁 │ │   ← toggle visibility
│   └───────────────────────┘ │
│                             │
│         Forgot password?    │   ← textTertiary, right aligned
│                             │
│   ┌───────────────────────┐ │
│   │       Sign In         │ │   ← ACCENT button (10% color)
│   └───────────────────────┘ │
│                             │
│   ── or continue with ──    │   ← divider with text
│                             │
│    [G]     [Apple]          │   ← future social login placeholders
│                             │
│   Don't have an account?    │
│   Sign Up                   │   ← accent colored text link
│                             │
└─────────────────────────────┘
```

**Key UI details:**
- Background: `canvasLight`
- Input fields: `surfaceElevated` fill, no outline border, `AppRadius.md` corners
- Sign In button: full-width, `accent` color, 14px vertical padding, `AppRadius.md`
- Error messages: appear below input field with `error` color, `caption` style
- Loading state: CircularProgressIndicator inside button (replaces text)
- Entry animation: `FadeInUp` from `animate_do` on the form section

**Backend integration (DO NOT CHANGE):**
```dart
// Keep this exact call — only change the widget wrapping it
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: _emailController.text.trim(),
  password: _passwordController.text.trim(),
);
```

---

### 3.3 Purchase Gate Screen (NEW)

**File:** `lib/screens/purchase_gate_screen.dart`
**Shows after:** Successful login, before MainScreen
**Uses:** Existing `PurchaseStatusProvider.checkPurchase(email, phone)` — call it, don't modify it

```
STATE: LOADING
┌─────────────────────────────┐
│                             │
│                             │
│                             │
│       [BetterAlt Logo]      │
│                             │
│    Verifying your           │   ← h2
│    purchase...              │
│                             │
│    ┌──────────────────┐     │
│    │  ████████░░░░░░  │     │   ← shimmer loading bar
│    └──────────────────┘     │
│                             │
│    This only takes a sec    │   ← caption, textTertiary
│                             │
└─────────────────────────────┘

STATE: VERIFIED (hasPurchased = true)
→ Auto-navigate to MainScreen (no screen shown)

STATE: NOT PURCHASED
┌─────────────────────────────┐
│                             │
│      [Supplement visual]    │
│                             │
│    Purchase Required        │   ← h1
│                             │
│    Get the BetterAlt Fat    │   ← body, textSecondary
│    Burner to unlock the     │
│    full tracking experience │
│                             │
│   ┌───────────────────────┐ │
│   │    Shop Now  →        │ │   ← accent button → opens Shopify URL
│   └───────────────────────┘ │
│                             │
│   ┌───────────────────────┐ │
│   │    Check Again        │ │   ← outlined/ghost button
│   └───────────────────────┘ │
│                             │
│       Sign Out              │   ← text link, textTertiary
│                             │
└─────────────────────────────┘
```

---

### 3.4 Main Screen Shell (REWRITE)

**File:** `lib/screens/main_screen.dart`
**Design reference:** CaFit bottom nav (Image 1 — see the bottom bar pattern)

**Current:** Default `BottomNavigationBar` with 4 items
**New:** Custom bottom nav with:
- 4 icons: Home (house), Steps (footprint), Calories (flame), Profile (person)
- Active item: `structurePrimary` icon + filled circle background
- Inactive: `textTertiary` icons
- No labels — icon-only for cleaner look (CaFit style)
- Thin top border: `borderLight` 0.5px

```
┌─────────────────────────────┐
│                             │
│     [Active Screen]         │
│                             │
│                             │
│                             │
├─────────────────────────────┤
│                             │
│   🏠      👣      🔥    👤  │   ← icon-only nav
│   ●                        │   ← dot indicator under active
│                             │
└─────────────────────────────┘
```

---

### 3.5 Home Screen — Dashboard (REWRITE)

**File:** `lib/screens/home_screen.dart`
**Design reference:** CaFit Home (Image 1 — first screen) + CaFit Scroll 6 (second screen)
**Data source:** Keep all existing Firestore reads + HealthService calls

```
┌─────────────────────────────┐
│                             │
│  Hello, {name}      [👤]    │   ← greeting_header widget
│  Today, 08 Apr              │      name from FirebaseAuth
│                             │
│  ┌─────────────────────────┐│
│  │  FAT BURNER CHECK-IN   ││   ← fat_burner_card widget
│  │                         ││
│  │  Did you take it today? ││
│  │                ┌──────┐ ││   ← Switch (existing Firestore toggle)
│  │                │ ●──  │ ││
│  │                └──────┘ ││
│  │                         ││
│  │  🔥 12 day streak      ││   ← computed from Firestore daily docs
│  └─────────────────────────┘│
│                             │
│  Today's Snapshot            │   ← section_header
│                             │
│  ┌──────────┐ ┌──────────┐  │
│  │ 🚶 Steps │ │ 🔥 Cal   │  │   ← stat_card × 4 in 2×2 grid
│  │          │ │          │  │      with health_ring inside
│  │  4,880   │ │  320     │  │   ← data from HealthService
│  │ /10,000  │ │ /2,000   │  │
│  │  [ring]  │ │  [ring]  │  │   ← circular progress indicator
│  └──────────┘ └──────────┘  │
│  ┌──────────┐ ┌──────────┐  │
│  │ 😴 Sleep │ │ ⚖ Weight │  │
│  │  7.5h    │ │  72 kg   │  │
│  │  [ring]  │ │  [ring]  │  │
│  └──────────┘ └──────────┘  │
│                             │
│  Weekly Steps                │   ← section_header + "See All"
│                             │
│  ┌─────────────────────────┐│
│  │  📈 Line chart          ││   ← weekly_chart widget
│  │  (fl_chart — green)     ││      CaFit wave-style chart
│  │                         ││
│  │  M  T  W  T  F  S  S   ││
│  └─────────────────────────┘│
│                             │
└─────────────────────────────┘
```

**Widget breakdown:**

#### `greeting_header.dart`
- Row: left = Column(greeting text, date), right = CircleAvatar
- Name: from `FirebaseAuth.instance.currentUser?.displayName ?? 'there'`
- Date: `DateFormat('EEE, dd MMM').format(DateTime.now())`
- Avatar: first letter of name in `structurePrimary` circle

#### `fat_burner_card.dart`
- Card with `structurePrimary` background, white text
- Contains the existing Switch toggle — **preserve the Firestore read/write logic exactly**
- Streak counter: query `users/{uid}/daily/` collection, count consecutive `fatBurnerTaken: true` days
- Visual: subtle gradient from `structurePrimary` to `structureSecondary`

#### `stat_card.dart`
- Accepts: `title`, `value`, `unit`, `goal`, `icon`, `color`
- Layout: icon top-left, title below, large stat number center, circular ring behind
- Ring: `percent_indicator` CircularPercentIndicator, `color` parameter
- Card background: `surfaceLight` with `borderLight` border

#### `health_ring.dart`
- Wraps `CircularPercentIndicator` from `percent_indicator` package
- Props: `percent` (0.0-1.0), `color`, `size`, `lineWidth`
- Animated on appear with `animate_do` FadeIn

#### `weekly_chart.dart`
- Wraps `fl_chart` LineChart
- CaFit-style: curved line, gradient fill below, dot markers on data points
- Props: `data` (List of doubles), `color`, `labels` (day strings)
- Gradient: color at 40% opacity → transparent at bottom
- Grid lines: hidden. Border: hidden. Clean minimal chart.

---

### 3.6 Steps Screen (REWRITE)

**File:** `lib/screens/steps_screen.dart`
**Design reference:** CaFit Home/Details - Scroll (Image 1 — third screen)

```
┌─────────────────────────────┐
│                             │
│  ← Steps           Daily ▾  │   ← app bar + period selector
│                             │
│  ┌─────────────────────────┐│
│  │      Today              ││
│  │  Thu, 08 April          ││
│  │                         ││
│  │  ┌─── wave chart ─────┐ ││   ← hourly step distribution
│  │  │                     │ ││
│  │  └─────────────────────┘ ││
│  │                         ││
│  │       4,880              ││   ← statLarge, structurePrimary
│  │    Total Steps  ▲14%    ││   ← caption + green badge
│  │                         ││
│  │  ┌───┐  ┌───┐  ┌───┐   ││
│  │  │480│  │2.4│  │4.84│   ││   ← 3 sub-stats in a row
│  │  │Cal│  │ km│  │ km │   ││
│  │  └───┘  └───┘  └───┘   ││
│  └─────────────────────────┘│
│                             │
│  This Week                   │
│                             │
│  ┌─────────────────────────┐│
│  │  Bar chart (7 days)     ││   ← vertical bars, accent color
│  │  ▓ ▓ ▓ ▓ █ ░ ░         ││      today highlighted
│  │  M T W T F S S         ││
│  └─────────────────────────┘│
│                             │
└─────────────────────────────┘
```

**Period selector:** SegmentedButton or custom chips — Daily / Weekly / Monthly
**Data:** From existing `HealthService.getTodaySteps()` — keep the call, just display differently
**Chart style:** Bar chart for weekly (CaFit style), line chart for monthly

---

### 3.7 Calories Screen (REWRITE)

**File:** `lib/screens/calories_screen.dart`
**Same layout pattern as Steps Screen** — swap:
- Color: `chartOrange` instead of `chartGreen`
- Icon: 🔥 flame
- Unit: kcal
- Data: from `HealthService.getTodayCaloriesBurned()`

---

### 3.8 Profile Screen (REWRITE)

**File:** `lib/screens/profile_screen.dart`
**Design reference:** CaFit Your Profile (Image 5 — first 3 screens)

```
┌─────────────────────────────┐
│                             │
│          [Avatar]           │   ← large CircleAvatar, 80px
│        {Display Name}       │   ← h2
│        {email}              │   ← caption, textTertiary
│                             │
│  ┌──────────┐ ┌──────────┐  │
│  │  12 day  │ │ Verified │  │   ← two stat pills
│  │  streak  │ │    ✓     │  │      purchase status badge
│  └──────────┘ └──────────┘  │
│                             │
│  ┌─────────────────────────┐│
│  │ 👤  Edit Profile      → ││
│  ├─────────────────────────┤│
│  │ 🔔  Notifications     → ││
│  ├─────────────────────────┤│
│  │ 🎯  Goals             → ││
│  ├─────────────────────────┤│
│  │ 📊  Export Data        → ││
│  ├─────────────────────────┤│
│  │ ❓  Help & Support    → ││
│  ├─────────────────────────┤│
│  │ 📜  Privacy Policy    → ││
│  └─────────────────────────┘│
│                             │
│  ┌─────────────────────────┐│
│  │      Sign Out           ││   ← outlined button, error color
│  └─────────────────────────┘│
│                             │
│   v1.0.0 — BetterAlt        │   ← caption, textTertiary
│                             │
└─────────────────────────────┘
```

**Sign Out:** Keep existing `FirebaseAuth.instance.signOut()` — only change the button style

---

## 4. Reusable Widget Specifications

### 4.1 `stat_card.dart`

```dart
/// Reusable health metric card with circular progress ring
///
/// Usage:
/// StatCard(
///   title: 'Steps',
///   value: '4,880',
///   unit: 'steps',
///   goal: 10000,
///   current: 4880,
///   icon: Icons.directions_walk,
///   color: AppColors.chartGreen,
/// )
```

**Visual spec:**
- Size: fills half width in a 2-column GridView
- Padding: 16px all sides
- Background: `surfaceLight` (light) / `surfaceDark` (dark)
- Border: 0.5px `borderLight`
- Corner radius: `AppRadius.card` (20)
- Title: `caption` style, `textTertiary` color, ALL CAPS
- Value: `statMedium` style, `textPrimary`
- Ring: 60px diameter, 6px stroke width, `color` parameter
- Ring track: `surfaceElevated` at 40% opacity

### 4.2 `fat_burner_card.dart`

**Visual spec:**
- Full width card
- Background: LinearGradient from `structurePrimary` → `structureSecondary`
- Corner radius: `AppRadius.card` (20)
- Padding: 20px
- Title: "Fat Burner Check-In" — `h3` style, white
- Subtitle: "Did you take it today?" — `body` style, white70
- Switch: CupertinoSwitch with `accent` active color
- Streak: row with 🔥 emoji + "{n} day streak" in `caption`, white60
- **The Switch onChanged callback must remain exactly as-is** — it writes to Firestore

### 4.3 `weekly_chart.dart`

**Visual spec (CaFit-inspired):**
- LineChart from `fl_chart`
- Line: curved (`isCurved: true`), 2.5px width, `color` parameter
- Fill: gradient from `color.withOpacity(0.3)` → `color.withOpacity(0.0)`
- Dots: show on each data point, 4px radius, white fill, 2px `color` border
- Grid: hidden
- Border: hidden
- Left axis: hidden (show values on tooltip only)
- Bottom axis: day labels in `caption` style, `textTertiary`
- Touch: show tooltip with value on touch
- Height: 180px

---

## 5. Routing Fix (GoRouter)

**File:** `lib/routes/app_router.dart` — UPDATE
**File:** `lib/main.dart` — UPDATE (router config only)

### Current Problem
`MaterialApp` uses `home: AuthGate()` but `LoginScreen` calls `context.go(AppRouter.dashboard)` which crashes because GoRouter is not the active router.

### Fix (Option A — recommended)

```dart
// main.dart — CHANGE ONLY THESE LINES:
// FROM:
MaterialApp(
  home: AuthGate(),
  theme: ...,
)

// TO:
MaterialApp.router(
  routerConfig: AppRouter.router,
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
)
```

```dart
// app_router.dart — REWRITE with auth redirect
import 'package:firebase_auth/firebase_auth.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnSignup = state.matchedLocation == '/signup';
      final isOnOnboarding = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isOnLogin && !isOnSignup && !isOnOnboarding) {
        return '/login';
      }
      if (isLoggedIn && (isOnLogin || isOnSignup)) {
        return '/verify'; // purchase gate
      }
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(path: '/verify', builder: (_, __) => const PurchaseGateScreen()),
      ShellRoute(
        builder: (_, __, child) => MainScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/steps', builder: (_, __) => const StepsScreen()),
          GoRoute(path: '/calories', builder: (_, __) => const CaloriesScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
}
```

**This preserves:**
- `FirebaseAuth.instance.currentUser` check (no change to auth logic)
- `AuthGate` behavior moved into GoRouter's `redirect` (same logic, different location)

---

## 6. Animation & Motion Spec

### Entry Animations (per screen)
| Element | Animation | Duration | Delay |
|---------|-----------|----------|-------|
| Greeting header | FadeInDown | 400ms | 0ms |
| Fat burner card | FadeInUp | 500ms | 100ms |
| Stat cards (each) | FadeInUp | 400ms | 150ms stagger |
| Weekly chart | FadeIn | 600ms | 300ms |
| Profile avatar | FadeIn + Scale | 400ms | 0ms |

### Transitions
| Navigation | Transition |
|-----------|-----------|
| Tab switch | Crossfade (200ms) |
| Push to detail | SlideTransition from right (300ms) |
| Login → Verify | FadeTransition (400ms) |
| Verify → Home | FadeTransition (400ms) |

### Micro-interactions
| Element | Interaction |
|---------|-----------|
| Fat burner toggle | Haptic feedback + scale bounce (100ms) |
| Stat card tap | Scale down 0.97 → back to 1.0 (150ms) |
| Bottom nav icon | Scale 1.0 → 1.15 → 1.0 on selection (200ms) |
| Chart touch | Tooltip fade in (150ms) |

---

## 7. Dark Mode Mapping

| Light | Dark |
|-------|------|
| `canvasLight` (#F7F7F2) | `canvasDark` (#0F1410) |
| `surfaceLight` (#FFFFFF) | `surfaceDark` (#1A2118) |
| `surfaceElevated` (#F0F0EA) | `surfaceElevatedDk` (#232E22) |
| `borderLight` (#E2E2DA) | `borderDark` (#2E3A2C) |
| `textPrimary` (#1A1F18) | `textOnDark` (#E8EAE2) |
| `textSecondary` (#5F6350) | `textOnDarkMuted` (#9BA38E) |
| `structurePrimary` stays | `accent` becomes primary |

The fat burner card gradient and accent color remain the same in both modes.

---

## 8. Implementation Order

```
Phase 1 — Foundation (do first)
├── Create lib/theme/ folder + all 4 files
├── Update main.dart (theme + router config ONLY)
├── Fix app_router.dart
└── Test: app launches, auth redirect works, theme applies

Phase 2 — Widgets
├── Create lib/widgets/ folder
├── Build stat_card.dart
├── Build health_ring.dart
├── Build fat_burner_card.dart (with existing Firestore toggle)
├── Build weekly_chart.dart
├── Build greeting_header.dart
├── Build bottom_nav_bar.dart
└── Test: widgets render in isolation

Phase 3 — Screens
├── Rewrite home_screen.dart (compose from widgets)
├── Rewrite steps_screen.dart
├── Rewrite calories_screen.dart
├── Rewrite profile_screen.dart
├── Rewrite login_screen.dart
├── Build signup_screen.dart (split from login)
├── Build onboarding_screen.dart
├── Build purchase_gate_screen.dart
├── Rewrite main_screen.dart (new nav shell)
└── Test: full flow login → verify → home → tabs → profile → logout

Phase 4 — Polish
├── Add entry animations (animate_do)
├── Add shimmer loading states
├── Verify dark mode on all screens
├── Test on iOS simulator + Android emulator
└── Screenshot comparison against CaFit reference
```

---

## 9. Files Changed Summary

| File | Action | Backend Impact |
|------|--------|---------------|
| `lib/main.dart` | UPDATE (theme + router) | NONE |
| `lib/theme/*` | NEW (4 files) | NONE |
| `lib/widgets/*` | NEW (8 files) | NONE |
| `lib/screens/home_screen.dart` | REWRITE | NONE — same Firestore calls |
| `lib/screens/steps_screen.dart` | REWRITE | NONE — same data binding |
| `lib/screens/calories_screen.dart` | REWRITE | NONE — same data binding |
| `lib/screens/profile_screen.dart` | REWRITE | NONE — same auth calls |
| `lib/screens/login_screen.dart` | REWRITE | NONE — same Firebase Auth |
| `lib/screens/signup_screen.dart` | NEW (split) | NONE — same Firebase Auth |
| `lib/screens/onboarding_screen.dart` | NEW | NONE |
| `lib/screens/purchase_gate_screen.dart` | NEW | NONE — calls existing provider |
| `lib/screens/main_screen.dart` | REWRITE | NONE |
| `lib/routes/app_router.dart` | UPDATE | NONE — same auth check |
| `pubspec.yaml` | UPDATE (4 UI packages) | NONE |
| `lib/services/*` | ❌ NO CHANGE | — |
| `lib/providers/*` | ❌ NO CHANGE | — |
| `functions/*` | ❌ NO CHANGE | — |
| `firebase.json` | ❌ NO CHANGE | — |
| `android/` config | ❌ NO CHANGE | — |