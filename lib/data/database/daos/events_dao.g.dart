// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_dao.dart';

// ignore_for_file: type=lint
mixin _$EventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EventsTable get events => attachedDatabase.events;
  $HotelsTable get hotels => attachedDatabase.hotels;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $GuestsTable get guests => attachedDatabase.guests;
  $ServiceTypesTable get serviceTypes => attachedDatabase.serviceTypes;
  EventsDaoManager get managers => EventsDaoManager(this);
}

class EventsDaoManager {
  final _$EventsDaoMixin _db;
  EventsDaoManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db.attachedDatabase, _db.hotels);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$GuestsTableTableManager get guests =>
      $$GuestsTableTableManager(_db.attachedDatabase, _db.guests);
  $$ServiceTypesTableTableManager get serviceTypes =>
      $$ServiceTypesTableTableManager(_db.attachedDatabase, _db.serviceTypes);
}
