import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Core palette — mapped to PRD v2.2 design tokens
  static const Color primary = AppColors.primaryGold;
  static const Color surface = AppColors.backgroundIvory;
  static const Color cardBg = AppColors.surfaceLinen;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color success = AppColors.successSage;
  static const Color warning = AppColors.accentRose; // undo countdown, alerts
  static const Color error = Color(0xFFB85C55);       // form validation errors (deeper rose)
  static const Color vipGold = AppColors.accentRose;        // VIP tag pill
  static const Color relativeBlue = AppColors.neutralStone;  // Close Relative tag pill
  static const Color neutralStone = AppColors.neutralStone;  // dividers, inactive

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGold,
        brightness: Brightness.light,
        primary: AppColors.primaryGold,
        surface: AppColors.backgroundIvory,
      ),
      scaffoldBackgroundColor: AppColors.backgroundIvory,
    );

    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLinen,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLinen,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shadowColor: Colors.black.withValues(alpha: 0.08),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          side: const BorderSide(color: AppColors.primaryGold),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.neutralStone),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.neutralStone),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.neutralStone),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        space: 1,
        thickness: 1,
        color: AppColors.neutralStone,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLinen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}

// ─── Card decoration helper (soft shadow, linen bg) ───────────────────────────

BoxDecoration cardDecoration({double radius = 12}) => BoxDecoration(
      color: AppColors.surfaceLinen,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

// ─── Gold accent divider ───────────────────────────────────────────────────────

class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.primaryGold,
    );
  }
}

// ─── Status helpers ───────────────────────────────────────────────────────────

class RoomStatusHelper {
  static Color color(String status) {
    switch (status) {
      case 'occupied':
        return AppColors.accentRose;
      case 'maintenance':
        return AppColors.neutralStone;
      default:
        return AppColors.successSage;
    }
  }

  static IconData icon(String status) {
    switch (status) {
      case 'occupied':
        return Icons.bed;
      case 'maintenance':
        return Icons.construction;
      default:
        return Icons.check_circle_outline;
    }
  }

  static String label(String status) {
    switch (status) {
      case 'occupied':
        return 'Occupied';
      case 'maintenance':
        return 'Maintenance';
      default:
        return 'Available';
    }
  }
}

class GuestStatusHelper {
  static Color color(String status) {
    switch (status) {
      case 'checked_in':
        return AppColors.successSage;
      case 'checked_out':
        return AppColors.neutralStone;
      default:
        return AppColors.primaryGold;
    }
  }

  static IconData icon(String status) {
    switch (status) {
      case 'checked_in':
        return Icons.hotel;
      case 'checked_out':
        return Icons.logout;
      default:
        return Icons.person_outline;
    }
  }

  static String label(String status) {
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
