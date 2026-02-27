# Atithi GLMS — Setup Guide

## Prerequisites
- Flutter SDK ≥ 3.3.0 installed and in PATH
- Android Studio or Xcode (for device/emulator)

## Steps to run

### 1. Create Flutter project scaffold
```bash
# In the parent directory of this project
flutter create atithi_glms --org com.atithi
cd atithi_glms
```

Then copy all files from this directory into the new `atithi_glms/` folder, replacing `pubspec.yaml` and the `lib/` folder.

**Or** — if you want to use THIS directory as the Flutter project, run:
```bash
flutter create . --org com.atithi
```
This will add the missing platform folders (android/, ios/, etc.) without touching lib/.

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Generate Drift database code
```bash
dart run build_runner build --delete-conflicting-outputs
```
This generates `lib/data/database/app_database.g.dart` and all `*.g.dart` DAO files.

### 4. Run the app
```bash
flutter run
```

## Package Notes
- **Syncfusion XlsIO**: Free under Syncfusion Community License (revenue < $1M/year).
  Register at https://www.syncfusion.com/products/communitylicense
- **drift + drift_flutter**: MIT license, no registration needed
- **sqlite3_flutter_libs**: Bundles SQLite for Android/iOS automatically

## Architecture
```
lib/
  main.dart                    # Entry point, ProviderScope setup
  app.dart                     # MaterialApp + named route generator
  data/
    database/
      app_database.dart        # Drift schema (8 tables)
      daos/                    # Data Access Objects
    providers/
      database_provider.dart   # Riverpod DB singleton
    repositories/              # Business logic layer
  features/
    events/                    # Home screen, Event setup
    dashboard/                 # Event dashboard
    hotels/                    # Hotel setup, Room inventory
    guests/                    # Guest list, Detail, Check-in/out flows
    billing/                   # Service logging, Billing view, Service types
    export/                    # Excel export (4 report types)
  shared/
    theme/                     # Material 3 theme
    widgets/                   # Reusable UI components
```

## Key Implementation Notes (from Tech Spec)
1. **Undo Checkout**: Timer is persisted in `checkout_undo_windows` table.
   Call `guestsRepository.processExpiredUndoWindows()` on app resume.
2. **Guest List**: Uses `ListView.builder` (lazy) — handles 2000 guests.
3. **Excel Export**: Runs in `compute()` isolate — no UI freezing.
4. **CSV Import**: Validates headers before committing to DB.
