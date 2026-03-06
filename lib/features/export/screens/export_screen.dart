import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../events/providers/events_provider.dart';
import '../../../data/providers/database_provider.dart';
import '../services/export_service.dart';

// PRD v2.2: single consolidated export — one .xlsx with all guest data.
class ExportScreen extends ConsumerStatefulWidget {
  final int eventId;
  const ExportScreen({super.key, required this.eventId});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _exporting = false;

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
                padding: const EdgeInsets.all(24),
                children: [
                  // Header
                  Text(event.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(
                    'Generate a consolidated Excel report with all guest data, stay history, and billing for this event.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // Gold accent divider
                  const GoldDivider(),
                  const SizedBox(height: 24),

                  // Report description card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.table_chart_outlined,
                                  color: AppTheme.primary),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Consolidated Guest Report',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text('Single .xlsx file',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _ReportColumn(Icons.person_outline, 'Guest name, VIP, Close Relative, Special Requests'),
                        const _ReportColumn(Icons.hotel_outlined, 'Hotel(s) and Room(s) per guest'),
                        const _ReportColumn(Icons.login, 'Check-in date/time and checkout date'),
                        const _ReportColumn(Icons.timeline, 'Full stay segments (transfers included)'),
                        const _ReportColumn(Icons.receipt_long_outlined, 'Service charges by type, total bill'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Generate button
                  FilledButton.icon(
                    icon: _exporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.share_outlined),
                    label: Text(_exporting ? 'Generating…' : 'Generate & Share Report'),
                    onPressed: _exporting ? null : () => _export(exportService),
                  ),
                  const SizedBox(height: 16),

                  // Info note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Report is shared as .xlsx via WhatsApp, Email, Files, or any app on your device.',
                            style: TextStyle(
                                fontSize: 13, color: AppTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_exporting) const LoadingOverlay(message: 'Generating report…'),
            ],
          );
        },
      ),
    );
  }

  Future<void> _export(ExportService service) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      await service.exportConsolidated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _ReportColumn extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ReportColumn(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }
}
