// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotels_dao.dart';

// ignore_for_file: type=lint
mixin _$HotelsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EventsTable get events => attachedDatabase.events;
  $HotelsTable get hotels => attachedDatabase.hotels;
  $RoomsTable get rooms => attachedDatabase.rooms;
  HotelsDaoManager get managers => HotelsDaoManager(this);
}

class HotelsDaoManager {
  final _$HotelsDaoMixin _db;
  HotelsDaoManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db.attachedDatabase, _db.hotels);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
}
