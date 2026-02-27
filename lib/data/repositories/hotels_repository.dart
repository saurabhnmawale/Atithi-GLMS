import 'package:drift/drift.dart';
import '../database/app_database.dart';

class HotelsRepository {
  HotelsRepository(this._db);
  final AppDatabase _db;

  Stream<List<Hotel>> watchHotelsForEvent(int eventId) =>
      _db.hotelsDao.watchHotelsForEvent(eventId);

  Future<List<Hotel>> getHotelsForEvent(int eventId) =>
      _db.hotelsDao.getHotelsForEvent(eventId);

  Future<Hotel?> getHotelById(int id) => _db.hotelsDao.getHotelById(id);

  Future<int> addHotel({required int eventId, required String name}) =>
      _db.hotelsDao.insertHotel(HotelsCompanion(
        eventId: Value(eventId),
        name: Value(name),
      ));

  Future<void> updateHotel({required int id, required String name}) async {
    final hotel = await _db.hotelsDao.getHotelById(id);
    if (hotel == null) return;
    await _db.hotelsDao.updateHotel(hotel.toCompanion(true).copyWith(name: Value(name)));
  }

  Future<void> deleteHotel(int id) => _db.hotelsDao.deleteHotel(id);

  // Rooms
  Stream<List<Room>> watchRoomsForHotel(int hotelId) =>
      _db.hotelsDao.watchRoomsForHotel(hotelId);

  Stream<List<Room>> watchRoomsForEvent(int eventId) =>
      _db.hotelsDao.watchRoomsForEvent(eventId);

  Future<List<Room>> getRoomsForHotel(int hotelId) =>
      _db.hotelsDao.getRoomsForHotel(hotelId);

  Future<List<Room>> getAvailableRoomsForHotel(int hotelId, String category) =>
      _db.hotelsDao.getAvailableRoomsForHotel(hotelId, category);

  Future<Room?> getRoomById(int id) => _db.hotelsDao.getRoomById(id);

  Future<int> addRoom({
    required int hotelId,
    required String number,
    required String category,
    String status = 'available',
  }) =>
      _db.hotelsDao.insertRoom(RoomsCompanion(
        hotelId: Value(hotelId),
        number: Value(number),
        category: Value(category),
        status: Value(status),
      ));

  Future<void> addRoomsBulk(int hotelId, List<Map<String, String>> roomData) =>
      _db.hotelsDao.insertRooms(roomData
          .map((r) => RoomsCompanion(
                hotelId: Value(hotelId),
                number: Value(r['number']!),
                category: Value(r['category']!),
              ))
          .toList());

  Future<void> updateRoom({
    required int id,
    required String number,
    required String category,
    required String status,
  }) async {
    final room = await _db.hotelsDao.getRoomById(id);
    if (room == null) return;
    await _db.hotelsDao.updateRoom(room.toCompanion(true).copyWith(
      number: Value(number),
      category: Value(category),
      status: Value(status),
    ));
  }

  Future<void> setRoomStatus(int roomId, String status) =>
      _db.hotelsDao.setRoomStatus(roomId, status);

  Future<void> deleteRoom(int id) => _db.hotelsDao.deleteRoom(id);

  Future<Map<String, int>> getRoomCountsForHotel(int hotelId) =>
      _db.hotelsDao.getRoomCountsForHotel(hotelId);
}
