import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../app.dart';
import '../providers/billing_provider.dart';
import '../../guests/providers/guests_provider.dart';

class BillingViewScreen extends ConsumerWidget {
  final int guestId;
  final int eventId;
  const BillingViewScreen({super.key, required this.guestId, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestAsync = ref.watch(guestByIdProvider(guestId));
    final chargesAsync = ref.watch(chargesForGuestProvider(guestId));
    final totalAsync = ref.watch(runningTotalProvider(guestId));
    final typesAsync = ref.watch(serviceTypesProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: guestAsync.when(
          data: (g) => Text('Bill — ${g?.name ?? "Guest"}'),
          loading: () => const Text('Bill'),
          error: (_, __) => const Text('Bill'),
        ),
      ),
      body: guestAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (guest) {
          if (guest == null) return const Center(child: Text('Guest not found'));

          final isLocked = guest.status == 'checked_out';

          return chargesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (charges) {
              return typesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (types) {
                  final typeMap = {for (final t in types) t.id: t.name};
                  final fmt = DateFormat('dd MMM yyyy, HH:mm');

                  return Column(
                    children: [
                      // Bill header
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(guest.name,
                                      style: const TextStyle(
                                          fontSize: 17, fontWeight: FontWeight.bold)),
                                  Text(guest.assignedCategory,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                totalAsync.when(
                                  data: (t) => Text(
                                    formatCurrency(t),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  loading: () => const Text('—'),
                                  error: (_, __) => const Text('—'),
                                ),
                                StatusBadge(
                                  label: isLocked ? 'Locked' : 'Open',
                                  color: isLocked ? AppTheme.error : AppTheme.success,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: charges.isEmpty
                            ? const EmptyState(
                                icon: Icons.receipt,
                                title: 'No charges logged',
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: charges.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(indent: 16, endIndent: 16),
                                itemBuilder: (_, i) {
                                  final c = charges[i];
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      radius: 18,
                                      backgroundColor:
                                          Color(0xFFEEF2FF),
                                      child: Icon(Icons.room_service,
                                          size: 16, color: AppTheme.primary),
                                    ),
                                    title: Text(typeMap[c.typeId] ?? 'Service'),
                                    subtitle: Text(fmt.format(c.loggedAt),
                                        style: const TextStyle(fontSize: 12)),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          formatCurrency(c.amount),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        if (!isLocked && !c.isLocked)
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline,
                                                size: 18, color: AppTheme.error),
                                            onPressed: () async {
                                              final ok = await showConfirmDialog(
                                                context,
                                                title: 'Delete Charge',
                                                message: 'Remove this charge?',
                                                confirmLabel: 'Delete',
                                                destructive: true,
                                              );
                                              if (ok == true) {
                                                await ref
                                                    .read(billingRepositoryProvider)
                                                    .deleteCharge(c.id);
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      // Total footer
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Text('Total',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            totalAsync.when(
                              data: (t) => Text(
                                formatCurrency(t),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary),
                              ),
                              loading: () => const Text('—'),
                              error: (_, __) => const Text('—'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: guestAsync.when(
        data: (g) {
          if (g == null || g.status != 'checked_in') return null;
          return FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.serviceLogging,
              arguments: {'guestId': guestId, 'eventId': eventId},
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Charge'),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}
