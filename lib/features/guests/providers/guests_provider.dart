import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/guests_repository.dart';
import '../../../data/database/app_database.dart';

final guestsRepositoryProvider = Provider<GuestsRepository>((ref) {
  return GuestsRepository(ref.watch(databaseProvider));
});

final guestsForEventProvider = StreamProvider.family<List<Guest>, int>((ref, eventId) {
  return ref.watch(guestsRepositoryProvider).watchGuestsForEvent(eventId);
});

final guestByIdProvider = StreamProvider.family<Guest?, int>((ref, guestId) {
  return ref.watch(guestsRepositoryProvider).watchGuestById(guestId);
});

final staySegmentsProvider = StreamProvider.family<List<StaySegment>, int>((ref, guestId) {
  return ref.watch(guestsRepositoryProvider).watchStaySegments(guestId);
});

final undoWindowProvider = StreamProvider.family<CheckoutUndoWindow?, int>((ref, guestId) {
  return ref.watch(guestsRepositoryProvider).watchUndoWindow(guestId);
});
