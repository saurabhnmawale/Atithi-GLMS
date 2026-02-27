import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/theme/app_theme.dart';
import '../providers/events_provider.dart';

class EventSetupScreen extends ConsumerStatefulWidget {
  final int? eventId; // null = create new

  const EventSetupScreen({super.key, this.eventId});

  @override
  ConsumerState<EventSetupScreen> createState() => _EventSetupScreenState();
}

class _EventSetupScreenState extends ConsumerState<EventSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String _type = 'wedding';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _saving = false;

  bool get _isEditing => widget.eventId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final event =
        await ref.read(eventsRepositoryProvider).getEventById(widget.eventId!);
    if (event != null && mounted) {
      setState(() {
        _nameCtrl.text = event.name;
        _type = event.type;
        _startDate = event.startDate;
        _endDate = event.endDate;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select event dates')));
      return;
    }

    setState(() => _saving = true);
    final repo = ref.read(eventsRepositoryProvider);

    try {
      if (_isEditing) {
        await repo.updateEvent(
          id: widget.eventId!,
          name: _nameCtrl.text.trim(),
          type: _type,
          startDate: _startDate!,
          endDate: _endDate!,
        );
        if (mounted) Navigator.pop(context);
      } else {
        final newId = await repo.createEvent(
          name: _nameCtrl.text.trim(),
          type: _type,
          startDate: _startDate!,
          endDate: _endDate!,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/event-dashboard',
            arguments: {'eventId': newId},
          );
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Event' : 'New Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Event Name *',
                hintText: 'e.g. Sharma Wedding 2025',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Event name is required' : null,
            ),
            const SizedBox(height: 20),
            const Text('Event Type',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Wedding',
                    icon: Icons.favorite,
                    selected: _type == 'wedding',
                    onTap: () => setState(() => _type = 'wedding'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeButton(
                    label: 'Corporate',
                    icon: Icons.business,
                    selected: _type == 'corporate',
                    onTap: () => setState(() => _type = 'corporate'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'Start Date',
                    date: _startDate,
                    fmt: fmt,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTile(
                    label: 'End Date',
                    date: _endDate,
                    fmt: fmt,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_isEditing ? 'Save Changes' : 'Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppTheme.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : AppTheme.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppTheme.textPrimary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final DateFormat fmt;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.date,
    required this.fmt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Text(
              date != null ? fmt.format(date!) : 'Select date',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: date != null ? AppTheme.textPrimary : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
