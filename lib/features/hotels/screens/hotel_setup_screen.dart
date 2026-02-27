import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/hotels_provider.dart';

class HotelSetupScreen extends ConsumerStatefulWidget {
  final int eventId;
  final int? hotelId; // null = create new

  const HotelSetupScreen({super.key, required this.eventId, this.hotelId});

  @override
  ConsumerState<HotelSetupScreen> createState() => _HotelSetupScreenState();
}

class _HotelSetupScreenState extends ConsumerState<HotelSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  bool _saving = false;

  // Room entry list
  final List<_RoomEntry> _rooms = [];

  bool get _isEditing => widget.hotelId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(hotelsRepositoryProvider);
    final hotel = await repo.getHotelById(widget.hotelId!);
    if (hotel != null && mounted) {
      _nameCtrl.text = hotel.name;
      final rooms = await repo.getRoomsForHotel(hotel.id);
      setState(() {
        _rooms.addAll(rooms.map((r) => _RoomEntry(
              number: r.number,
              category: r.category,
              status: r.status,
              existingId: r.id,
            )));
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _addRoomRow() {
    setState(() => _rooms.add(_RoomEntry(number: '', category: 'Deluxe', status: 'available')));
  }

  void _removeRoom(int index) {
    setState(() => _rooms.removeAt(index));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final repo = ref.read(hotelsRepositoryProvider);

    try {
      int hotelId;
      if (_isEditing) {
        await repo.updateHotel(id: widget.hotelId!, name: _nameCtrl.text.trim());
        hotelId = widget.hotelId!;
      } else {
        hotelId =
            await repo.addHotel(eventId: widget.eventId, name: _nameCtrl.text.trim());
      }

      // Add new rooms
      for (final r in _rooms.where((r) => r.existingId == null)) {
        if (r.number.trim().isNotEmpty) {
          await repo.addRoom(
            hotelId: hotelId,
            number: r.number.trim(),
            category: r.category,
            status: r.status,
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['Deluxe', 'Suite', 'Standard', 'Premium', 'Executive'];

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Hotel' : 'Add Hotel')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Hotel Name *',
                      hintText: 'e.g. The Grand Hyatt',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Hotel name required' : null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        'Room Inventory',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _addRoomRow,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Room'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_rooms.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No rooms added yet. Tap "Add Room" to add rooms.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ...List.generate(_rooms.length, (i) {
                    final r = _rooms[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: r.number,
                                decoration: const InputDecoration(
                                  labelText: 'Room No.',
                                  isDense: true,
                                ),
                                onChanged: (v) => _rooms[i] = r.copyWith(number: v),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<String>(
                                value: r.category,
                                decoration: const InputDecoration(
                                  labelText: 'Category',
                                  isDense: true,
                                ),
                                items: categories
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _rooms[i] = r.copyWith(category: v!)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (r.existingId == null)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _removeRoom(i),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Add Hotel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomEntry {
  final String number;
  final String category;
  final String status;
  final int? existingId;

  _RoomEntry({
    required this.number,
    required this.category,
    required this.status,
    this.existingId,
  });

  _RoomEntry copyWith({String? number, String? category, String? status}) => _RoomEntry(
        number: number ?? this.number,
        category: category ?? this.category,
        status: status ?? this.status,
        existingId: existingId,
      );
}
