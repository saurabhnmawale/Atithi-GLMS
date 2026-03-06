import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:intl/intl.dart';
import '../../../data/database/app_database.dart';

// PRD v2.2: single consolidated export — one .xlsx file, one row per guest.
// All previous report-type variants removed.

class ExportService {
  ExportService({required this.db, required this.event});

  final AppDatabase db;
  final Event event;

  /// Generates the consolidated guest report and triggers the native share sheet.
  Future<void> exportConsolidated() async {
    final bytes = await _generateConsolidated();

    final dir = await getTemporaryDirectory();
    final filename =
        '${event.name.replaceAll(RegExp(r'[^\w\s]'), '').trim().replaceAll(' ', '_')}_report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            file.path,
            mimeType:
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          )
        ],
        subject: '${event.name} — Guest Report',
      ),
    );
  }

  Future<Uint8List> _generateConsolidated() async {
    final guests = await db.guestsDao.getGuestsForEvent(event.id);
    final hotels = await db.hotelsDao.getHotelsForEvent(event.id);
    final rooms = await db.hotelsDao.getRoomsForEvent(event.id);
    final serviceTypes = await db.serviceDao.getServiceTypesForEvent(event.id);

    final hotelMap = {for (final h in hotels) h.id: h.name};
    final roomMap = {for (final r in rooms) r.id: r.number};
    final typeMap = {for (final t in serviceTypes) t.id: t.name};

    // Build column headers — service type columns are dynamic
    final serviceTypeIds = serviceTypes.map((t) => t.id).toList();
    final baseHeaders = [
      'Guest Name',
      'VIP',
      'Close Relative',
      'Special Requests',
      'Hotel(s)',
      'Room(s)',
      'Check-in Date/Time',
      'Checkout Date',
      'Stay Segments',
    ];
    final serviceHeaders = serviceTypes.map((t) => t.name).toList();
    const extraHeaders = ['Total Bill (₹)', 'Status'];
    final allHeaders = [...baseHeaders, ...serviceHeaders, ...extraHeaders];

    final wb = Workbook();
    final sheet = wb.worksheets[0];
    sheet.name = 'Guest Report';

    // Title row
    final titleRange = sheet.getRangeByIndex(1, 1, 1, allHeaders.length);
    titleRange.merge();
    titleRange.setText('${event.name} — Consolidated Guest Report');
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.fontSize = 14;
    titleRange.cellStyle.backColor = '#F0EBE3';
    titleRange.cellStyle.fontColor = '#2C1A0E';

    // Sub-header: generated date
    final subRange = sheet.getRangeByIndex(2, 1, 2, allHeaders.length);
    subRange.merge();
    subRange.setText(
        'Generated: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}');
    subRange.cellStyle.fontSize = 10;
    subRange.cellStyle.fontColor = '#7A6652';

    // Gold accent row
    final accentRange = sheet.getRangeByIndex(3, 1, 3, allHeaders.length);
    accentRange.merge();
    accentRange.cellStyle.backColor = '#C9A84C';

    // Column headers (row 4)
    for (var i = 0; i < allHeaders.length; i++) {
      final cell = sheet.getRangeByIndex(4, i + 1);
      cell.setText(allHeaders[i]);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#2C1A0E';
      cell.cellStyle.fontColor = '#FFFFFF';
    }

    final dateFmt = DateFormat('dd MMM yy, HH:mm');
    final checkoutFmt = DateFormat('dd MMM yyyy');

    int dataRow = 5;

    for (final guest in guests) {
      final stays = await db.guestsDao.getStaySegmentsForGuest(guest.id);
      final charges = await db.serviceDao.getChargesForGuest(guest.id);

      // Hotels stayed (unique, in order)
      final hotelNames = stays
          .map((s) => hotelMap[s.hotelId] ?? 'Hotel ${s.hotelId}')
          .toSet()
          .join(', ');

      // Rooms (unique, in order)
      final roomNumbers = stays
          .map((s) => roomMap[s.roomId] ?? '${s.roomId}')
          .toSet()
          .join(', ');

      // First check-in
      final firstCheckIn = stays.isNotEmpty
          ? dateFmt.format(stays.last.checkInAt) // stays ordered desc
          : '';

      // Effective checkout date: guest override or event end_date
      final checkoutDate =
          guest.checkoutDate ?? event.endDate;
      final checkoutStr = checkoutFmt.format(checkoutDate);

      // Stay segments summary (each segment on a new line within cell)
      final segmentLines = stays.map((s) {
        final hotel = hotelMap[s.hotelId] ?? 'Hotel ${s.hotelId}';
        final room = roomMap[s.roomId] ?? '${s.roomId}';
        final inStr = dateFmt.format(s.checkInAt);
        final outStr = s.checkOutAt != null
            ? dateFmt.format(s.checkOutAt!)
            : 'Active';
        return '$hotel / Rm $room: $inStr → $outStr';
      }).join('\n');

      // Service charge amounts keyed by type
      final chargeByType = <int, double>{};
      for (final c in charges) {
        chargeByType[c.typeId] = (chargeByType[c.typeId] ?? 0) + c.amount;
      }
      final totalBill = charges.fold<double>(0, (s, c) => s + c.amount);

      // Write base columns
      int col = 1;
      sheet.getRangeByIndex(dataRow, col++).setText(guest.name);
      sheet.getRangeByIndex(dataRow, col++).setText(guest.isVip ? 'Yes' : 'No');
      sheet.getRangeByIndex(dataRow, col++).setText(guest.isCloseRelative ? 'Yes' : 'No');
      sheet.getRangeByIndex(dataRow, col++).setText(guest.specialRequests ?? '');
      sheet.getRangeByIndex(dataRow, col++).setText(hotelNames);
      sheet.getRangeByIndex(dataRow, col++).setText(roomNumbers);
      sheet.getRangeByIndex(dataRow, col++).setText(firstCheckIn);
      sheet.getRangeByIndex(dataRow, col++).setText(checkoutStr);
      sheet.getRangeByIndex(dataRow, col++).setText(segmentLines);

      // Service type columns
      for (final typeId in serviceTypeIds) {
        final amt = chargeByType[typeId];
        if (amt != null) {
          sheet.getRangeByIndex(dataRow, col).setNumber(amt);
        }
        col++;
      }

      // Total bill
      sheet.getRangeByIndex(dataRow, col).setNumber(totalBill);
      sheet.getRangeByIndex(dataRow, col).cellStyle.bold = true;
      col++;

      // Status
      sheet.getRangeByIndex(dataRow, col++).setText(_statusLabel(guest.status));

      // VIP row highlight
      if (guest.isVip) {
        for (var c = 1; c <= allHeaders.length; c++) {
          sheet.getRangeByIndex(dataRow, c).cellStyle.backColor = '#FDF3E7';
        }
      }

      dataRow++;
    }

    // Summary row
    dataRow++; // blank gap
    final summaryRow = dataRow;
    sheet.getRangeByIndex(summaryRow, 1).setText('TOTAL GUESTS: ${guests.length}');
    sheet.getRangeByIndex(summaryRow, 1).cellStyle.bold = true;

    // Grand total in the Total Bill column
    final totalBillCol = baseHeaders.length + serviceTypeIds.length + 1;
    double grandTotal = 0;
    for (final guest in guests) {
      final charges = await db.serviceDao.getChargesForGuest(guest.id);
      grandTotal += charges.fold<double>(0, (s, c) => s + c.amount);
    }
    sheet.getRangeByIndex(summaryRow, totalBillCol).setNumber(grandTotal);
    sheet.getRangeByIndex(summaryRow, totalBillCol).cellStyle.bold = true;

    // Auto-fit columns
    for (var i = 1; i <= allHeaders.length; i++) {
      sheet.autoFitColumn(i);
    }

    final bytes = Uint8List.fromList(wb.saveAsStream());
    wb.dispose();
    return bytes;
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'checked_in':
        return 'Checked In';
      case 'checked_out':
        return 'Checked Out';
      default:
        return 'Not Checked In';
    }
  }
}
