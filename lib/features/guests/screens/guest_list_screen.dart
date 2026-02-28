import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../app.dart';
import '../providers/guests_provider.dart';

class GuestListScreen extends ConsumerStatefulWidget {
  final int eventId;
  const GuestListScreen({super.key, required this.eventId});

  @override
  ConsumerState<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends ConsumerState<GuestListScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _filterStatus;
  bool? _filterVip;
  bool? _filterCloseRelative;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Guest> _applyFilters(List<Guest> guests) {
    return guests.where((g) {
      final nameMatch =
          _searchQuery.isEmpty || g.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final statusMatch = _filterStatus == null || g.status == _filterStatus;
      final vipMatch = _filterVip == null || g.isVip == _filterVip;
      final relMatch =
          _filterCloseRelative == null || g.isCloseRelative == _filterCloseRelative;
      return nameMatch && statusMatch && vipMatch && relMatch;
    }).toList();
  }

  Future<void> _importCsv() async {
    // withData: true ensures bytes are always populated on every platform.
    // On web, accessing `path` throws a DartError; on iOS it can be null.
    // Always read from bytes — it works everywhere.
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    if (result == null) return;

    final picked = result.files.single;
    if (picked.bytes == null) return;
    final content = String.fromCharCodes(picked.bytes!);
    final rows = const CsvToListConverter().convert(content, eol: '\n');
    if (rows.isEmpty) return;

    final headers = rows.first.map((h) => h.toString().toLowerCase().trim()).toList();
    final nameIdx = headers.indexOf('name');
    final catIdx = headers.indexOf('category');
    if (nameIdx < 0 || catIdx < 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'CSV must have "name" and "category" columns')),
        );
      }
      return;
    }

    final preview = rows
        .skip(1)
        .where((r) => r.length > nameIdx && r[nameIdx].toString().isNotEmpty)
        .map((r) => {
              'name': r[nameIdx].toString().trim(),
              'category': r.length > catIdx ? r[catIdx].toString().trim() : 'Standard',
              'vip': headers.contains('vip') ? r[headers.indexOf('vip')].toString() == 'true' : false,
              'close_relative': headers.contains('close_relative') ? r[headers.indexOf('close_relative')].toString() == 'true' : false,
              'special_requests': headers.contains('special_requests') ? r[headers.indexOf('special_requests')].toString() : null,
            })
        .toList();

    // Preview dialog
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Import ${preview.length} guests?'),
        content: SizedBox(
          width: double.maxFinite,
          height: 200,
          child: ListView.builder(
            itemCount: preview.take(10).length,
            itemBuilder: (_, i) => ListTile(
              dense: true,
              title: Text(preview[i]['name'] as String),
              subtitle: Text(preview[i]['category'] as String),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: const Text('Import')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(guestsRepositoryProvider).importGuests(widget.eventId, preview);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${preview.length} guests imported')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final guestsAsync = ref.watch(guestsForEventProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import CSV',
            onPressed: _importCsv,
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Guest',
            onPressed: () => _showAddGuestDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search guests...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _searchCtrl.clear();
                          _searchQuery = '';
                        }),
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _FilterChipLocal(
                  label: 'All',
                  selected: _filterStatus == null && _filterVip == null,
                  onTap: () => setState(() {
                    _filterStatus = null;
                    _filterVip = null;
                    _filterCloseRelative = null;
                  }),
                ),
                _FilterChipLocal(
                  label: 'Not In',
                  selected: _filterStatus == 'not_checked_in',
                  onTap: () => setState(() => _filterStatus = 'not_checked_in'),
                ),
                _FilterChipLocal(
                  label: 'Checked In',
                  selected: _filterStatus == 'checked_in',
                  color: AppTheme.success,
                  onTap: () => setState(() => _filterStatus = 'checked_in'),
                ),
                _FilterChipLocal(
                  label: 'Checked Out',
                  selected: _filterStatus == 'checked_out',
                  color: AppTheme.textSecondary,
                  onTap: () => setState(() => _filterStatus = 'checked_out'),
                ),
                _FilterChipLocal(
                  label: 'VIP',
                  selected: _filterVip == true,
                  color: AppTheme.vipGold,
                  onTap: () => setState(
                      () => _filterVip = _filterVip == true ? null : true),
                ),
                _FilterChipLocal(
                  label: 'Close Relative',
                  selected: _filterCloseRelative == true,
                  color: AppTheme.relativeBlue,
                  onTap: () => setState(() =>
                      _filterCloseRelative =
                          _filterCloseRelative == true ? null : true),
                ),
              ],
            ),
          ),
          Expanded(
            child: guestsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (guests) {
                final filtered = _applyFilters(guests);
                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.person_search,
                    title: 'No guests found',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _GuestTile(
                    guest: filtered[i],
                    eventId: widget.eventId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddGuestDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    String category = 'Deluxe';
    const categories = ['Standard', 'Deluxe', 'Suite', 'Premium', 'Executive'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Guest',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Guest Name *'),
                textCapitalization: TextCapitalization.words,
                autofocus: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(category),
                value: category,
                decoration: const InputDecoration(labelText: 'Room Category'),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setLocalState(() => category = v!),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isEmpty) return;
                  await ref.read(guestsRepositoryProvider).addGuest(
                        eventId: widget.eventId,
                        name: nameCtrl.text.trim(),
                        assignedCategory: category,
                      );
                  if (context.mounted) Navigator.pop(ctx);
                },
                child: const Text('Add Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestTile extends StatelessWidget {
  final Guest guest;
  final int eventId;

  const _GuestTile({required this.guest, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.guestDetail,
          arguments: {'guestId': guest.id, 'eventId': eventId},
        ),
        leading: CircleAvatar(
          backgroundColor: GuestStatusHelper.color(guest.status).withValues(alpha:0.15),
          child: Text(
            guest.name.isNotEmpty ? guest.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: GuestStatusHelper.color(guest.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(guest.name)),
            GuestTagChip(isVip: guest.isVip, isCloseRelative: guest.isCloseRelative),
          ],
        ),
        subtitle: Text(
          '${guest.assignedCategory} • ${GuestStatusHelper.label(guest.status)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: StatusBadge(
          label: GuestStatusHelper.label(guest.status),
          color: GuestStatusHelper.color(guest.status),
        ),
      ),
    );
  }
}

class _FilterChipLocal extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChipLocal({
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
            fontSize: 12,
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
