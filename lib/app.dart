import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';
import 'features/events/screens/home_screen.dart';
import 'features/events/screens/event_setup_screen.dart';
import 'features/dashboard/screens/event_dashboard_screen.dart';
import 'features/hotels/screens/hotel_setup_screen.dart';
import 'features/hotels/screens/room_inventory_screen.dart';
import 'features/guests/screens/guest_list_screen.dart';
import 'features/guests/screens/guest_detail_screen.dart';
import 'features/guests/screens/checkin_flow_screen.dart';
import 'features/guests/screens/room_change_flow_screen.dart';
import 'features/guests/screens/guest_transfer_flow_screen.dart';
import 'features/guests/screens/checkout_flow_screen.dart';
import 'features/billing/screens/service_logging_screen.dart';
import 'features/billing/screens/billing_view_screen.dart';
import 'features/billing/screens/service_type_config_screen.dart';
import 'features/export/screens/export_screen.dart';

class AtithiApp extends ConsumerWidget {
  const AtithiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Atithi GLMS',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

class AppRoutes {
  static const home = '/';
  static const eventSetup = '/event-setup';
  static const eventDashboard = '/event-dashboard';
  static const hotelSetup = '/hotel-setup';
  static const roomInventory = '/room-inventory';
  static const guestList = '/guest-list';
  static const guestDetail = '/guest-detail';
  static const checkinFlow = '/checkin';
  static const roomChangeFlow = '/room-change';
  static const guestTransferFlow = '/guest-transfer';
  static const checkoutFlow = '/checkout';
  static const serviceLogging = '/service-logging';
  static const billingView = '/billing-view';
  static const serviceTypeConfig = '/service-type-config';
  static const exportScreen = '/export';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.eventSetup:
        return MaterialPageRoute(
          builder: (_) => EventSetupScreen(eventId: args?['eventId'] as int?),
        );

      case AppRoutes.eventDashboard:
        return MaterialPageRoute(
          builder: (_) => EventDashboardScreen(eventId: args!['eventId'] as int),
        );

      case AppRoutes.hotelSetup:
        return MaterialPageRoute(
          builder: (_) => HotelSetupScreen(
            eventId: args!['eventId'] as int,
            hotelId: args['hotelId'] as int?,
          ),
        );

      case AppRoutes.roomInventory:
        return MaterialPageRoute(
          builder: (_) => RoomInventoryScreen(eventId: args!['eventId'] as int),
        );

      case AppRoutes.guestList:
        return MaterialPageRoute(
          builder: (_) => GuestListScreen(eventId: args!['eventId'] as int),
        );

      case AppRoutes.guestDetail:
        return MaterialPageRoute(
          builder: (_) => GuestDetailScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.checkinFlow:
        return MaterialPageRoute(
          builder: (_) => CheckinFlowScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.roomChangeFlow:
        return MaterialPageRoute(
          builder: (_) => RoomChangeFlowScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.guestTransferFlow:
        return MaterialPageRoute(
          builder: (_) => GuestTransferFlowScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.checkoutFlow:
        return MaterialPageRoute(
          builder: (_) => CheckoutFlowScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.serviceLogging:
        return MaterialPageRoute(
          builder: (_) => ServiceLoggingScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.billingView:
        return MaterialPageRoute(
          builder: (_) => BillingViewScreen(
            guestId: args!['guestId'] as int,
            eventId: args['eventId'] as int,
          ),
        );

      case AppRoutes.serviceTypeConfig:
        return MaterialPageRoute(
          builder: (_) => ServiceTypeConfigScreen(eventId: args!['eventId'] as int),
        );

      case AppRoutes.exportScreen:
        return MaterialPageRoute(
          builder: (_) => ExportScreen(eventId: args!['eventId'] as int),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
