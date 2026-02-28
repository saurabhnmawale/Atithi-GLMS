import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import '../../../data/database/app_database.dart';

enum ExportType {
  guestBills,
  hotelSummary,
  consolidatedBilling,
  guestMovement,
}

class ExportService {
  ExportService({
    required this.db,
    required this.event,
  });

  final AppDatabase db;
  final Event event;

  /// Entry point — generates xlsx on the main isolate then shares.
  // BUG 2B FIX: removed compute(). AppDatabase holds FFI Pointer objects
  // (native SQLite handles) that cannot be serialized for isolate message
  // passing — passing it via compute() crashes on Android and iOS.
  // All DB reads are async and already non-blocking; xlsx assembly is fast
  // enough on event-scale data to run on the main isolate without jank.
  Future<void> export(ExportType type) async {
    final params = _ExportParams(
      type: type,
      eventId: event.id,
      eventName: event.name,
      db: db,
    );
    final bytes = await _generate(params);

    final dir = await getTemporaryDirectory();
    final filename = '${_filename(type)}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
        subject: '${event.name} — ${_label(type)}',
      ),
    );
  }

  static String _filename(ExportType type) {
    switch (type) {
      case ExportType.guestBills:
        return 'guest_bills';
      case ExportType.hotelSummary:
        return 'hotel_summary';
      case ExportType.consolidatedBilling:
        return 'consolidated_billing';
      case ExportType.guestMovement:
        return 'guest_movement';
    }
  }

  static String _label(ExportType type) {
    switch (type) {
      case ExportType.guestBills:
        return 'Per-Guest Itemized Bills';
      case ExportType.hotelSummary:
        return 'Per-Hotel Billing Summary';
      case ExportType.consolidatedBilling:
        return 'Consolidated Billing Report';
      case ExportType.guestMovement:
        return 'Guest Movement & Room History';
    }
  }
}

class _ExportParams {
  final ExportType type;
  final int eventId;
  final String eventName;
  final AppDatabase db;

  _ExportParams({
    required this.type,
    required this.eventId,
    required this.eventName,
    required this.db,
  });
}

Future<Uint8List> _generate(_ExportParams params) async {
  switch (params.type) {
    case ExportType.guestBills:
      return _generateGuestBills(params);
    case ExportType.hotelSummary:
      return _generateHotelSummary(params);
    case ExportType.consolidatedBilling:
      return _generateConsolidated(params);
    case ExportType.guestMovement:
      return _generateMovement(params);
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

void _applyHeaderStyle(Range cell) {
  cell.cellStyle.bold = true;
  cell.cellStyle.backColor = '#1A56DB';
  cell.cellStyle.fontColor = '#FFFFFF';
}

// ─── Per-Guest Itemized Bills ─────────────────────────────────────────────────

Future<Uint8List> _generateGuestBills(_ExportParams p) async {
  final wb = Workbook();
  final guests = await p.db.guestsDao.getGuestsForEvent(p.eventId);
  final serviceTypes = await p.db.serviceDao.getServiceTypesForEvent(p.eventId);
  final typeMap = {for (final t in serviceTypes) t.id: t.name};

  // Remove default sheet if guests exist
  if (guests.isEmpty) {
    final sheet = wb.worksheets[0];
    sheet.name = 'No Guests';
    sheet.getRangeByName('A1').setText('No guests found for this event.');
    final bytes = Uint8List.fromList(wb.saveAsStream());
    wb.dispose();
    return bytes;
  }

  bool firstSheet = true;
  for (final guest in guests) {
    final charges = await p.db.serviceDao.getChargesForGuest(guest.id);

    Worksheet sheet;
    if (firstSheet) {
      sheet = wb.worksheets[0];
      firstSheet = false;
    } else {
      sheet = wb.worksheets.addWithName(guest.name.length > 28
          ? guest.name.substring(0, 28)
          : guest.name);
    }
    sheet.name = guest.name.length > 31 ? guest.name.substring(0, 31) : guest.name;

    // Title row
    final titleRange = sheet.getRangeByName('A1:D1');
    titleRange.merge();
    titleRange.setText('${p.eventName} — Bill: ${guest.name}');
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.fontSize = 14;

    // Info
    sheet.getRangeByName('A2').setText('Category: ${guest.assignedCategory}');
    sheet.getRangeByName('A3').setText(
        'Tags: ${[if (guest.isVip) 'VIP', if (guest.isCloseRelative) 'Close Relative'].join(', ')}');

    // Headers (row 4)
    final headers = ['#', 'Service', 'Amount (₹)', 'Date & Time'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(4, i + 1);
      cell.setText(headers[i]);
      _applyHeaderStyle(cell);
    }

    // Data rows (starting at row 5)
    double total = 0;
    for (var i = 0; i < charges.length; i++) {
      final c = charges[i];
      final rowIdx = 5 + i;
      sheet.getRangeByIndex(rowIdx, 1).setNumber(i + 1);
      sheet.getRangeByIndex(rowIdx, 2).setText(typeMap[c.typeId] ?? 'Service');
      sheet.getRangeByIndex(rowIdx, 3).setNumber(c.amount);
      sheet.getRangeByIndex(rowIdx, 4).setText(c.loggedAt.toLocal().toString().substring(0, 16));
      total += c.amount;
    }

    // Total row
    final totalRowIdx = 5 + charges.length + 1;
    sheet.getRangeByIndex(totalRowIdx, 2).setText('TOTAL');
    sheet.getRangeByIndex(totalRowIdx, 2).cellStyle.bold = true;
    sheet.getRangeByIndex(totalRowIdx, 3).setNumber(total);
    sheet.getRangeByIndex(totalRowIdx, 3).cellStyle.bold = true;

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);
    sheet.autoFitColumn(4);
  }

  final bytes = Uint8List.fromList(wb.saveAsStream());
  wb.dispose();
  return bytes;
}

// ─── Per-Hotel Billing Summary ────────────────────────────────────────────────

Future<Uint8List> _generateHotelSummary(_ExportParams p) async {
  final wb = Workbook();
  final hotels = await p.db.hotelsDao.getHotelsForEvent(p.eventId);
  final guests = await p.db.guestsDao.getGuestsForEvent(p.eventId);
  final serviceTypes = await p.db.serviceDao.getServiceTypesForEvent(p.eventId);
  final typeMap = {for (final t in serviceTypes) t.id: t.name};

  bool firstSheet = true;
  for (final hotel in hotels) {
    Worksheet sheet;
    if (firstSheet) {
      sheet = wb.worksheets[0];
      firstSheet = false;
    } else {
      sheet = wb.worksheets.addWithName(hotel.name.length > 31
          ? hotel.name.substring(0, 31)
          : hotel.name);
    }
    sheet.name = hotel.name.length > 31 ? hotel.name.substring(0, 31) : hotel.name;

    final titleRange = sheet.getRangeByName('A1:E1');
    titleRange.merge();
    titleRange.setText('${p.eventName} — ${hotel.name} Billing Summary');
    titleRange.cellStyle.bold = true;

    // Headers (row 2)
    final headers = ['Guest', 'Room Category', 'Charges', 'Total (₹)', 'Status'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(2, i + 1);
      cell.setText(headers[i]);
      _applyHeaderStyle(cell);
    }

    // Guests who stayed at this hotel (via stay segments)
    double hotelTotal = 0;
    int dataRow = 3;

    for (final guest in guests) {
      final stays = await p.db.guestsDao.getStaySegmentsForGuest(guest.id);
      final stayedHere = stays.any((s) => s.hotelId == hotel.id);
      if (!stayedHere) continue;

      final charges = await p.db.serviceDao.getChargesForGuest(guest.id);
      final chargeCount = charges.length;
      final total = charges.fold<double>(0.0, (s, c) => s + c.amount);

      sheet.getRangeByIndex(dataRow, 1).setText(guest.name);
      sheet.getRangeByIndex(dataRow, 2).setText(guest.assignedCategory);
      sheet.getRangeByIndex(dataRow, 3).setNumber(chargeCount.toDouble());
      sheet.getRangeByIndex(dataRow, 4).setNumber(total);
      sheet.getRangeByIndex(dataRow, 5).setText(guest.status == 'checked_out' ? 'Checked Out' : 'Active');
      hotelTotal += total;
      dataRow++;
    }

    // Total
    final totalRowIdx = dataRow + 1;
    sheet.getRangeByIndex(totalRowIdx, 1).setText('HOTEL TOTAL');
    sheet.getRangeByIndex(totalRowIdx, 1).cellStyle.bold = true;
    sheet.getRangeByIndex(totalRowIdx, 4).setNumber(hotelTotal);
    sheet.getRangeByIndex(totalRowIdx, 4).cellStyle.bold = true;

    for (var i = 1; i <= 5; i++) { sheet.autoFitColumn(i); }
  }

  // suppress unused variable warning
  // ignore: unused_local_variable
  final _ = typeMap;

  final bytes = Uint8List.fromList(wb.saveAsStream());
  wb.dispose();
  return bytes;
}

// ─── Consolidated Billing ─────────────────────────────────────────────────────

Future<Uint8List> _generateConsolidated(_ExportParams p) async {
  final wb = Workbook();
  final sheet = wb.worksheets[0];
  sheet.name = 'Consolidated';

  final guests = await p.db.guestsDao.getGuestsForEvent(p.eventId);
  final serviceTypes = await p.db.serviceDao.getServiceTypesForEvent(p.eventId);
  final typeMap = {for (final t in serviceTypes) t.id: t.name};

  final titleRange = sheet.getRangeByName('A1:F1');
  titleRange.merge();
  titleRange.setText('${p.eventName} — Consolidated Billing Report');
  titleRange.cellStyle.bold = true;
  titleRange.cellStyle.fontSize = 14;

  // Headers (row 2)
  final headers = ['Guest', 'VIP', 'Category', 'Hotels Stayed', 'Total Charges', 'Total (₹)'];
  for (var i = 0; i < headers.length; i++) {
    final cell = sheet.getRangeByIndex(2, i + 1);
    cell.setText(headers[i]);
    _applyHeaderStyle(cell);
  }

  double grandTotal = 0;
  int dataRow = 3;

  for (final guest in guests) {
    final charges = await p.db.serviceDao.getChargesForGuest(guest.id);
    final stays = await p.db.guestsDao.getStaySegmentsForGuest(guest.id);
    final hotelCount = stays.map((s) => s.hotelId).toSet().length;
    final total = charges.fold<double>(0.0, (s, c) => s + c.amount);

    sheet.getRangeByIndex(dataRow, 1).setText(guest.name);
    sheet.getRangeByIndex(dataRow, 2).setText(guest.isVip ? 'VIP' : '');
    sheet.getRangeByIndex(dataRow, 3).setText(guest.assignedCategory);
    sheet.getRangeByIndex(dataRow, 4).setNumber(hotelCount.toDouble());
    sheet.getRangeByIndex(dataRow, 5).setNumber(charges.length.toDouble());
    sheet.getRangeByIndex(dataRow, 6).setNumber(total);
    grandTotal += total;
    dataRow++;
  }

  // Grand total
  final totalRowIdx = dataRow + 1;
  sheet.getRangeByIndex(totalRowIdx, 1).setText('GRAND TOTAL');
  sheet.getRangeByIndex(totalRowIdx, 1).cellStyle.bold = true;
  sheet.getRangeByIndex(totalRowIdx, 6).setNumber(grandTotal);
  sheet.getRangeByIndex(totalRowIdx, 6).cellStyle.bold = true;

  for (var i = 1; i <= 6; i++) { sheet.autoFitColumn(i); }

  // suppress unused variable warning
  // ignore: unused_local_variable
  final _ = typeMap;

  final bytes = Uint8List.fromList(wb.saveAsStream());
  wb.dispose();
  return bytes;
}

// ─── Guest Movement & Room History ────────────────────────────────────────────

Future<Uint8List> _generateMovement(_ExportParams p) async {
  final wb = Workbook();
  final sheet = wb.worksheets[0];
  sheet.name = 'Guest Movement';

  final guests = await p.db.guestsDao.getGuestsForEvent(p.eventId);
  final hotels = await p.db.hotelsDao.getHotelsForEvent(p.eventId);
  final hotelMap = {for (final h in hotels) h.id: h.name};
  final rooms = await p.db.hotelsDao.getRoomsForEvent(p.eventId);
  final roomMap = {for (final r in rooms) r.id: r.number};

  final titleRange = sheet.getRangeByName('A1:G1');
  titleRange.merge();
  titleRange.setText('${p.eventName} — Guest Movement & Room History');
  titleRange.cellStyle.bold = true;
  titleRange.cellStyle.fontSize = 14;

  // Headers (row 2)
  final headers = ['Guest', 'Hotel', 'Room', 'Room Category', 'Check-In', 'Check-Out', 'Duration'];
  for (var i = 0; i < headers.length; i++) {
    final cell = sheet.getRangeByIndex(2, i + 1);
    cell.setText(headers[i]);
    _applyHeaderStyle(cell);
  }

  int dataRow = 3;
  for (final guest in guests) {
    final stays = await p.db.guestsDao.getStaySegmentsForGuest(guest.id);
    for (final s in stays) {
      final duration = s.checkOutAt != null
          ? s.checkOutAt!.difference(s.checkInAt)
          : DateTime.now().difference(s.checkInAt);
      final durationStr =
          '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';

      sheet.getRangeByIndex(dataRow, 1).setText(guest.name);
      sheet.getRangeByIndex(dataRow, 2).setText(hotelMap[s.hotelId] ?? 'Hotel ${s.hotelId}');
      sheet.getRangeByIndex(dataRow, 3).setText(roomMap[s.roomId] ?? '${s.roomId}');
      sheet.getRangeByIndex(dataRow, 4).setText(guest.assignedCategory);
      sheet.getRangeByIndex(dataRow, 5).setText(s.checkInAt.toLocal().toString().substring(0, 16));
      sheet.getRangeByIndex(dataRow, 6).setText(s.checkOutAt?.toLocal().toString().substring(0, 16) ?? 'Active');
      sheet.getRangeByIndex(dataRow, 7).setText(durationStr);
      dataRow++;
    }
  }

  for (var i = 1; i <= 7; i++) { sheet.autoFitColumn(i); }

  final bytes = Uint8List.fromList(wb.saveAsStream());
  wb.dispose();
  return bytes;
}
