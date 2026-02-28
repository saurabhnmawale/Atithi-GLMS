import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/guests_provider.dart';
import '../../hotels/providers/hotels_provider.dart';

class RoomChangeFlowScreen extends ConsumerStatefulWidget {
  final int guestId;
  final int eventId;
  const RoomChangeFlowScreen({super.key, required this.guestId, required this.eventId});

  @override
  ConsumerState<RoomChangeFlowScreen> createState() => _RoomChangeFlowScreenState();
}

class _RoomChangeFlowScreenState extends ConsumerState<RoomChangeFlowScreen> {
  Hotel? _selectedHotel;
  Room? _selectedRoom;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final guestAsync = ref.watch(guestByIdProvider(widget.guestId));
    final hotelsAsync = ref.watch(hotelsForEventProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Change Room')),
      body: guestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (guest) {
          if (guest == null) return const Center(child: Text('Guest not found'));

          return Column(
            children: [
              // Current room info
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guest.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      guest.currentRoomId != null
                          ? 'Current Room: #${guest.currentRoomId}'
                          : 'No current room',
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('Select New Hotel',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    hotelsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                      data: (hotels) => Column(
                        children: hotels
                            .map((h) => Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: _selectedHotel?.id == h.id
                                          ? AppTheme.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () => setState(() {
                                      _selectedHotel = h;
                                      _selectedRoom = null;
                                    }),
                                    leading: Icon(Icons.hotel,
                                        color: _selectedHotel?.id == h.id
                                            ? AppTheme.primary
                                            : Colors.grey),
                                    title: Text(h.name),
                                    trailing: _selectedHotel?.id == h.id
                                        ? const Icon(Icons.check_circle,
                                            color: AppTheme.primary)
                                        : null,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    if (_selectedHotel != null) ...[
                      const SizedBox(height: 20),
                      Text(
                          'Select New Room (${guest.assignedCategory})',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _AvailableRooms(
                        hotelId: _selectedHotel!.id,
                        category: guest.assignedCategory,
                        excludeRoomId: guest.currentRoomId,
                        selectedRoom: _selectedRoom,
                        onSelected: (r) => setState(() => _selectedRoom = r),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed:
                      (_selectedRoom != null && !_saving) ? () => _confirm(context) : null,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Confirm Room Change'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final navigator = Navigator.of(context);
    final ok = await showConfirmDialog(
      context,
      title: 'Change Room',
      message: 'Move guest to Room ${_selectedRoom!.number} at ${_selectedHotel!.name}?',
      confirmLabel: 'Change Room',
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      await ref.read(guestsRepositoryProvider).changeRoom(
            guestId: widget.guestId,
            newHotelId: _selectedHotel!.id,
            newRoomId: _selectedRoom!.id,
          );
      if (mounted) navigator.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _AvailableRooms extends ConsumerWidget {
  final int hotelId;
  final String category;
  final int? excludeRoomId;
  final Room? selectedRoom;
  final ValueChanged<Room> onSelected;

  const _AvailableRooms({
    required this.hotelId,
    required this.category,
    this.excludeRoomId,
    required this.selectedRoom,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsForHotelProvider(hotelId));

    return roomsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (rooms) {
        final available = rooms
            .where((r) =>
                r.status == 'available' &&
                r.category == category &&
                r.id != excludeRoomId)
            .toList();

        if (available.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.error.withValues(alpha:0.3)),
            ),
            child: Text(
              'No available $category rooms (excluding current room).',
              style: const TextStyle(color: AppTheme.error),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: available.map((r) {
            final isSelected = selectedRoom?.id == r.id;
            return GestureDetector(
              onTap: () => onSelected(r),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  'Room ${r.number}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
