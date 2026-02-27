import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../app.dart';
import '../providers/hotels_provider.dart';

class RoomInventoryScreen extends ConsumerStatefulWidget {
  final int eventId;
  const RoomInventoryScreen({super.key, required this.eventId});

  @override
  ConsumerState<RoomInventoryScreen> createState() => _RoomInventoryScreenState();
}

class _RoomInventoryScreenState extends ConsumerState<RoomInventoryScreen> {
  String? _filterHotelId;
  String? _filterCategory;
  String? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final hotelsAsync = ref.watch(hotelsForEventProvider(widget.eventId));
    final roomsAsync = ref.watch(roomsForEventProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Hotel',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.hotelSetup,
              arguments: {'eventId': widget.eventId},
            ),
          ),
        ],
      ),
      body: hotelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (hotels) {
          if (hotels.isEmpty) {
            return EmptyState(
              icon: Icons.hotel,
              title: 'No hotels added yet',
              subtitle: 'Add a hotel to start managing rooms',
              actionLabel: 'Add Hotel',
              onAction: () => Navigator.pushNamed(
                context,
                AppRoutes.hotelSetup,
                arguments: {'eventId': widget.eventId},
              ),
            );
          }

          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (allRooms) {
              // Build filter options
              final categories = allRooms.map((r) => r.category).toSet().toList()..sort();

              // Apply filters
              var filtered = allRooms.where((r) {
                final hotelMatch = _filterHotelId == null ||
                    r.hotelId.toString() == _filterHotelId;
                final categoryMatch =
                    _filterCategory == null || r.category == _filterCategory;
                final statusMatch =
                    _filterStatus == null || r.status == _filterStatus;
                return hotelMatch && categoryMatch && statusMatch;
              }).toList();

              // Count summary
              final total = allRooms.length;
              final available = allRooms.where((r) => r.status == 'available').length;
              final occupied = allRooms.where((r) => r.status == 'occupied').length;

              return Column(
                children: [
                  // Summary strip
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        _CountChip('Total: $total', Colors.grey),
                        const SizedBox(width: 8),
                        _CountChip('Free: $available', AppTheme.success),
                        const SizedBox(width: 8),
                        _CountChip('Occ: $occupied', AppTheme.error),
                      ],
                    ),
                  ),
                  // Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All Hotels',
                          selected: _filterHotelId == null,
                          onTap: () => setState(() => _filterHotelId = null),
                        ),
                        ...hotels.map((h) => _FilterChip(
                              label: h.name,
                              selected: _filterHotelId == h.id.toString(),
                              onTap: () => setState(
                                  () => _filterHotelId = h.id.toString()),
                            )),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Any Status',
                          selected: _filterStatus == null,
                          onTap: () => setState(() => _filterStatus = null),
                        ),
                        _FilterChip(
                          label: 'Available',
                          selected: _filterStatus == 'available',
                          color: AppTheme.success,
                          onTap: () =>
                              setState(() => _filterStatus = 'available'),
                        ),
                        _FilterChip(
                          label: 'Occupied',
                          selected: _filterStatus == 'occupied',
                          color: AppTheme.error,
                          onTap: () =>
                              setState(() => _filterStatus = 'occupied'),
                        ),
                        _FilterChip(
                          label: 'Maintenance',
                          selected: _filterStatus == 'maintenance',
                          color: AppTheme.warning,
                          onTap: () =>
                              setState(() => _filterStatus = 'maintenance'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off,
                            title: 'No rooms match filters',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) => _RoomTile(
                              room: filtered[i],
                              hotelName: hotels
                                  .firstWhere((h) => h.id == filtered[i].hotelId)
                                  .name,
                              onStatusChange: (status) => ref
                                  .read(hotelsRepositoryProvider)
                                  .setRoomStatus(filtered[i].id, status),
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final Room room;
  final String hotelName;
  final ValueChanged<String> onStatusChange;

  const _RoomTile({
    required this.room,
    required this.hotelName,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: RoomStatusHelper.color(room.status).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              room.number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: RoomStatusHelper.color(room.status),
                fontSize: 13,
              ),
            ),
          ),
        ),
        title: Text(room.category),
        subtitle: Text(hotelName, style: const TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(
              label: RoomStatusHelper.label(room.status),
              color: RoomStatusHelper.color(room.status),
            ),
            PopupMenuButton<String>(
              onSelected: onStatusChange,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'available', child: Text('Available')),
                PopupMenuItem(value: 'occupied', child: Text('Occupied')),
                PopupMenuItem(value: 'maintenance', child: Text('Maintenance')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CountChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? c : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
