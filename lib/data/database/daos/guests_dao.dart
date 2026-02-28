import 'package:drift/drift.dart';
import '../app_database.dart';

part 'guests_dao.g.dart';

@DriftAccessor(tables: [Guests, StaySegments, Rooms, Hotels, CheckoutUndoWindows])
class GuestsDao extends DatabaseAccessor<AppDatabase> with _$GuestsDaoMixin {
  GuestsDao(super.db);

  // ── Guests ────────────────────────────────────────────────────────────────

  Stream<List<Guest>> watchGuestsForEvent(int eventId) =>
      (select(guests)
            ..where((g) => g.eventId.equals(eventId))
            ..orderBy([(g) => OrderingTerm.asc(g.name)]))
          .watch();

  Future<List<Guest>> getGuestsForEvent(int eventId) =>
      (select(guests)
            ..where((g) => g.eventId.equals(eventId))
            ..orderBy([(g) => OrderingTerm.asc(g.name)]))
          .get();

  Future<Guest?> getGuestById(int id) =>
      (select(guests)..where((g) => g.id.equals(id))).getSingleOrNull();

  Stream<Guest?> watchGuestById(int id) =>
      (select(guests)..where((g) => g.id.equals(id))).watchSingleOrNull();

  Future<int> insertGuest(GuestsCompanion entry) => into(guests).insert(entry);

  Future<bool> updateGuest(GuestsCompanion entry) => update(guests).replace(entry);

  Future<void> insertGuests(List<GuestsCompanion> entries) =>
      batch((b) => b.insertAll(guests, entries));

  // ── Check-in / Check-out ──────────────────────────────────────────────────

  /// Check in a guest to a room
  Future<void> checkInGuest({
    required int guestId,
    required int hotelId,
    required int roomId,
  }) async {
    await transaction(() async {
      // Update guest status and current location
      await (update(guests)..where((g) => g.id.equals(guestId))).write(
        GuestsCompanion(
          status: const Value('checked_in'),
          currentHotelId: Value(hotelId),
          currentRoomId: Value(roomId),
        ),
      );

      // Create stay segment
      await into(staySegments).insert(StaySegmentsCompanion(
        guestId: Value(guestId),
        hotelId: Value(hotelId),
        roomId: Value(roomId),
        checkInAt: Value(DateTime.now()),
      ));

      // Mark room as occupied
      await (update(rooms)..where((r) => r.id.equals(roomId)))
          .write(const RoomsCompanion(status: Value('occupied')));
    });
  }

  /// Change guest's room (within same or different hotel)
  Future<void> changeRoom({
    required int guestId,
    required int newHotelId,
    required int newRoomId,
  }) async {
    await transaction(() async {
      final guest = await getGuestById(guestId);
      if (guest == null) return;

      // Close current stay segment
      if (guest.currentRoomId != null) {
        final now = DateTime.now();
        await (update(staySegments)
              ..where((s) =>
                  s.guestId.equals(guestId) & s.checkOutAt.isNull()))
            .write(StaySegmentsCompanion(checkOutAt: Value(now)));

        // Free old room
        await (update(rooms)..where((r) => r.id.equals(guest.currentRoomId!)))
            .write(const RoomsCompanion(status: Value('available')));
      }

      // Open new stay segment
      await into(staySegments).insert(StaySegmentsCompanion(
        guestId: Value(guestId),
        hotelId: Value(newHotelId),
        roomId: Value(newRoomId),
        checkInAt: Value(DateTime.now()),
      ));

      // Mark new room occupied
      await (update(rooms)..where((r) => r.id.equals(newRoomId)))
          .write(const RoomsCompanion(status: Value('occupied')));

      // Update guest location
      await (update(guests)..where((g) => g.id.equals(guestId))).write(
        GuestsCompanion(
          currentHotelId: Value(newHotelId),
          currentRoomId: Value(newRoomId),
        ),
      );
    });
  }

  /// Check out a guest — creates undo window (bill locking happens after 5 min)
  Future<void> checkOutGuest(int guestId) async {
    await transaction(() async {
      final guest = await getGuestById(guestId);
      if (guest == null) return;

      final now = DateTime.now();
      final expires = now.add(const Duration(minutes: 5));

      // Close stay segment
      await (update(staySegments)
            ..where((s) => s.guestId.equals(guestId) & s.checkOutAt.isNull()))
          .write(StaySegmentsCompanion(checkOutAt: Value(now)));

      // Free room
      if (guest.currentRoomId != null) {
        await (update(rooms)..where((r) => r.id.equals(guest.currentRoomId!)))
            .write(const RoomsCompanion(status: Value('available')));
      }

      // Update guest status
      await (update(guests)..where((g) => g.id.equals(guestId))).write(
        const GuestsCompanion(
          status: Value('checked_out'),
          currentHotelId: Value.absent(),
          currentRoomId: Value.absent(),
        ),
      );

      // Record undo window
      await into(checkoutUndoWindows).insertOnConflictUpdate(
        CheckoutUndoWindowsCompanion(
          guestId: Value(guestId),
          checkoutAt: Value(now),
          expiresAt: Value(expires),
        ),
      );
    });
  }

  /// Undo checkout — only valid if within undo window
  Future<bool> undoCheckout({
    required int guestId,
    required int hotelId,
    required int roomId,
  }) async {
    final window = await (select(checkoutUndoWindows)
          ..where((w) => w.guestId.equals(guestId)))
        .getSingleOrNull();

    if (window == null || DateTime.now().isAfter(window.expiresAt)) {
      return false; // window expired
    }

    await transaction(() async {
      // Re-open last stay segment
      final lastSegment = await (select(staySegments)
            ..where((s) =>
                s.guestId.equals(guestId) &
                s.checkOutAt.isNotNull())
            ..orderBy([(s) => OrderingTerm.desc(s.checkInAt)])
            ..limit(1))
          .getSingleOrNull();
      if (lastSegment != null) {
        await (update(staySegments)..where((s) => s.id.equals(lastSegment.id)))
            .write(const StaySegmentsCompanion(checkOutAt: Value(null)));
      }

      // Re-occupy room
      await (update(rooms)..where((r) => r.id.equals(roomId)))
          .write(const RoomsCompanion(status: Value('occupied')));

      // Restore guest status
      await (update(guests)..where((g) => g.id.equals(guestId))).write(
        GuestsCompanion(
          status: const Value('checked_in'),
          currentHotelId: Value(hotelId),
          currentRoomId: Value(roomId),
        ),
      );

      // Remove undo window
      await (delete(checkoutUndoWindows)
            ..where((w) => w.guestId.equals(guestId)))
          .go();
    });

    return true;
  }

  /// Lock bills for all expired undo windows (call on app resume)
  Future<void> processExpiredUndoWindows() async {
    final now = DateTime.now();
    final expired = await (select(checkoutUndoWindows)
          ..where((w) => w.expiresAt.isSmallerOrEqualValue(now)))
        .get();

    for (final window in expired) {
      // Lock all service charges for this guest
      await (update(db.serviceCharges)
            ..where((c) => c.guestId.equals(window.guestId)))
          .write(const ServiceChargesCompanion(isLocked: Value(true)));

      // Delete the undo window
      await (delete(checkoutUndoWindows)
            ..where((w) => w.guestId.equals(window.guestId)))
          .go();
    }
  }

  // ── Undo window query ─────────────────────────────────────────────────────

  Stream<CheckoutUndoWindow?> watchUndoWindow(int guestId) =>
      (select(checkoutUndoWindows)..where((w) => w.guestId.equals(guestId)))
          .watchSingleOrNull();

  // ── Stay Segments ─────────────────────────────────────────────────────────

  Future<List<StaySegment>> getStaySegmentsForGuest(int guestId) =>
      (select(staySegments)
            ..where((s) => s.guestId.equals(guestId))
            ..orderBy([(s) => OrderingTerm.desc(s.checkInAt)]))
          .get();

  Stream<List<StaySegment>> watchStaySegmentsForGuest(int guestId) =>
      (select(staySegments)
            ..where((s) => s.guestId.equals(guestId))
            ..orderBy([(s) => OrderingTerm.desc(s.checkInAt)]))
          .watch();
}
