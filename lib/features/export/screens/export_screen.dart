import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../events/providers/events_provider.dart';
import '../../../data/providers/database_provider.dart';
import '../services/export_service.dart';

class ExportScreen extends ConsumerStatefulWidget {
  final int eventId;
  const ExportScreen({super.key, required this.eventId});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportType? _exporting;

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (event) {
          if (event == null) return const Center(child: Text('Event not found'));

          final exportService = ExportService(
            db: ref.read(databaseProvider),
            event: event,
          );

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ExportCard(
                    icon: Icons.person_outline,
                    title: 'Per-Guest Itemized Bill',
                    subtitle: 'One sheet per guest with all service charges and total',
                    color: AppTheme.primary,
                    isLoading: _exporting == ExportType.guestBills,
                    onTap: () => _export(exportService, ExportType.guestBills),
                  ),
                  _ExportCard(
                    icon: Icons.hotel_outlined,
                    title: 'Per-Hotel Billing Summary',
                    subtitle: 'Breakdown by hotel — guests, charges, subtotals',
                    color: Colors.teal,
                    isLoading: _exporting == ExportType.hotelSummary,
                    onTap: () => _export(exportService, ExportType.hotelSummary),
                  ),
                  _ExportCard(
                    icon: Icons.summarize_outlined,
                    title: 'Consolidated Event Billing',
                    subtitle: 'All guests, cross-hotel totals, grand total',
                    color: Colors.indigo,
                    isLoading: _exporting == ExportType.consolidatedBilling,
                    onTap: () =>
                        _export(exportService, ExportType.consolidatedBilling),
                  ),
                  _ExportCard(
                    icon: Icons.swap_horiz,
                    title: 'Guest Movement & Room History',
                    subtitle: 'Chronological stays — hotel, room, duration per guest',
                    color: Colors.deepPurple,
                    isLoading: _exporting == ExportType.guestMovement,
                    onTap: () => _export(exportService, ExportType.guestMovement),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha:0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reports are generated as .xlsx and shared via your device share sheet (WhatsApp, Email, Files, etc.)',
                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_exporting != null) const LoadingOverlay(message: 'Generating report...'),
            ],
          );
        },
      ),
    );
  }

  Future<void> _export(ExportService service, ExportType type) async {
    if (_exporting != null) return;
    setState(() => _exporting = type);

    try {
      await service.export(type);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = null);
    }
  }
}

class _ExportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ExportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: color),
                      )
                    : Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.share_outlined, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
