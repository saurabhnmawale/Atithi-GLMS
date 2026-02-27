import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/events_repository.dart';
import '../../../data/database/app_database.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return EventsRepository(ref.watch(databaseProvider));
});

final allEventsProvider = StreamProvider<List<Event>>((ref) {
  return ref.watch(eventsRepositoryProvider).watchAllEvents();
});

final eventByIdProvider = FutureProvider.family<Event?, int>((ref, id) {
  return ref.watch(eventsRepositoryProvider).getEventById(id);
});
