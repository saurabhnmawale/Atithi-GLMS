import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../app.dart';
import '../providers/guests_provider.dart';
import '../../billing/providers/billing_provider.dart';
import '../../hotels/providers/hotels_provider.dart';
import '../../events/providers/events_provider.dart';

class GuestDetailScreen extends ConsumerStatefulWidget {
  final int guestId;
  final int eventId;
  const GuestDetailScreen({super.key, required this.guestId, required this.eventId});

  @override
  ConsumerState<GuestDetailScreen> createState() => _GuestDetailScreenState();
}

class _GuestDetailScreenState extends ConsumerState<GuestDetailScreen> {
  Timer? _undoTimer;
  Duration _remaining = Duration.zero;

  @override
  void dispose() {
    _undoTimer?.cancel();
    super.dispose();
  }

  void _startUndoCountdown(DateTime expiresAt) {
    _undoTimer?.cancel();
    _undoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final rem = expiresAt.difference(DateTime.now());
      if (!mounted) return;
      if (rem.isNegative) {
        _undoTimer?.cancel();
        setState(() => _remaining = Duration.zero);
        ref.read(guestsRepositoryProvider).processExpiredUndoWindows();
      } else {
        setState(() => _remaining = rem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final guestAsync = ref.watch(guestByIdProvider(widget.guestId));
    final staysAsync = ref.watch(staySegmentsProvider(widget.guestId));
    final totalAsync = ref.watch(runningTotalProvider(widget.guestId));
    final undoAsync = ref.watch(undoWindowProvider(widget.guestId));
    final hotelsAsync = ref.watch(hotelsForEventProvider(widget.eventId));
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));

    return guestAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (guest) {
        if (guest == null) return const Scaffold(body: Center(child: Text('Guest not found')));

        // Resolve effective checkout date
        final effectiveCheckoutDate = guest.checkoutDate ??
            eventAsync.whenOrNull(data: (e) => e?.endDate);

        // Start countdown if undo window is active
        undoAsync.whenData((window) {
          if (window != null && !window.expiresAt.isBefore(DateTime.now())) {
            if (_undoTimer == null || !_undoTimer!.isActive) {
              _startUndoCountdown(window.expiresAt);
            }
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(guest.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _editGuestInfo(context, guest, effectiveCheckoutDate),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Undo banner (Dusty Rose, prominent)
              undoAsync.when(
                data: (window) {
                  if (window == null || window.expiresAt.isBefore(DateTime.now())) {
                    return const SizedBox.shrink();
                  }
                  final mins = _remaining.inMinutes;
                  final secs = _remaining.inSeconds % 60;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.warning),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.undo, color: AppTheme.warning),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Checked out — Undo available for ${mins}m ${secs}s',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _undoCheckout(context, guest, hotelsAsync),
                          child: const Text('UNDO',
                              style: TextStyle(color: AppTheme.warning)),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // Guest info card
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StatusBadge(
                            label: GuestStatusHelper.label(guest.status),
                            color: GuestStatusHelper.color(guest.status),
                          ),
                          const SizedBox(width: 8),
                          GuestTagChip(
                              isVip: guest.isVip,
                              isCloseRelative: guest.isCloseRelative),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Checkout date row (tappable to override)
                      _CheckoutDateRow(
                        date: effectiveCheckoutDate,
                        isOverridden: guest.checkoutDate != null,
                        onTap: () => _pickCheckoutDate(context, guest, effectiveCheckoutDate),
                      ),
                      if (guest.specialRequests != null &&
                          guest.specialRequests!.isNotEmpty)
                        _InfoRow('Special Requests', guest.specialRequests!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Running bill
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      const Text('Running Bill',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      totalAsync.when(
                        data: (total) => Text(
                          formatCurrency(total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        loading: () => const Text('—'),
                        error: (_, __) => const Text('—'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.billingView,
                          arguments: {'guestId': guest.id, 'eventId': widget.eventId},
                        ),
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              const Text('Actions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildActions(context, guest),
              const SizedBox(height: 20),

              // Stay history
              const Text('Stay History',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              staysAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (stays) {
                  if (stays.isEmpty) {
                    return const Text('No stay history yet.',
                        style: TextStyle(color: AppTheme.textSecondary));
                  }
                  return Column(
                    children: stays.map((s) => _StayTile(stay: s)).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context, Guest guest) {
    if (guest.status == 'not_checked_in') {
      return FilledButton.icon(
        icon: const Icon(Icons.login),
        label: const Text('Check In'),
        onPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.checkinFlow,
          arguments: {'guestId': guest.id, 'eventId': widget.eventId},
        ),
      );
    }

    if (guest.status == 'checked_in') {
      return Column(
        children: [
          FilledButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Log Service Charge'),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.serviceLogging,
              arguments: {'guestId': guest.id, 'eventId': widget.eventId},
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Change Room'),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.roomChangeFlow,
              arguments: {'guestId': guest.id, 'eventId': widget.eventId},
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.transfer_within_a_station),
            label: const Text('Transfer to Another Hotel'),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.guestTransferFlow,
              arguments: {'guestId': guest.id, 'eventId': widget.eventId},
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Check Out'),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.warning,
                side: const BorderSide(color: AppTheme.warning)),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.checkoutFlow,
              arguments: {'guestId': guest.id, 'eventId': widget.eventId},
            ),
          ),
        ],
      );
    }

    return const Text('Guest has checked out.',
        style: TextStyle(color: AppTheme.textSecondary));
  }

  Future<void> _pickCheckoutDate(
    BuildContext context,
    Guest guest,
    DateTime? currentEffective,
  ) async {
    final eventAsync = ref.read(eventByIdProvider(widget.eventId));
    final event = eventAsync.whenOrNull(data: (e) => e);

    final initial = guest.checkoutDate ?? event?.endDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Checkout Date',
    );
    if (picked == null) return;

    await ref.read(guestsRepositoryProvider).updateCheckoutDate(guest.id, picked);
  }

  Future<void> _undoCheckout(
    BuildContext context,
    Guest guest,
    AsyncValue<List<Hotel>> hotelsAsync,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final stays = await ref.read(guestsRepositoryProvider).getStaySegments(guest.id);
    if (stays.isEmpty) return;
    final lastStay = stays.first;

    final success = await ref.read(guestsRepositoryProvider).undoCheckout(
          guestId: guest.id,
          hotelId: lastStay.hotelId,
          roomId: lastStay.roomId,
        );

    if (mounted) {
      messenger.showSnackBar(
        SnackBar(
            content: Text(success ? 'Checkout undone' : 'Undo window has expired')),
      );
    }
  }

  Future<void> _editGuestInfo(
    BuildContext context,
    Guest guest,
    DateTime? effectiveCheckoutDate,
  ) async {
    bool isVip = guest.isVip;
    bool isCloseRelative = guest.isCloseRelative;
    final requestsCtrl = TextEditingController(text: guest.specialRequests ?? '');

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
              const Text('Guest Tags',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text('VIP'),
                value: isVip,
                activeColor: AppTheme.primary,
                onChanged: (v) => setLocalState(() => isVip = v),
              ),
              SwitchListTile(
                title: const Text('Close Relative'),
                value: isCloseRelative,
                activeColor: AppTheme.primary,
                onChanged: (v) => setLocalState(() => isCloseRelative = v),
              ),
              TextField(
                controller: requestsCtrl,
                decoration: const InputDecoration(
                    labelText: 'Special Requests (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  await ref.read(guestsRepositoryProvider).updateGuestTags(
                        guestId: guest.id,
                        isVip: isVip,
                        isCloseRelative: isCloseRelative,
                        specialRequests: requestsCtrl.text.isEmpty
                            ? null
                            : requestsCtrl.text.trim(),
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save Tags'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Checkout date row — shows effective date, tappable to override ────────────

class _CheckoutDateRow extends StatelessWidget {
  final DateTime? date;
  final bool isOverridden;
  final VoidCallback onTap;

  const _CheckoutDateRow({
    required this.date,
    required this.isOverridden,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: Text('Checkout Date',
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(
              date != null ? fmt.format(date!) : 'Not set',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isOverridden)
                  const Text('(overridden)',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.primary)),
                const SizedBox(width: 4),
                const Icon(Icons.edit_calendar_outlined,
                    size: 16, color: AppTheme.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class _StayTile extends StatelessWidget {
  final StaySegment stay;
  const _StayTile({required this.stay});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yy, HH:mm');
    final isOpen = stay.checkOutAt == null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isOpen ? Icons.hotel : Icons.check,
          color: isOpen ? AppTheme.success : AppTheme.neutralStone,
        ),
        title: Text('Room #${stay.roomId}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'In: ${fmt.format(stay.checkInAt)}'
          '${stay.checkOutAt != null ? '\nOut: ${fmt.format(stay.checkOutAt!)}' : ''}',
        ),
        trailing: isOpen
            ? const StatusBadge(label: 'Active', color: AppTheme.success)
            : null,
      ),
    );
  }
}
