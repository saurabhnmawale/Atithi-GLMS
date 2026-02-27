import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../providers/billing_provider.dart';

class ServiceLoggingScreen extends ConsumerStatefulWidget {
  final int guestId;
  final int eventId;
  const ServiceLoggingScreen({super.key, required this.guestId, required this.eventId});

  @override
  ConsumerState<ServiceLoggingScreen> createState() => _ServiceLoggingScreenState();
}

class _ServiceLoggingScreenState extends ConsumerState<ServiceLoggingScreen> {
  int? _selectedTypeId;
  final _amountCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(serviceTypesProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Log Service Charge')),
      body: typesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (types) {
          if (types.isEmpty) {
            return EmptyState(
              icon: Icons.room_service,
              title: 'No service types configured',
              subtitle: 'Add service types in Event Settings first',
              actionLabel: 'Go Back',
              onAction: () => Navigator.pop(context),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('Service Type',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...types.map((t) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: _selectedTypeId == t.id
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            onTap: () =>
                                setState(() => _selectedTypeId = t.id),
                            title: Text(t.name),
                            trailing: _selectedTypeId == t.id
                                ? const Icon(Icons.check_circle,
                                    color: AppTheme.primary)
                                : null,
                          ),
                        )),
                    const SizedBox(height: 20),
                    const Text('Amount (₹)',
                        style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        prefixText: '₹ ',
                        hintText: '0.00',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: (_selectedTypeId != null &&
                          _amountCtrl.text.isNotEmpty &&
                          !_saving)
                      ? () => _save(context)
                      : null,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Log Charge'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(billingRepositoryProvider).logCharge(
            guestId: widget.guestId,
            typeId: _selectedTypeId!,
            amount: amount,
          );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Charge logged')));
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
