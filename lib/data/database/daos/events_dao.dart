import 'package:drift/drift.dart';
import '../app_database.dart';

part 'events_dao.g.dart';

@DriftAccessor(tables: [Events, Hotels, Rooms, Guests, ServiceTypes])
class EventsDao extends DatabaseAccessor<AppDatabase> with _$EventsDaoMixin {
  EventsDao(super.db);

  // ── Events CRUD ───────────────────────────────────────────────────────────

  Stream<List<Event>> watchAllEvents() =>
      (select(events)..orderBy([(e) => OrderingTerm.desc(e.createdAt)])).watch();

  Future<List<Event>> getAllEvents() =>
      (select(events)..orderBy([(e) => OrderingTerm.desc(e.createdAt)])).get();

  Future<Event?> getEventById(int id) =>
      (select(events)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<int> insertEvent(EventsCompanion entry) => into(events).insert(entry);

  Future<bool> updateEvent(EventsCompanion entry) => update(events).replace(entry);

  Future<void> archiveEvent(int id) =>
      (update(events)..where((e) => e.id.equals(id)))
          .write(const EventsCompanion(isArchived: Value(true)));

  Future<void> unarchiveEvent(int id) =>
      (update(events)..where((e) => e.id.equals(id)))
          .write(const EventsCompanion(isArchived: Value(false)));

  /// Duplicate an event as a template (copies event metadata, hotels, rooms,
  /// service types but NOT guests or billing)
  Future<int> duplicateEvent(int sourceEventId, String newName) async {
    return transaction(() async {
      final source = await getEventById(sourceEventId);
      if (source == null) throw Exception('Source event not found');

      // Create new event
      final newEventId = await insertEvent(EventsCompanion(
        name: Value(newName),
        type: Value(source.type),
        startDate: Value(source.startDate),
        endDate: Value(source.endDate),
      ));

      // Duplicate hotels and rooms
      final sourceHotels = await (select(hotels)
            ..where((h) => h.eventId.equals(sourceEventId)))
          .get();

      for (final hotel in sourceHotels) {
        final newHotelId = await into(hotels).insert(HotelsCompanion(
          eventId: Value(newEventId),
          name: Value(hotel.name),
        ));

        final sourceRooms = await (select(rooms)
              ..where((r) => r.hotelId.equals(hotel.id)))
            .get();

        for (final room in sourceRooms) {
          await into(rooms).insert(RoomsCompanion(
            hotelId: Value(newHotelId),
            number: Value(room.number),
            category: Value(room.category),
            // status resets to available
          ));
        }
      }

      // Duplicate service types
      final sourceServiceTypes = await (select(serviceTypes)
            ..where((st) => st.eventId.equals(sourceEventId)))
          .get();

      for (final st in sourceServiceTypes) {
        await into(serviceTypes).insert(ServiceTypesCompanion(
          eventId: Value(newEventId),
          name: Value(st.name),
        ));
      }

      return newEventId;
    });
  }
}
