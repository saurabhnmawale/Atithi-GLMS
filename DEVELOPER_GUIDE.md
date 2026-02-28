# Atithi GLMS — Developer Guide

> **Atithi** (अतिथि) means "guest" in Sanskrit.
> GLMS = Guest Lifecycle Management System.

This guide gives a new developer a complete understanding of the product: what it does, how it is architected, every data flow, every screen, and how to extend it safely.

---

## Table of Contents

1. [What the Product Does](#1-what-the-product-does)
2. [Tech Stack](#2-tech-stack)
3. [Project Structure](#3-project-structure)
4. [Database Schema](#4-database-schema)
5. [Data Layer Architecture](#5-data-layer-architecture)
6. [State Management](#6-state-management)
7. [Routing](#7-routing)
8. [Feature Walkthroughs](#8-feature-walkthroughs)
9. [Key Data Flows](#9-key-data-flows)
10. [Shared UI System](#10-shared-ui-system)
11. [Getting Started Locally](#11-getting-started-locally)
12. [How to Add a New Feature](#12-how-to-add-a-new-feature)
13. [Bug Log](#13-bug-log)

---

## 1. What the Product Does

Atithi GLMS is a **standalone, offline-first mobile app** (Android + iOS) for a single hospitality coordinator managing guests across multiple hotels at a large event (weddings, corporate events, etc.).

### Core Workflow

```
Create Event
    │
    ├── Add Hotels & Rooms (room numbers, categories, statuses)
    │
    ├── Add Guests (manually or import via CSV)
    │        │
    │        ├── Check In  ──► Select hotel ──► Select matching room ──► Room marked occupied
    │        │
    │        ├── Log Service Charges (minibar, laundry, room service, etc.)
    │        │
    │        ├── Change Room / Transfer to Another Hotel
    │        │
    │        └── Check Out ──► Room freed ──► Bill locked after 5-min undo window
    │
    └── Export Reports (.xlsx via share sheet)
         ├── Per-Guest Itemized Bills
         ├── Per-Hotel Billing Summary
         ├── Consolidated Event Billing
         └── Guest Movement & Room History
```

### What it is NOT
- Not a hotel PMS (no reservations, no payments, no online booking)
- Not multi-user / cloud-synced (single device, SQLite local database)
- Not a check-in kiosk (coordinator-operated only)

---

## 2. Tech Stack

| Concern | Technology |
|---------|-----------|
| Framework | Flutter (Dart) |
| Min SDK | Dart `>=3.3.0`, Android API 21+, iOS 12+ |
| Database | SQLite via **Drift** ORM (`drift: ^2.19.1`) |
| State Management | **Flutter Riverpod** v2 (`flutter_riverpod: ^2.5.1`) |
| Excel Export | **Syncfusion Flutter XlsIO** (`syncfusion_flutter_xlsio: ^25.1.35`) |
| File Sharing | **share_plus** (`^12.0.1`) |
| File Picking (CSV import) | **file_picker** (`^8.1.2`) |
| CSV Parsing | **csv** (`^6.0.0`) |
| Temp file paths | **path_provider** (`^2.1.3`) |
| Date formatting | **intl** (`^0.19.0`) |
| UI | Material Design 3 |

### Key Drift Packages
- `drift`: the ORM core
- `drift_flutter`: platform-specific SQLite connection (`driftDatabase()`)
- `sqlite3_flutter_libs`: bundles the native SQLite3 binary for Android/iOS
- `drift_dev` + `build_runner`: code generation (run after schema changes)

---

## 3. Project Structure

```
lib/
├── main.dart                          # Entry point — DB init + ProviderScope
├── app.dart                           # MaterialApp, AppRoutes, AppRouter
│
├── data/
│   ├── database/
│   │   ├── app_database.dart          # Table definitions + @DriftDatabase
│   │   ├── app_database.g.dart        # GENERATED — do not edit
│   │   └── daos/
│   │       ├── events_dao.dart        # Event CRUD + duplicateEvent transaction
│   │       ├── hotels_dao.dart        # Hotel + Room CRUD + watchRoomsForEvent
│   │       ├── guests_dao.dart        # Guest lifecycle transactions
│   │       ├── service_dao.dart       # Service types + charges + billing totals
│   │       └── *.g.dart               # GENERATED mixin files
│   │
│   ├── providers/
│   │   └── database_provider.dart     # Riverpod provider for AppDatabase instance
│   │
│   └── repositories/
│       ├── events_repository.dart     # Events business logic wrapper
│       ├── hotels_repository.dart     # Hotels + Rooms business logic wrapper
│       ├── guests_repository.dart     # Guest lifecycle wrapper
│       └── billing_repository.dart    # Service types + charges wrapper
│
├── features/
│   ├── events/
│   │   ├── screens/
│   │   │   ├── home_screen.dart       # Event list (active + archived)
│   │   │   └── event_setup_screen.dart # Create / edit event
│   │   └── providers/
│   │       └── events_provider.dart
│   │
│   ├── dashboard/
│   │   └── screens/
│   │       └── event_dashboard_screen.dart  # Stats + quick-action grid
│   │
│   ├── hotels/
│   │   ├── screens/
│   │   │   ├── hotel_setup_screen.dart      # Create / edit hotel + bulk room entry
│   │   │   └── room_inventory_screen.dart   # All rooms with filtering + status change
│   │   └── providers/
│   │       └── hotels_provider.dart
│   │
│   ├── guests/
│   │   ├── screens/
│   │   │   ├── guest_list_screen.dart       # Guest list, search, filter, CSV import
│   │   │   ├── guest_detail_screen.dart     # Guest profile, actions, stay history
│   │   │   ├── checkin_flow_screen.dart     # 2-step check-in (hotel → room)
│   │   │   ├── checkout_flow_screen.dart    # Bill review + confirm checkout
│   │   │   ├── room_change_flow_screen.dart # Change room within same/different hotel
│   │   │   └── guest_transfer_flow_screen.dart  # Transfer to another hotel
│   │   └── providers/
│   │       └── guests_provider.dart
│   │
│   ├── billing/
│   │   ├── screens/
│   │   │   ├── billing_view_screen.dart     # Full itemized bill for a guest
│   │   │   ├── service_logging_screen.dart  # Log a service charge
│   │   │   └── service_type_config_screen.dart  # Manage service type names
│   │   └── providers/
│   │       └── billing_provider.dart
│   │
│   └── export/
│       ├── screens/
│       │   └── export_screen.dart           # 4 export type buttons
│       └── services/
│           └── export_service.dart          # xlsx generation + share_plus
│
└── shared/
    ├── theme/
    │   └── app_theme.dart             # Colors, ThemeData, RoomStatusHelper, GuestStatusHelper
    └── widgets/
        └── common_widgets.dart        # StatCard, EmptyState, StatusBadge, etc.
```

---

## 4. Database Schema

All tables are defined in `lib/data/database/app_database.dart`. Drift generates the corresponding `DataClass` and `Companion` types into `app_database.g.dart`.

### Entity Relationship Diagram

```
Events
  │
  ├──── Hotels  (eventId → Events.id)
  │       │
  │       └──── Rooms  (hotelId → Hotels.id)
  │
  ├──── Guests  (eventId → Events.id)
  │       │  currentHotelId → Hotels.id  (nullable)
  │       │  currentRoomId  → Rooms.id   (nullable)
  │       │
  │       ├──── StaySegments  (guestId, hotelId, roomId)
  │       │
  │       ├──── ServiceCharges  (guestId, typeId)
  │       │
  │       └──── CheckoutUndoWindows  (guestId PK — one per guest)
  │
  └──── ServiceTypes  (eventId → Events.id)
```

### Table Definitions

#### `Events`
| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `name` | TEXT | e.g. "Sharma Wedding 2025" |
| `type` | TEXT | `'wedding'` or `'corporate'` |
| `startDate` | DATETIME | |
| `endDate` | DATETIME | |
| `createdAt` | DATETIME | default = now |
| `isArchived` | BOOLEAN | default = false |

#### `Hotels`
| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `eventId` | INTEGER FK → Events | |
| `name` | TEXT | |

#### `Rooms`
| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `hotelId` | INTEGER FK → Hotels | |
| `number` | TEXT | Room number as string e.g. "101" |
| `category` | TEXT | `Standard` / `Deluxe` / `Suite` / `Premium` / `Executive` |
| `status` | TEXT | `'available'` / `'occupied'` / `'maintenance'` — default `'available'` |

#### `Guests`
| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `eventId` | INTEGER FK → Events | |
| `name` | TEXT | |
| `assignedCategory` | TEXT | Matches a room category |
| `isVip` | BOOLEAN | default false |
| `isCloseRelative` | BOOLEAN | default false |
| `specialRequests` | TEXT nullable | |
| `status` | TEXT | `'not_checked_in'` / `'checked_in'` / `'checked_out'` |
| `currentHotelId` | INTEGER FK nullable | Only set when `checked_in` |
| `currentRoomId` | INTEGER FK nullable | Only set when `checked_in` |

#### `StaySegments`
Each check-in creates one segment. Room changes close the current segment and open a new one.

| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `guestId` | INTEGER FK → Guests | |
| `hotelId` | INTEGER FK → Hotels | |
| `roomId` | INTEGER FK → Rooms | |
| `checkInAt` | DATETIME | |
| `checkOutAt` | DATETIME nullable | null = segment is still open |

#### `ServiceTypes`
Named billing categories defined per event (e.g. Minibar, Laundry).

| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `eventId` | INTEGER FK → Events | |
| `name` | TEXT | |

#### `ServiceCharges`
Individual charge entries per guest.

| Column | Type | Notes |
|--------|------|-------|
| `id` | INTEGER PK autoincrement | |
| `guestId` | INTEGER FK → Guests | |
| `typeId` | INTEGER FK → ServiceTypes | |
| `amount` | REAL | in Rupees |
| `loggedAt` | DATETIME | default = now |
| `isLocked` | BOOLEAN | true after 5-min undo window expires |

#### `CheckoutUndoWindows`
One row per checked-out guest, deleted when undo succeeds or expires.

| Column | Type | Notes |
|--------|------|-------|
| `guestId` | INTEGER PK FK → Guests | |
| `checkoutAt` | DATETIME | |
| `expiresAt` | DATETIME | checkoutAt + 5 minutes |

---

## 5. Data Layer Architecture

The data layer follows a strict three-tier pattern:

```
Screen / Widget
      │  ref.watch(someProvider)
      ▼
  Riverpod Provider   (lib/features/*/providers/)
      │  calls repository methods
      ▼
  Repository          (lib/data/repositories/)
      │  thin wrapper — delegates to DAO
      ▼
  DAO                 (lib/data/database/daos/)
      │  type-safe Drift queries against AppDatabase
      ▼
  AppDatabase / SQLite
```

### Why This Structure?
- **DAOs** own all SQL/Drift logic. They can be tested in isolation.
- **Repositories** are the public API for features — they may combine multiple DAO calls and contain business logic (e.g. `updateGuestTags` reads before writing).
- **Providers** expose repositories and derived streams to the UI layer. Screens never import DAOs directly.

### DAOs Summary

| DAO | Tables Accessed | Key Complexity |
|-----|----------------|----------------|
| `EventsDao` | Events, Hotels, Rooms, Guests, ServiceTypes | `duplicateEvent` transaction copies entire event template |
| `HotelsDao` | Hotels, Rooms | `watchRoomsForEvent` join query (see Bug 1) |
| `GuestsDao` | Guests, StaySegments, Rooms, Hotels, CheckoutUndoWindows | All lifecycle ops are full DB transactions |
| `ServiceDao` | ServiceTypes, ServiceCharges | `watchRunningTotal` is a stream-mapped fold |

### Important: Code Generation

After any change to `app_database.dart` or any DAO `@DriftAccessor` definition, you **must** regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The generated files (`*.g.dart`) must never be manually edited.

---

## 6. State Management

The app uses **Riverpod v2** exclusively. All providers are defined at the feature level.

### Provider Types Used

| Type | Used For |
|------|---------|
| `Provider<T>` | Synchronous singleton (repositories) |
| `StreamProvider.family<T, Arg>` | Reactive DB streams scoped to an ID |
| `FutureProvider.family<T, Arg>` | One-shot async reads (rare) |

### Provider Map

```
databaseProvider (Provider<AppDatabase>)          ← overridden in main.dart
       │
       ├── eventsRepositoryProvider  ──► allEventsProvider, eventByIdProvider
       │
       ├── hotelsRepositoryProvider  ──► hotelsForEventProvider
       │                                roomsForEventProvider
       │                                roomsForHotelProvider
       │
       ├── guestsRepositoryProvider  ──► guestsForEventProvider
       │                                guestByIdProvider
       │                                staySegmentsProvider
       │                                undoWindowProvider
       │
       └── billingRepositoryProvider ──► serviceTypesProvider
                                        chargesForGuestProvider
                                        runningTotalProvider
```

### How Reactivity Works

Drift's `.watch()` emits a new `List<T>` every time the underlying table changes. Riverpod's `StreamProvider` subscribes to that stream and rebuilds any widget that called `ref.watch()`. No manual state management or `setState` is required for data that comes from the database.

`setState` is used only for ephemeral UI state (selected items in a multi-step form, loading booleans, search text).

### The `databaseProvider` Override Pattern

```dart
// main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();          // single instance for app lifetime
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),  // inject into provider graph
      ],
      child: const AtithiApp(),
    ),
  );
}
```

`databaseProvider` itself throws if not overridden — this forces correct initialization and makes the injection point explicit.

---

## 7. Routing

All routes are defined in `lib/app.dart`.

### Route Table

| Route Constant | Path | Screen | Required Args |
|---------------|------|--------|--------------|
| `AppRoutes.home` | `/` | `HomeScreen` | none |
| `AppRoutes.eventSetup` | `/event-setup` | `EventSetupScreen` | `eventId` (int, optional — null = create new) |
| `AppRoutes.eventDashboard` | `/event-dashboard` | `EventDashboardScreen` | `eventId` (int) |
| `AppRoutes.hotelSetup` | `/hotel-setup` | `HotelSetupScreen` | `eventId` (int), `hotelId` (int, optional) |
| `AppRoutes.roomInventory` | `/room-inventory` | `RoomInventoryScreen` | `eventId` (int) |
| `AppRoutes.guestList` | `/guest-list` | `GuestListScreen` | `eventId` (int) |
| `AppRoutes.guestDetail` | `/guest-detail` | `GuestDetailScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.checkinFlow` | `/checkin` | `CheckinFlowScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.checkoutFlow` | `/checkout` | `CheckoutFlowScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.roomChangeFlow` | `/room-change` | `RoomChangeFlowScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.guestTransferFlow` | `/guest-transfer` | `GuestTransferFlowScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.serviceLogging` | `/service-logging` | `ServiceLoggingScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.billingView` | `/billing-view` | `BillingViewScreen` | `guestId` (int), `eventId` (int) |
| `AppRoutes.serviceTypeConfig` | `/service-type-config` | `ServiceTypeConfigScreen` | `eventId` (int) |
| `AppRoutes.exportScreen` | `/export` | `ExportScreen` | `eventId` (int) |

### How to Navigate

```dart
// Navigate to a screen
Navigator.pushNamed(
  context,
  AppRoutes.guestDetail,
  arguments: {'guestId': 42, 'eventId': 1},
);

// Navigate and replace (e.g. after creating an event)
Navigator.pushReplacementNamed(
  context,
  AppRoutes.eventDashboard,
  arguments: {'eventId': newId},
);
```

All arguments are passed as `Map<String, dynamic>` and unpacked in `AppRouter.generateRoute`.

---

## 8. Feature Walkthroughs

### 8.1 Events (`features/events/`)

**Home Screen** — Lists all events split into Active and Archived sections. Each event card shows name, type badge (Wedding / Corporate) and date range. A `PopupMenuButton` offers Edit, Duplicate, Archive/Unarchive.

**Duplicate Event** — `EventsDao.duplicateEvent()` is a full transaction that copies: the event record, all hotels, all rooms (reset to `available`), and all service types. It does NOT copy guests or billing.

**Event Setup Screen** — Shared for create and edit. On create, navigates to the dashboard on save. On edit, pops back.

---

### 8.2 Dashboard (`features/dashboard/`)

**Event Dashboard Screen** — A read-only summary screen. Watches three streams simultaneously:
- `roomsForEventProvider` → computes total / available / occupied / maintenance counts
- `guestsForEventProvider` → computes checked-in / checked-out / not-checked-in counts

Below the stats grid is a `_ActionGrid` of 5 quick-action tiles that push to the main feature screens.

---

### 8.3 Hotels & Rooms (`features/hotels/`)

**Hotel Setup Screen** — Dual-mode (create/edit). The UI has:
1. A hotel name field
2. A dynamically growing list of `_RoomEntry` rows (room number + category dropdown)
3. On save: first inserts the hotel, then calls `addRoomsBulk()` for new rooms

In edit mode, `_loadExisting()` fetches the hotel and pre-populates existing rooms. Existing rooms are updated individually; new rows are inserted.

**Room Inventory Screen** — Shows every room across all event hotels. Three filter bars:
- By hotel (chips from `hotelsForEventProvider`)
- By status (Any / Available / Occupied / Maintenance)
- By category (derived from distinct categories in the room list)

A summary strip always shows totals across the unfiltered list. Each room tile has a `PopupMenuButton` to manually change status (useful for maintenance flags).

---

### 8.4 Guests (`features/guests/`)

**Guest List Screen** — Shows all guests with search and filter chips (status, VIP, Close Relative). Has two toolbar buttons:
- **Import CSV** — picks a `.csv` file, parses it, shows a preview dialog, then bulk-inserts. Required CSV columns: `name`, `category`. Optional: `vip`, `close_relative`, `special_requests`.
- **Add Guest** — modal bottom sheet with name + category dropdown.

**Guest Detail Screen** — The central hub for a guest. Shows:
- Status badge + VIP/Close Relative tags (editable via edit button)
- Running bill total with "View" link to BillingViewScreen
- Action buttons that change based on guest status:
  - `not_checked_in` → Check In
  - `checked_in` → Log Service Charge, Change Room, Transfer to Another Hotel, Check Out
  - `checked_out` → "Guest has checked out" (no actions)
- Undo banner with live countdown when a checkout undo window is active
- Stay history list (all `StaySegment` records)

**Check-In Flow Screen** — Two-step form:
1. Select a hotel from the event's hotels
2. Select an available room matching the guest's `assignedCategory`

Confirm button is disabled until both are selected. On confirm, calls `GuestsRepository.checkIn()` which runs a 3-write transaction (guest status, stay segment, room status).

**Checkout Flow Screen** — Shows the full itemized bill before committing. Warns the user about the 5-minute undo window. On confirm, calls `GuestsRepository.checkOut()`.

**Room Change Flow Screen** — Same 2-step hotel → room UI as check-in. Excludes the guest's current room from the available rooms list. Calls `GuestsRepository.changeRoom()` which is a transaction that closes the old stay segment, frees the old room, opens a new segment, and occupies the new room.

**Guest Transfer Flow Screen** — Functionally identical to Room Change (reuses the same pattern) but labelled as a hotel transfer for UX clarity.

---

### 8.5 Billing (`features/billing/`)

**Service Type Config Screen** — CRUD list of service type names scoped to an event (e.g. Minibar, Laundry, Room Service). Types are event-specific so different events can have different menus.

**Service Logging Screen** — Two-field form: pick a service type, enter an amount. Calls `BillingRepository.logCharge()`. Only accessible when the guest is `checked_in`.

**Billing View Screen** — Full itemized charge list with timestamps. Shows a "Locked" badge when the guest is checked out. Unlocked charges have a delete button. A FAB shortcuts to Service Logging for checked-in guests.

**Bill Locking Logic:**
- After checkout, a `CheckoutUndoWindow` row is created with `expiresAt = now + 5 min`.
- While active, the guest detail screen shows an undo banner with a live countdown (`Timer.periodic`).
- If undo is not used, `processExpiredUndoWindows()` is called (triggered by the countdown reaching zero) — it sets `isLocked = true` on all `ServiceCharge` rows for that guest and deletes the undo window.

---

### 8.6 Export (`features/export/`)

**Export Screen** — Four export cards. Tapping one calls `ExportService.export(type)`.

**Export Service** — Generates an `.xlsx` file using Syncfusion XlsIO, writes it to a temp directory, and shares it via `share_plus` (system share sheet).

**Export Types:**

| Type | What it generates |
|------|-------------------|
| `guestBills` | One worksheet per guest — service charges, amounts, timestamps, total |
| `hotelSummary` | One worksheet per hotel — guests who stayed there, their charges, subtotals |
| `consolidatedBilling` | Single sheet — all guests, hotel count, total charges, grand total |
| `guestMovement` | Single sheet — all stay segments: guest, hotel, room, check-in/out times, duration |

**Important constraint:** `ExportService` must run on the main isolate. Do not wrap it in `compute()` — `AppDatabase` holds FFI SQLite handles that cannot cross isolate boundaries (see Bug 2B).

---

## 9. Key Data Flows

### 9.1 Check-In Transaction

```
CheckinFlowScreen._confirmCheckin()
    │
    └── guestsRepositoryProvider.checkIn(guestId, hotelId, roomId)
            │
            └── GuestsDao.checkInGuest()  ← DB transaction
                    ├── UPDATE guests SET status='checked_in',
                    │       currentHotelId=hotelId, currentRoomId=roomId
                    │       WHERE id=guestId
                    │
                    ├── INSERT INTO staySegments (guestId, hotelId, roomId, checkInAt)
                    │
                    └── UPDATE rooms SET status='occupied' WHERE id=roomId

All Drift .watch() streams on guests + rooms + staySegments emit updated lists.
Riverpod rebuilds all dependent widgets automatically.
```

### 9.2 Checkout + Undo Flow

```
CheckoutFlowScreen._checkout()
    │
    └── guestsRepositoryProvider.checkOut(guestId)
            │
            └── GuestsDao.checkOutGuest()  ← DB transaction
                    ├── UPDATE staySegments SET checkOutAt=now WHERE guestId=? AND checkOutAt IS NULL
                    ├── UPDATE rooms SET status='available' WHERE id=currentRoomId
                    ├── UPDATE guests SET status='checked_out', currentHotelId=NULL, currentRoomId=NULL
                    └── INSERT OR REPLACE INTO checkoutUndoWindows (guestId, checkoutAt, expiresAt=now+5min)

GuestDetailScreen watches undoWindowProvider → shows undo banner
Timer.periodic decrements countdown every second
  └── on zero: guestsRepositoryProvider.processExpiredUndoWindows()
                    └── GuestsDao.processExpiredUndoWindows()
                            ├── UPDATE serviceCharges SET isLocked=true WHERE guestId IN (expired windows)
                            └── DELETE FROM checkoutUndoWindows WHERE guestId IN (expired windows)

If UNDO tapped (within 5 min):
    guestsRepositoryProvider.undoCheckout(guestId, hotelId, roomId)
        └── GuestsDao.undoCheckout()  ← DB transaction
                ├── Verify window exists and not expired
                ├── UPDATE staySegments SET checkOutAt=NULL (most recent segment)
                ├── UPDATE rooms SET status='occupied'
                ├── UPDATE guests SET status='checked_in', currentHotelId, currentRoomId
                └── DELETE FROM checkoutUndoWindows
```

### 9.3 Room Inventory Reactive Stream

```
RoomInventoryScreen
    │  ref.watch(roomsForEventProvider(eventId))
    ▼
hotelsRepositoryProvider.watchRoomsForEvent(eventId)
    ▼
HotelsDao.watchRoomsForEvent(eventId)
    │
    └── SELECT rooms.* FROM rooms
        INNER JOIN hotels ON hotels.id = rooms.hotelId
        WHERE hotels.eventId = ?
        .watch()   ← single infinite stream, reacts to all inserts/updates in rooms OR hotels
```

This is a joined Drift query. Any hotel or room change causes the stream to re-emit, rebuilding the inventory list. (See Bug 1 for the previous broken implementation using `asyncExpand`.)

### 9.4 CSV Import Flow

```
GuestListScreen._importCsv()
    │
    ├── FilePicker.platform.pickFiles(withData: true, type: csv)
    │       └── Returns PlatformFile with .path (Android) or .bytes (iOS sandboxed)
    │
    ├── Read content: File(path).readAsString() OR String.fromCharCodes(bytes)
    │
    ├── CsvToListConverter().convert(content)
    │
    ├── Map rows to {name, category, vip, close_relative, special_requests}
    │
    ├── Show preview dialog (first 10 rows)
    │
    └── guestsRepositoryProvider.importGuests(eventId, rows)
            └── GuestsDao.insertGuests(bulk insert via batch)
```

### 9.5 Export Flow

```
ExportScreen._export(type)
    │
    └── ExportService.export(type)
            │
            ├── _generate(params)  ← runs on main isolate (no compute())
            │       ├── Fetch all needed data via DAOs (.get() futures, not streams)
            │       ├── Create Workbook, add worksheets, write cells
            │       └── Return Uint8List bytes
            │
            ├── getTemporaryDirectory()
            ├── File.writeAsBytes(bytes)  → /tmp/filename.xlsx
            └── Share.shareXFiles([XFile(path)])  → system share sheet
```

---

## 10. Shared UI System

### Colors (`AppTheme`)

| Constant | Hex | Used For |
|---------|-----|---------|
| `primary` | `#1A56DB` | Buttons, AppBar, active filters, main accent |
| `primaryDark` | `#1343B0` | — |
| `accent` | `#F59E0B` | Wedding type badge |
| `success` | `#10B981` | Available rooms, checked-in guests |
| `warning` | `#F59E0B` | Maintenance rooms, undo banner |
| `error` | `#EF4444` | Occupied rooms, checkout button, delete actions |
| `vipGold` | `#D97706` | VIP tag |
| `relativeBlue` | `#3B82F6` | Close Relative tag |
| `textPrimary` | `#111827` | Main text |
| `textSecondary` | `#6B7280` | Labels, subtitles |
| `surface` | `#F9FAFB` | Scaffold background |

### Status Helpers

```dart
// Room status
RoomStatusHelper.color('available')     // AppTheme.success
RoomStatusHelper.color('occupied')      // AppTheme.error
RoomStatusHelper.color('maintenance')   // AppTheme.warning
RoomStatusHelper.label('available')     // 'Available'

// Guest status
GuestStatusHelper.color('checked_in')   // AppTheme.success
GuestStatusHelper.color('checked_out')  // AppTheme.textSecondary
GuestStatusHelper.color('not_checked_in') // AppTheme.primary
GuestStatusHelper.label('checked_in')   // 'Checked In'
```

### Reusable Widgets (`common_widgets.dart`)

| Widget | Purpose |
|--------|---------|
| `StatCard` | Dashboard metric tile with icon, value, label, optional color |
| `StatusBadge` | Pill badge with color — used for room/guest status everywhere |
| `GuestTagChip` | Renders VIP and/or Close Relative badges inline |
| `SectionHeader` | Bold section title row with optional trailing action button |
| `EmptyState` | Full-screen centered icon + title + subtitle + optional CTA button |
| `LoadingOverlay` | Semi-transparent black overlay with spinner + optional message |
| `showConfirmDialog()` | Helper function — shows an AlertDialog, returns `bool?` |
| `formatCurrency(double)` | Returns `'₹X.XX'` string |

### Theme Defaults (from `AppTheme.lightTheme`)
- `FilledButton`: full-width (min 48px height), primary blue, rounded 10px
- `OutlinedButton`: full-width, same shape
- `InputDecoration`: filled white, outlined, 10px radius, 16/14px padding
- `Card`: white, 1px elevation, 12px radius
- `BottomSheet`: 20px top radius

---

## 11. Getting Started Locally

### Prerequisites
- Flutter SDK `>=3.3.0` (check with `flutter --version`)
- Android Studio or VS Code with Flutter plugin
- Dart `>=3.3.0`

### Steps

```bash
# 1. Clone the repo
git clone <repo-url>
cd Atithi-GLMS

# 2. Install dependencies
flutter pub get

# 3. Run code generation (required after any schema change)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run

# For a specific device:
flutter run -d <device-id>
```

### When to Re-run Code Generation

Run `dart run build_runner build --delete-conflicting-outputs` whenever you:
- Add, rename, or remove a table column in `app_database.dart`
- Add, rename, or modify a `@DriftAccessor` annotation in a DAO
- Add a new DAO class

The generated files are: `app_database.g.dart`, `events_dao.g.dart`, `hotels_dao.g.dart`, `guests_dao.g.dart`, `service_dao.g.dart`.

### Database Location
The SQLite database is named `atithi_glms` and stored in the platform's default app documents directory via `drift_flutter`'s `driftDatabase()`. There is no migration system currently (schema version is `1`). If the schema is changed and the version is not incremented with a migration, users will see a Drift schema mismatch error on next launch.

---

## 12. How to Add a New Feature

Follow these steps to add a feature correctly and consistently.

### Step 1 — Database (if new data is needed)

Add a new `Table` class in `app_database.dart`:
```dart
class MyNewTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id)();
  TextColumn get data => text()();
}
```

Register it in `@DriftDatabase(tables: [..., MyNewTable])`.

Re-run code generation.

### Step 2 — DAO

Create `lib/data/database/daos/my_dao.dart`:
```dart
@DriftAccessor(tables: [MyNewTable])
class MyDao extends DatabaseAccessor<AppDatabase> with _$MyDaoMixin {
  MyDao(super.db);

  Stream<List<MyNewTableData>> watchAll(int eventId) =>
      (select(myNewTable)..where((t) => t.eventId.equals(eventId))).watch();

  Future<int> insert(MyNewTableCompanion entry) =>
      into(myNewTable).insert(entry);
}
```

Register it in `@DriftDatabase(daos: [..., MyDao])` and add a getter in `AppDatabase`:
```dart
// app_database.g.dart will generate this — just add it to the @DriftDatabase daos list
```

Re-run code generation.

### Step 3 — Repository

Create `lib/data/repositories/my_repository.dart`:
```dart
class MyRepository {
  MyRepository(this._db);
  final AppDatabase _db;

  Stream<List<MyNewTableData>> watchAll(int eventId) =>
      _db.myDao.watchAll(eventId);
}
```

### Step 4 — Providers

Create `lib/features/my_feature/providers/my_provider.dart`:
```dart
final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepository(ref.watch(databaseProvider));
});

final myDataProvider = StreamProvider.family<List<MyNewTableData>, int>((ref, eventId) {
  return ref.watch(myRepositoryProvider).watchAll(eventId);
});
```

### Step 5 — Screen

Create `lib/features/my_feature/screens/my_screen.dart` as a `ConsumerWidget` or `ConsumerStatefulWidget`.

### Step 6 — Route

Add to `AppRoutes`:
```dart
static const myFeature = '/my-feature';
```

Add to `AppRouter.generateRoute`:
```dart
case AppRoutes.myFeature:
  return MaterialPageRoute(
    builder: (_) => MyScreen(eventId: args!['eventId'] as int),
  );
```

---

## 13. Bug Log

### Bug 1 — Room Inventory shows only first hotel's rooms

**File:** `lib/data/database/daos/hotels_dao.dart` — `watchRoomsForEvent()`
**Status:** Fixed

**Cause:** `asyncExpand` was used to chain a hotel watch with a rooms watch. `asyncExpand` is sequential — it waits for the inner stream to complete before processing the next outer event. Drift's `.watch()` never completes, so only the first hotel emission ever produced a rooms stream. Hotels added after the first never showed their rooms.

**Fix:** Replaced with a single Drift join query (`rooms INNER JOIN hotels ON hotels.id = rooms.hotelId WHERE hotels.eventId = ?`) that produces one reactive stream reacting to both tables.

---

### Bug 2A — CSV Import silently fails on iOS

**File:** `lib/features/guests/screens/guest_list_screen.dart` — `_importCsv()`
**Status:** Fixed

**Cause:** `file_picker` was called without `withData: true`. On iOS, files from iCloud Drive or sandboxed locations have `path == null` but `bytes != null`. The code checked `path == null` and returned early, silently dropping the import.

**Fix:** Added `withData: true`. Now tries `path` first, falls back to `bytes`.

---

### Bug 2B — Export crashes on Android & iOS

**File:** `lib/features/export/services/export_service.dart` — `export()`
**Status:** Fixed

**Cause:** `compute()` was used to run xlsx generation in a separate Dart isolate, with `AppDatabase` passed as a parameter. Dart isolates communicate via `SendPort.send()` which can only send serializable data. `AppDatabase` holds FFI `Pointer<>` objects (native SQLite handles) which cannot be serialized — causing a crash on both Android and iOS at the moment the export was triggered.

**Fix:** Removed `compute()`. All database reads are `async/await` and non-blocking. The xlsx assembly runs on the main isolate without perceptible UI jank at event scale.
