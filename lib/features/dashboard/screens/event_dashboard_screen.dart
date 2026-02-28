import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../app.dart';
import '../../events/providers/events_provider.dart';
import '../../hotels/providers/hotels_provider.dart';
import '../../guests/providers/guests_provider.dart';

class EventDashboardScreen extends ConsumerWidget {
  final int eventId;
  const EventDashboardScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final roomsAsync = ref.watch(roomsForEventProvider(eventId));
    final guestsAsync = ref.watch(guestsForEventProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: eventAsync.when(
          data: (e) => Text(e?.name ?? 'Dashboard'),
          loading: () => const Text('Dashboard'),
          error: (_, __) => const Text('Dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Event Settings',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.eventSetup,
              arguments: {'eventId': eventId},
            ),
          ),
        ],
      ),
      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rooms) {
          final totalRooms = rooms.length;
          final available = rooms.where((r) => r.status == 'available').length;
          final occupied = rooms.where((r) => r.status == 'occupied').length;
          final maintenance = rooms.where((r) => r.status == 'maintenance').length;

          return guestsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (guests) {
              final checkedIn = guests.where((g) => g.status == 'checked_in').length;
              final checkedOut = guests.where((g) => g.status == 'checked_out').length;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Room stats
                  const Text(
                    'Rooms',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      StatCard(
                          label: 'Total Rooms',
                          value: '$totalRooms',
                          icon: Icons.door_back_door_outlined),
                      StatCard(
                          label: 'Available',
                          value: '$available',
                          color: AppTheme.success,
                          icon: Icons.check_circle_outline),
                      StatCard(
                          label: 'Occupied',
                          value: '$occupied',
                          color: AppTheme.error,
                          icon: Icons.person),
                      StatCard(
                          label: 'Maintenance',
                          value: '$maintenance',
                          color: AppTheme.warning,
                          icon: Icons.build_outlined),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Guest stats
                  const Text(
                    'Guests',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: [
                      StatCard(
                          label: 'Total', value: '${guests.length}', icon: Icons.group),
                      StatCard(
                          label: 'Checked In',
                          value: '$checkedIn',
                          color: AppTheme.success,
                          icon: Icons.login),
                      StatCard(
                          label: 'Checked Out',
                          value: '$checkedOut',
                          color: AppTheme.textSecondary,
                          icon: Icons.logout),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action tiles
                  const Text(
                    'Manage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _ActionGrid(eventId: eventId),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  final int eventId;
  const _ActionGrid({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final actions = [
      const _ActionItem(
        icon: Icons.people_outline,
        label: 'Guest List',
        route: AppRoutes.guestList,
        color: AppTheme.primary,
      ),
      const _ActionItem(
        icon: Icons.hotel_outlined,
        label: 'Hotels & Rooms',
        route: AppRoutes.roomInventory,
        color: AppTheme.accent,
      ),
      const _ActionItem(
        icon: Icons.add_business,
        label: 'Add Hotel',
        route: AppRoutes.hotelSetup,
        color: Colors.teal,
      ),
      const _ActionItem(
        icon: Icons.room_service_outlined,
        label: 'Service Types',
        route: AppRoutes.serviceTypeConfig,
        color: Colors.purple,
      ),
      const _ActionItem(
        icon: Icons.file_download_outlined,
        label: 'Export',
        route: AppRoutes.exportScreen,
        color: Colors.indigo,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) {
        final a = actions[i];
        return GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, a.route, arguments: {'eventId': eventId}),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: a.color.withValues(alpha:0.3)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(a.icon, color: a.color, size: 30),
                const SizedBox(height: 8),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  const _ActionItem(
      {required this.icon,
      required this.label,
      required this.route,
      required this.color});
}
