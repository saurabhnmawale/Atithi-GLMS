// IMPORTANT: After modifying this file, run:
//   dart run build_runner build --delete-conflicting-outputs
// to regenerate app_database.g.dart

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'daos/events_dao.dart';
import 'daos/hotels_dao.dart';
import 'daos/guests_dao.dart';
import 'daos/service_dao.dart';

part 'app_database.g.dart';

// ─── Tables ──────────────────────────────────────────────────────────────────

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // wedding | corporate
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

class Hotels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id)();
  TextColumn get name => text()();
}

class Rooms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hotelId => integer().references(Hotels, #id)();
  TextColumn get number => text()();
  TextColumn get category => text()();
  // status: available | occupied | maintenance
  TextColumn get status => text().withDefault(const Constant('available'))();
}

class Guests extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id)();
  TextColumn get name => text()();
  // checkoutDate: NULL means inherit event end_date at query time (never copy
  // events.end_date here — see GuestsRepository.getEffectiveCheckoutDate)
  DateTimeColumn get checkoutDate => dateTime().nullable()();
  BoolColumn get isVip => boolean().withDefault(const Constant(false))();
  BoolColumn get isCloseRelative => boolean().withDefault(const Constant(false))();
  TextColumn get specialRequests => text().nullable()();
  // status: not_checked_in | checked_in | checked_out
  TextColumn get status => text().withDefault(const Constant('not_checked_in'))();
  IntColumn get currentHotelId => integer().nullable().references(Hotels, #id)();
  IntColumn get currentRoomId => integer().nullable().references(Rooms, #id)();
}

class StaySegments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get guestId => integer().references(Guests, #id)();
  IntColumn get hotelId => integer().references(Hotels, #id)();
  IntColumn get roomId => integer().references(Rooms, #id)();
  DateTimeColumn get checkInAt => dateTime()();
  DateTimeColumn get checkOutAt => dateTime().nullable()();
}

class ServiceTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id)();
  TextColumn get name => text()();
}

class ServiceCharges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get guestId => integer().references(Guests, #id)();
  IntColumn get typeId => integer().references(ServiceTypes, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
}

class CheckoutUndoWindows extends Table {
  IntColumn get guestId => integer().references(Guests, #id)();
  DateTimeColumn get checkoutAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {guestId};
}

// ─── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    Events,
    Hotels,
    Rooms,
    Guests,
    StaySegments,
    ServiceTypes,
    ServiceCharges,
    CheckoutUndoWindows,
  ],
  daos: [
    EventsDao,
    HotelsDao,
    GuestsDao,
    ServiceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          // v1 → v2: remove assigned_category, add checkout_date (nullable).
          // TableMigration recreates guests with the current schema definition.
          // assigned_category is dropped; checkout_date defaults to NULL.
          await migrator.alterTable(TableMigration(guests));
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'atithi_glms',
      web: kIsWeb
          ? DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            )
          : null,
    );
  }
}
