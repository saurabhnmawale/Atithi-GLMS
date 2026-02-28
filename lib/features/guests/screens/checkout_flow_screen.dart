import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/guests_provider.dart';
import '../../billing/providers/billing_provider.dart';

class CheckoutFlowScreen extends ConsumerStatefulWidget {
  final int guestId;
  final int eventId;
  const CheckoutFlowScreen({super.key, required this.guestId, required this.eventId});

  @override
  ConsumerState<CheckoutFlowScreen> createState() => _CheckoutFlowScreenState();
}

class _CheckoutFlowScreenState extends ConsumerState<CheckoutFlowScreen> {
  bool _saving = false;
  final bool _checkedOut = false;

  @override
  Widget build(BuildContext context) {
    final guestAsync = ref.watch(guestByIdProvider(widget.guestId));
    final chargesAsync = ref.watch(chargesForGuestProvider(widget.guestId));
    final totalAsync = ref.watch(runningTotalProvider(widget.guestId));
    final serviceTypesAsync = ref.watch(serviceTypesProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Check Out')),
      body: guestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (guest) {
          if (guest == null) return const Center(child: Text('Guest not found'));

          return Column(
            children: [
              // Guest header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(guest.name[0].toUpperCase()),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(guest.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          'Room: ${guest.currentRoomId ?? "—"}',
                          style: const TextStyle(
                              fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    totalAsync.when(
                      data: (total) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total Bill',
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.textSecondary)),
                          Text(
                            formatCurrency(total),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('—'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: chargesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (charges) {
                    return serviceTypesAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (types) {
                        final typeMap = {for (final t in types) t.id: t.name};
                        final fmt = DateFormat('dd MMM, HH:mm');

                        return ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            const Text('Itemized Bill',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            if (charges.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text('No charges logged.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppTheme.textSecondary)),
                              ),
                            ...charges.map((c) => ListTile(
                                  dense: true,
                                  leading: const Icon(
                                      Icons.receipt_outlined,
                                      size: 18),
                                  title: Text(typeMap[c.typeId] ?? 'Service'),
                                  subtitle: Text(fmt.format(c.loggedAt)),
                                  trailing: Text(
                                    formatCurrency(c.amount),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            if (charges.isNotEmpty) ...[
                              const Divider(),
                              ListTile(
                                title: const Text('Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                trailing: totalAsync.when(
                                  data: (t) => Text(
                                    formatCurrency(t),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary),
                                  ),
                                  loading: () => const Text('—'),
                                  error: (_, __) => const Text('—'),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.warning.withValues(alpha:0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppTheme.warning.withValues(alpha:0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: AppTheme.warning, size: 18),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'After checkout, you have 5 minutes to undo. Bill will be locked after that.',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              if (!_checkedOut)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilledButton(
                    onPressed: _saving ? null : () => _checkout(context),
                    style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Confirm Checkout'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _checkout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final ok = await showConfirmDialog(
      context,
      title: 'Confirm Checkout',
      message:
          'Check out this guest? You will have 5 minutes to undo.',
      confirmLabel: 'Check Out',
      destructive: true,
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      await ref.read(guestsRepositoryProvider).checkOut(widget.guestId);
      if (mounted) {
        // Pop back to guest detail which shows undo banner
        navigator.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
