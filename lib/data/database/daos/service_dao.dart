import 'package:drift/drift.dart';
import '../app_database.dart';

part 'service_dao.g.dart';

@DriftAccessor(tables: [ServiceTypes, ServiceCharges])
class ServiceDao extends DatabaseAccessor<AppDatabase> with _$ServiceDaoMixin {
  ServiceDao(super.db);

  // ── Service Types ─────────────────────────────────────────────────────────

  Stream<List<ServiceType>> watchServiceTypesForEvent(int eventId) =>
      (select(serviceTypes)..where((st) => st.eventId.equals(eventId))).watch();

  Future<List<ServiceType>> getServiceTypesForEvent(int eventId) =>
      (select(serviceTypes)..where((st) => st.eventId.equals(eventId))).get();

  Future<int> insertServiceType(ServiceTypesCompanion entry) =>
      into(serviceTypes).insert(entry);

  Future<bool> updateServiceType(ServiceTypesCompanion entry) =>
      update(serviceTypes).replace(entry);

  Future<void> deleteServiceType(int id) =>
      (delete(serviceTypes)..where((st) => st.id.equals(id))).go();

  // ── Service Charges ───────────────────────────────────────────────────────

  Stream<List<ServiceCharge>> watchChargesForGuest(int guestId) =>
      (select(serviceCharges)
            ..where((c) => c.guestId.equals(guestId))
            ..orderBy([(c) => OrderingTerm.desc(c.loggedAt)]))
          .watch();

  Future<List<ServiceCharge>> getChargesForGuest(int guestId) =>
      (select(serviceCharges)
            ..where((c) => c.guestId.equals(guestId))
            ..orderBy([(c) => OrderingTerm.desc(c.loggedAt)]))
          .get();

  Future<int> insertCharge(ServiceChargesCompanion entry) =>
      into(serviceCharges).insert(entry);

  Future<void> deleteCharge(int id) =>
      (delete(serviceCharges)..where((c) => c.id.equals(id))).go();

  Future<void> lockChargesForGuest(int guestId) =>
      (update(serviceCharges)..where((c) => c.guestId.equals(guestId)))
          .write(const ServiceChargesCompanion(isLocked: Value(true)));

  /// Running bill total for a guest
  Future<double> getRunningTotal(int guestId) async {
    final charges = await getChargesForGuest(guestId);
    return charges.fold<double>(0.0, (sum, c) => sum + c.amount);
  }

  Stream<double> watchRunningTotal(int guestId) {
    return watchChargesForGuest(guestId).map(
      (charges) => charges.fold(0.0, (sum, c) => sum + c.amount),
    );
  }

  /// All charges for an event (for export)
  Future<List<ServiceCharge>> getChargesForEvent(int eventId) async {
    final guestList = await (select(db.guests)
          ..where((g) => g.eventId.equals(eventId)))
        .get();
    final guestIds = guestList.map((g) => g.id).toList();
    if (guestIds.isEmpty) return [];
    return (select(serviceCharges)
          ..where((c) => c.guestId.isIn(guestIds)))
        .get();
  }
}
