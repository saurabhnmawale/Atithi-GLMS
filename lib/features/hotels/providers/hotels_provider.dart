import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/hotels_repository.dart';
import '../../../data/database/app_database.dart';

final hotelsRepositoryProvider = Provider<HotelsRepository>((ref) {
  return HotelsRepository(ref.watch(databaseProvider));
});

final hotelsForEventProvider = StreamProvider.family<List<Hotel>, int>((ref, eventId) {
  return ref.watch(hotelsRepositoryProvider).watchHotelsForEvent(eventId);
});

final roomsForEventProvider = StreamProvider.family<List<Room>, int>((ref, eventId) {
  return ref.watch(hotelsRepositoryProvider).watchRoomsForEvent(eventId);
});

final roomsForHotelProvider = StreamProvider.family<List<Room>, int>((ref, hotelId) {
  return ref.watch(hotelsRepositoryProvider).watchRoomsForHotel(hotelId);
});
