import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../app.dart';
import '../providers/events_provider.dart';
import '../../../data/repositories/events_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atithi GLMS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Event',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.eventSetup),
          ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          if (events.isEmpty) {
            return EmptyState(
              icon: Icons.event_note,
              title: 'No events yet',
              subtitle: 'Create your first event to get started',
              actionLabel: 'Create Event',
              onAction: () => Navigator.pushNamed(context, AppRoutes.eventSetup),
            );
          }

          final active = events.where((e) => !e.isArchived).toList();
          final archived = events.where((e) => e.isArchived).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (active.isNotEmpty) ...[
                SectionHeader(title: 'Active Events (${active.length})'),
                ...active.map((e) => _EventCard(event: e)),
              ],
              if (archived.isNotEmpty) ...[
                SectionHeader(title: 'Archived (${archived.length})'),
                ...archived.map((e) => _EventCard(event: e, archived: true)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.eventSetup),
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _EventCard extends ConsumerWidget {
  final Event event;
  final bool archived;

  const _EventCard({required this.event, this.archived = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(eventsRepositoryProvider);
    final fmt = DateFormat('dd MMM yyyy');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.eventDashboard,
          arguments: {'eventId': event.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  _TypeChip(event.type),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenu(context, ref, value, repo),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                          value: 'duplicate', child: Text('Duplicate as template')),
                      PopupMenuItem(
                        value: archived ? 'unarchive' : 'archive',
                        child: Text(archived ? 'Unarchive' : 'Archive'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${fmt.format(event.startDate)} — ${fmt.format(event.endDate)}',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleMenu(
    BuildContext context,
    WidgetRef ref,
    String value,
    EventsRepository repo,
  ) async {
    switch (value) {
      case 'edit':
        Navigator.pushNamed(
          context,
          AppRoutes.eventSetup,
          arguments: {'eventId': event.id},
        );
      case 'duplicate':
        final nameCtrl = TextEditingController(text: '${event.name} (Copy)');
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Duplicate Event'),
            content: TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'New event name'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true), child: const Text('Duplicate')),
            ],
          ),
        );
        if (confirmed == true && nameCtrl.text.isNotEmpty) {
          await repo.duplicateEvent(event.id, nameCtrl.text.trim());
        }
      case 'archive':
        await repo.archiveEvent(event.id);
      case 'unarchive':
        await repo.unarchiveEvent(event.id);
    }
  }
}

class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip(this.type);

  @override
  Widget build(BuildContext context) {
    final isWedding = type == 'wedding';
    return StatusBadge(
      label: isWedding ? 'Wedding' : 'Corporate',
      color: isWedding ? AppTheme.accent : AppTheme.primary,
    );
  }
}
