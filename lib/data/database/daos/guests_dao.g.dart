// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guests_dao.dart';

// ignore_for_file: type=lint
mixin _$GuestsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EventsTable get events => attachedDatabase.events;
  $HotelsTable get hotels => attachedDatabase.hotels;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $GuestsTable get guests => attachedDatabase.guests;
  $StaySegmentsTable get staySegments => attachedDatabase.staySegments;
  $CheckoutUndoWindowsTable get checkoutUndoWindows =>
      attachedDatabase.checkoutUndoWindows;
  GuestsDaoManager get managers => GuestsDaoManager(this);
}

class GuestsDaoManager {
  final _$GuestsDaoMixin _db;
  GuestsDaoManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$HotelsTableTableManager get hotels =>
      $$HotelsTableTableManager(_db.attachedDatabase, _db.hotels);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$GuestsTableTableManager get guests =>
      $$GuestsTableTableManager(_db.attachedDatabase, _db.guests);
  $$StaySegmentsTableTableManager get staySegments =>
      $$StaySegmentsTableTableManager(_db.attachedDatabase, _db.staySegments);
  $$CheckoutUndoWindowsTableTableManager get checkoutUndoWindows =>
      $$CheckoutUndoWindowsTableTableManager(
          _db.attachedDatabase, _db.checkoutUndoWindows);
}
