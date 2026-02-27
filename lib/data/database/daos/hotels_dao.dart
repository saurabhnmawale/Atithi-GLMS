import 'package:drift/drift.dart';
import '../app_database.dart';

part 'hotels_dao.g.dart';

@DriftAccessor(tables: [Hotels, Rooms])
class HotelsDao extends DatabaseAccessor<AppDatabase> with _$HotelsDaoMixin {
  HotelsDao(super.db);

  // ── Hotels ────────────────────────────────────────────────────────────────

  Stream<List<Hotel>> watchHotelsForEvent(int eventId) =>
      (select(hotels)..where((h) => h.eventId.equals(eventId))).watch();

  Future<List<Hotel>> getHotelsForEvent(int eventId) =>
      (select(hotels)..where((h) => h.eventId.equals(eventId))).get();

  Future<Hotel?> getHotelById(int id) =>
      (select(hotels)..where((h) => h.id.equals(id))).getSingleOrNull();

  Future<int> insertHotel(HotelsCompanion entry) => into(hotels).insert(entry);

  Future<bool> updateHotel(HotelsCompanion entry) => update(hotels).replace(entry);

  Future<void> deleteHotel(int id) =>
      (delete(hotels)..where((h) => h.id.equals(id))).go();

  // ── Rooms ─────────────────────────────────────────────────────────────────

  Stream<List<Room>> watchRoomsForHotel(int hotelId) =>
      (select(rooms)..where((r) => r.hotelId.equals(hotelId))).watch();

  Future<List<Room>> getRoomsForHotel(int hotelId) =>
      (select(rooms)..where((r) => r.hotelId.equals(hotelId))).get();

  Future<List<Room>> getAvailableRoomsForHotel(int hotelId, String category) =>
      (select(rooms)
            ..where((r) =>
                r.hotelId.equals(hotelId) &
                r.category.equals(category) &
                r.status.equals('available')))
          .get();

  Future<List<Room>> getRoomsForEvent(int eventId) async {
    final eventHotels = await (select(hotels)
          ..where((h) => h.eventId.equals(eventId)))
        .get();
    final hotelIds = eventHotels.map((h) => h.id).toList();
    if (hotelIds.isEmpty) return [];
    return (select(rooms)..where((r) => r.hotelId.isIn(hotelIds))).get();
  }

  Stream<List<Room>> watchRoomsForEvent(int eventId) {
    final hotelQuery = select(hotels)..where((h) => h.eventId.equals(eventId));
    return hotelQuery.watch().asyncExpand((eventHotels) {
      final ids = eventHotels.map((h) => h.id).toList();
      if (ids.isEmpty) return Stream.value([]);
      return (select(rooms)..where((r) => r.hotelId.isIn(ids))).watch();
    });
  }

  Future<Room?> getRoomById(int id) =>
      (select(rooms)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<int> insertRoom(RoomsCompanion entry) => into(rooms).insert(entry);

  Future<bool> updateRoom(RoomsCompanion entry) => update(rooms).replace(entry);

  Future<void> deleteRoom(int id) =>
      (delete(rooms)..where((r) => r.id.equals(id))).go();

  Future<void> setRoomStatus(int roomId, String status) =>
      (update(rooms)..where((r) => r.id.equals(roomId)))
          .write(RoomsCompanion(status: Value(status)));

  Future<void> insertRooms(List<RoomsCompanion> entries) =>
      batch((b) => b.insertAll(rooms, entries));

  /// Room count summary per hotel
  Future<Map<String, int>> getRoomCountsForHotel(int hotelId) async {
    final allRooms = await getRoomsForHotel(hotelId);
    return {
      'total': allRooms.length,
      'available': allRooms.where((r) => r.status == 'available').length,
      'occupied': allRooms.where((r) => r.status == 'occupied').length,
      'maintenance': allRooms.where((r) => r.status == 'maintenance').length,
    };
  }
}
