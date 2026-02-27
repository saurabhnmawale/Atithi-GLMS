import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/billing_repository.dart';
import '../../../data/database/app_database.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository(ref.watch(databaseProvider));
});

final serviceTypesProvider = StreamProvider.family<List<ServiceType>, int>((ref, eventId) {
  return ref.watch(billingRepositoryProvider).watchServiceTypes(eventId);
});

final chargesForGuestProvider = StreamProvider.family<List<ServiceCharge>, int>((ref, guestId) {
  return ref.watch(billingRepositoryProvider).watchChargesForGuest(guestId);
});

final runningTotalProvider = StreamProvider.family<double, int>((ref, guestId) {
  return ref.watch(billingRepositoryProvider).watchRunningTotal(guestId);
});
