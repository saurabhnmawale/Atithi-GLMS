import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/guests_provider.dart';
import '../../hotels/providers/hotels_provider.dart';

class CheckinFlowScreen extends ConsumerStatefulWidget {
  final int guestId;
  final int eventId;
  const CheckinFlowScreen({super.key, required this.guestId, required this.eventId});

  @override
  ConsumerState<CheckinFlowScreen> createState() => _CheckinFlowScreenState();
}

class _CheckinFlowScreenState extends ConsumerState<CheckinFlowScreen> {
  Hotel? _selectedHotel;
  Room? _selectedRoom;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final guestAsync = ref.watch(guestByIdProvider(widget.guestId));
    final hotelsAsync = ref.watch(hotelsForEventProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: guestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (guest) {
          if (guest == null) return const Center(child: Text('Guest not found'));

          return Column(
            children: [
              // Guest info header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(guest.name[0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(guest.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Category: ${guest.assignedCategory}',
                            style: const TextStyle(
                                fontSize: 13, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Step 1: Select Hotel
                    const Text('Step 1: Select Hotel',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    hotelsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                      data: (hotels) {
                        if (hotels.isEmpty) {
                          return const Text('No hotels found for this event.');
                        }
                        return Column(
                          children: hotels
                              .map((h) => _HotelTile(
                                    hotel: h,
                                    selected: _selectedHotel?.id == h.id,
                                    onTap: () => setState(() {
                                      _selectedHotel = h;
                                      _selectedRoom = null;
                                    }),
                                  ))
                              .toList(),
                        );
                      },
                    ),

                    // Step 2: Select Room
                    if (_selectedHotel != null) ...[
                      const SizedBox(height: 20),
                      Text('Step 2: Select Room (${guest.assignedCategory})',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _RoomSelector(
                        hotelId: _selectedHotel!.id,
                        category: guest.assignedCategory,
                        selectedRoom: _selectedRoom,
                        onRoomSelected: (r) => setState(() => _selectedRoom = r),
                      ),
                    ],
                  ],
                ),
              ),
              // Confirm button
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed:
                      (_selectedHotel != null && _selectedRoom != null && !_saving)
                          ? () => _confirmCheckin(context)
                          : null,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Confirm Check-In'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _confirmCheckin(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Confirm Check-In',
      message:
          'Check in to ${_selectedHotel!.name} — Room ${_selectedRoom!.number}?',
      confirmLabel: 'Check In',
    );
    if (confirmed != true) return;

    setState(() => _saving = true);
    try {
      await ref.read(guestsRepositoryProvider).checkIn(
            guestId: widget.guestId,
            hotelId: _selectedHotel!.id,
            roomId: _selectedRoom!.id,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _HotelTile extends StatelessWidget {
  final Hotel hotel;
  final bool selected;
  final VoidCallback onTap;

  const _HotelTile({required this.hotel, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: selected ? AppTheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading:
            Icon(Icons.hotel, color: selected ? AppTheme.primary : Colors.grey),
        title: Text(hotel.name),
        trailing: selected ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
      ),
    );
  }
}

class _RoomSelector extends ConsumerWidget {
  final int hotelId;
  final String category;
  final Room? selectedRoom;
  final ValueChanged<Room> onRoomSelected;

  const _RoomSelector({
    required this.hotelId,
    required this.category,
    required this.selectedRoom,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsForHotelProvider(hotelId));

    return roomsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (rooms) {
        final available =
            rooms.where((r) => r.category == category && r.status == 'available').toList();

        if (available.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.error.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.error.withOpacity(0.3)),
            ),
            child: Text(
              'No available $category rooms in this hotel.',
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
              onTap: () => onRoomSelected(r),
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
