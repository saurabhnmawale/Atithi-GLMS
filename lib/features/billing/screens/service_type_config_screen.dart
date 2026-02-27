import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/billing_provider.dart';

class ServiceTypeConfigScreen extends ConsumerWidget {
  final int eventId;
  const ServiceTypeConfigScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(serviceTypesProvider(eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Service Types')),
      body: typesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (types) {
          if (types.isEmpty) {
            return EmptyState(
              icon: Icons.room_service_outlined,
              title: 'No service types yet',
              subtitle: 'Add types like Minibar, Laundry, Room Service',
              actionLabel: 'Add Service Type',
              onAction: () => _showAddDialog(context, ref),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: types.length,
            itemBuilder: (_, i) {
              final t = types[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.room_service_outlined,
                      color: AppTheme.primary),
                  title: Text(t.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditDialog(context, ref, t.id, t.name),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                        onPressed: () async {
                          final ok = await showConfirmDialog(
                            context,
                            title: 'Delete "${t.name}"?',
                            message:
                                'This will not affect existing charges. Proceed?',
                            confirmLabel: 'Delete',
                            destructive: true,
                          );
                          if (ok == true) {
                            await ref
                                .read(billingRepositoryProvider)
                                .deleteServiceType(t.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Service Type'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
              labelText: 'Service Name', hintText: 'e.g. Minibar'),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              await ref.read(billingRepositoryProvider).addServiceType(
                    eventId: eventId,
                    name: ctrl.text.trim(),
                  );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, WidgetRef ref, int id, String current) async {
    final ctrl = TextEditingController(text: current);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Service Type'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Service Name'),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              await ref
                  .read(billingRepositoryProvider)
                  .updateServiceType(id: id, name: ctrl.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
