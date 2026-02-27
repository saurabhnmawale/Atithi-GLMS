// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_dao.dart';

// ignore_for_file: type=lint
mixin _$ServiceDaoMixin on DatabaseAccessor<AppDatabase> {
  $EventsTable get events => attachedDatabase.events;
  $ServiceTypesTable get serviceTypes => attachedDatabase.serviceTypes;
  $HotelsTable get hotels => attachedDatabase.hotels;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $GuestsTable get guests => attachedDatabase.guests;
  $ServiceChargesTable get serviceCharges => attachedDatabase.serviceCharges;
  ServiceDaoManager get managers => ServiceDaoManager(this);
}

class ServiceDaoManager {
  final _$ServiceDaoMixin _db;
  ServiceDaoManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$ServiceTypesTableTableManager get serviceTypes =>
      $$ServiceTypesTableTableManager(_db.attachedDatabase, _db.serviceTypes);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db.attachedDatabase, _db.hotels);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$GuestsTableTableManager get guests =>
      $$GuestsTableTableManager(_db.attachedDatabase, _db.guests);
  $$ServiceChargesTableTableManager get serviceCharges =>
      $$ServiceChargesTableTableManager(
          _db.attachedDatabase, _db.serviceCharges);
}
