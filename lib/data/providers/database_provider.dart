import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

/// Overridden in main.dart with the actual database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main.dart');
});
