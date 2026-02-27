import 'package:drift/drift.dart';
import '../database/app_database.dart';

class EventsRepository {
  EventsRepository(this._db);
  final AppDatabase _db;

  Stream<List<Event>> watchAllEvents() => _db.eventsDao.watchAllEvents();
  Future<List<Event>> getAllEvents() => _db.eventsDao.getAllEvents();
  Future<Event?> getEventById(int id) => _db.eventsDao.getEventById(id);

  Future<int> createEvent({
    required String name,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _db.eventsDao.insertEvent(EventsCompanion(
      name: Value(name),
      type: Value(type),
      startDate: Value(startDate),
      endDate: Value(endDate),
    ));
  }

  Future<void> updateEvent({
    required int id,
    required String name,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final event = await _db.eventsDao.getEventById(id);
    if (event == null) return;
    await _db.eventsDao.updateEvent(event.toCompanion(true).copyWith(
      name: Value(name),
      type: Value(type),
      startDate: Value(startDate),
      endDate: Value(endDate),
    ));
  }

  Future<void> archiveEvent(int id) => _db.eventsDao.archiveEvent(id);
  Future<void> unarchiveEvent(int id) => _db.eventsDao.unarchiveEvent(id);
  Future<int> duplicateEvent(int sourceId, String newName) =>
      _db.eventsDao.duplicateEvent(sourceId, newName);
}
