import 'package:drift/drift.dart';
import '../database/app_database.dart';

class GuestsRepository {
  GuestsRepository(this._db);
  final AppDatabase _db;

  Stream<List<Guest>> watchGuestsForEvent(int eventId) =>
      _db.guestsDao.watchGuestsForEvent(eventId);

  Future<List<Guest>> getGuestsForEvent(int eventId) =>
      _db.guestsDao.getGuestsForEvent(eventId);

  Future<Guest?> getGuestById(int id) => _db.guestsDao.getGuestById(id);

  Stream<Guest?> watchGuestById(int id) => _db.guestsDao.watchGuestById(id);

  Future<int> addGuest({
    required int eventId,
    required String name,
    required String assignedCategory,
    bool isVip = false,
    bool isCloseRelative = false,
    String? specialRequests,
  }) =>
      _db.guestsDao.insertGuest(GuestsCompanion(
        eventId: Value(eventId),
        name: Value(name),
        assignedCategory: Value(assignedCategory),
        isVip: Value(isVip),
        isCloseRelative: Value(isCloseRelative),
        specialRequests: Value(specialRequests),
      ));

  Future<void> updateGuestTags({
    required int guestId,
    required bool isVip,
    required bool isCloseRelative,
    String? specialRequests,
  }) async {
    final guest = await _db.guestsDao.getGuestById(guestId);
    if (guest == null) return;
    await _db.guestsDao.updateGuest(guest.toCompanion(true).copyWith(
      isVip: Value(isVip),
      isCloseRelative: Value(isCloseRelative),
      specialRequests: Value(specialRequests),
    ));
  }

  Future<void> importGuests(int eventId, List<Map<String, dynamic>> rows) =>
      _db.guestsDao.insertGuests(rows
          .map((r) => GuestsCompanion(
                eventId: Value(eventId),
                name: Value(r['name'] as String),
                assignedCategory: Value(r['category'] as String),
                isVip: Value((r['vip'] as bool?) ?? false),
                isCloseRelative: Value((r['close_relative'] as bool?) ?? false),
                specialRequests: Value(r['special_requests'] as String?),
              ))
          .toList());

  Future<void> checkIn({
    required int guestId,
    required int hotelId,
    required int roomId,
  }) =>
      _db.guestsDao.checkInGuest(
        guestId: guestId,
        hotelId: hotelId,
        roomId: roomId,
      );

  Future<void> changeRoom({
    required int guestId,
    required int newHotelId,
    required int newRoomId,
  }) =>
      _db.guestsDao.changeRoom(
        guestId: guestId,
        newHotelId: newHotelId,
        newRoomId: newRoomId,
      );

  Future<void> checkOut(int guestId) => _db.guestsDao.checkOutGuest(guestId);

  Future<bool> undoCheckout({
    required int guestId,
    required int hotelId,
    required int roomId,
  }) =>
      _db.guestsDao.undoCheckout(
        guestId: guestId,
        hotelId: hotelId,
        roomId: roomId,
      );

  Stream<CheckoutUndoWindow?> watchUndoWindow(int guestId) =>
      _db.guestsDao.watchUndoWindow(guestId);

  Future<List<StaySegment>> getStaySegments(int guestId) =>
      _db.guestsDao.getStaySegmentsForGuest(guestId);

  Stream<List<StaySegment>> watchStaySegments(int guestId) =>
      _db.guestsDao.watchStaySegmentsForGuest(guestId);

  Future<void> processExpiredUndoWindows() =>
      _db.guestsDao.processExpiredUndoWindows();
}
