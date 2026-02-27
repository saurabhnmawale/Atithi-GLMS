import 'package:drift/drift.dart';
import '../database/app_database.dart';

class BillingRepository {
  BillingRepository(this._db);
  final AppDatabase _db;

  Stream<List<ServiceType>> watchServiceTypes(int eventId) =>
      _db.serviceDao.watchServiceTypesForEvent(eventId);

  Future<List<ServiceType>> getServiceTypes(int eventId) =>
      _db.serviceDao.getServiceTypesForEvent(eventId);

  Future<int> addServiceType({required int eventId, required String name}) =>
      _db.serviceDao.insertServiceType(ServiceTypesCompanion(
        eventId: Value(eventId),
        name: Value(name),
      ));

  Future<void> updateServiceType({required int id, required String name}) async {
    final st = await (_db.serviceDao.db.select(_db.serviceDao.db.serviceTypes)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (st == null) return;
    await _db.serviceDao.updateServiceType(st.toCompanion(true).copyWith(name: Value(name)));
  }

  Future<void> deleteServiceType(int id) => _db.serviceDao.deleteServiceType(id);

  Stream<List<ServiceCharge>> watchChargesForGuest(int guestId) =>
      _db.serviceDao.watchChargesForGuest(guestId);

  Future<List<ServiceCharge>> getChargesForGuest(int guestId) =>
      _db.serviceDao.getChargesForGuest(guestId);

  Stream<double> watchRunningTotal(int guestId) =>
      _db.serviceDao.watchRunningTotal(guestId);

  Future<double> getRunningTotal(int guestId) =>
      _db.serviceDao.getRunningTotal(guestId);

  Future<int> logCharge({
    required int guestId,
    required int typeId,
    required double amount,
  }) =>
      _db.serviceDao.insertCharge(ServiceChargesCompanion(
        guestId: Value(guestId),
        typeId: Value(typeId),
        amount: Value(amount),
      ));

  Future<void> deleteCharge(int id) => _db.serviceDao.deleteCharge(id);

  Future<List<ServiceCharge>> getChargesForEvent(int eventId) =>
      _db.serviceDao.getChargesForEvent(eventId);
}
