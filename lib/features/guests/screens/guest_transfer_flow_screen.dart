import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/guests_provider.dart';
import '../../hotels/providers/hotels_provider.dart';

/// Guest Transfer = move guest to a different hotel.
/// Billing history carries over (same guest ID).
class GuestTransferFlowScreen extends ConsumerStatefulWidget {
  final int guestId;
  final int eventId;
  const GuestTransferFlowScreen({super.key, required this.guestId, required this.eventId});

  @override
  ConsumerState<GuestTransferFlowScreen> createState() => _GuestTransferFlowScreenState();
}

class _GuestTransferFlowScreenState extends ConsumerState<GuestTransferFlowScreen> {
  Hotel? _destHotel;
  Room? _destRoom;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final guestAsync = ref.watch(guestByIdProvider(widget.guestId));
    final hotelsAsync = ref.watch(hotelsForEventProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer Guest')),
      body: guestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (guest) {
          if (guest == null) return const Center(child: Text('Guest not found'));

          return Column(
            children: [
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
                      guest.currentHotelId != null
                          ? 'Currently at Hotel ID: ${guest.currentHotelId}'
                          : 'Not checked in',
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Billing history will carry over to the new hotel.',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.primary, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('Select Destination Hotel',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    hotelsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                      data: (hotels) {
                        final others = hotels
                            .where((h) => h.id != guest.currentHotelId)
                            .toList();
                        if (others.isEmpty) {
                          return const Text(
                              'No other hotels available for transfer.');
                        }
                        return Column(
                          children: others
                              .map((h) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: _destHotel?.id == h.id
                                            ? AppTheme.primary
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () => setState(() {
                                        _destHotel = h;
                                        _destRoom = null;
                                      }),
                                      leading: Icon(Icons.hotel,
                                          color: _destHotel?.id == h.id
                                              ? AppTheme.primary
                                              : Colors.grey),
                                      title: Text(h.name),
                                      trailing: _destHotel?.id == h.id
                                          ? const Icon(Icons.check_circle,
                                              color: AppTheme.primary)
                                          : null,
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                    if (_destHotel != null) ...[
                      const SizedBox(height: 20),
                      Text('Select Room (${guest.assignedCategory})',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _DestRooms(
                        hotelId: _destHotel!.id,
                        category: guest.assignedCategory,
                        selectedRoom: _destRoom,
                        onSelected: (r) => setState(() => _destRoom = r),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: (_destRoom != null && !_saving) ? () => _confirm(context) : null,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Confirm Transfer'),
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
      title: 'Confirm Transfer',
      message:
          'Transfer guest to ${_destHotel!.name} — Room ${_destRoom!.number}?\n\nBilling history will carry over.',
      confirmLabel: 'Transfer',
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      // Transfer is a room change to a different hotel — same DAO method
      await ref.read(guestsRepositoryProvider).changeRoom(
            guestId: widget.guestId,
            newHotelId: _destHotel!.id,
            newRoomId: _destRoom!.id,
          );
      if (mounted) navigator.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _DestRooms extends ConsumerWidget {
  final int hotelId;
  final String category;
  final Room? selectedRoom;
  final ValueChanged<Room> onSelected;

  const _DestRooms({
    required this.hotelId,
    required this.category,
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
            .where((r) => r.status == 'available' && r.category == category)
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
              'No available $category rooms at this hotel.',
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
