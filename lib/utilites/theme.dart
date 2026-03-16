import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Brand colours ─────────────────────────────────────────────────────────
class PeachColors {
  // Primary pink — Peach Cars brand
  static const Color primary = Color(0xFFE91E8C);
  static const Color primaryLight = Color(0xFFF06292);
  static const Color primaryDark = Color(0xFFC2185B);

  // Accent / teal used on "Financing Available" badge
  static const Color accent = Color(0xFF26A69A);

  // Neutrals
  static const Color lightBg = Color(0xFFF9F9F9);
  static const Color darkBg = Color(0xFF121212);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2A2A2A);

  static const Color lightText = Color(0xFF1A1A1A);
  static const Color darkText = Color(0xFFEEEEEE);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color divider = Color(0xFFE0E0E0);

  // Status
  static const Color success = Color(0xFF43A047);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
}

class PeachTheme {
  // ── Light theme ───────────────────────────────────────────────────────
  static ThemeData get light {
    const primary = PeachColors.primary;
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: PeachColors.accent,
        onSecondary: Colors.white,
        surface: PeachColors.lightSurface,
        onSurface: PeachColors.lightText,
        background: PeachColors.lightBg,
        onBackground: PeachColors.lightText,
        error: PeachColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: PeachColors.lightBg,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: PeachColors.lightSurface,
        foregroundColor: PeachColors.lightText,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: PeachColors.lightText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: PeachColors.lightText),
      ),
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: PeachColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      // Card
      cardTheme: CardThemeData(
        color: PeachColors.lightSurface,
        elevation: 2,
        shadowColor: Colors.black12,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PeachColors.lightGrey,
        hintStyle: GoogleFonts.poppins(color: PeachColors.grey, fontSize: 14),
        labelStyle: GoogleFonts.poppins(color: PeachColors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PeachColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PeachColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PeachColors.error, width: 2),
        ),
      ),
      // Bottom nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PeachColors.lightSurface,
        selectedItemColor: primary,
        unselectedItemColor: PeachColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
      // Text
      textTheme: _buildTextTheme(PeachColors.lightText),
      // Divider
      dividerTheme: const DividerThemeData(
        color: PeachColors.divider,
        thickness: 1,
      ),
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: PeachColors.lightGrey,
        selectedColor: PeachColors.primary.withOpacity(0.15),
        labelStyle: GoogleFonts.poppins(fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: PeachColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.poppins(
          color: PeachColors.lightText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: PeachColors.lightText,
          fontSize: 14,
        ),
      ),
    );
  }

  // ── Dark theme ────────────────────────────────────────────────────────
  static ThemeData get dark {
    const primary = PeachColors.primary;
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.white,
        secondary: PeachColors.accent,
        onSecondary: Colors.white,
        surface: PeachColors.darkSurface,
        onSurface: PeachColors.darkText,
        background: PeachColors.darkBg,
        onBackground: PeachColors.darkText,
        error: PeachColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: PeachColors.darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: PeachColors.darkSurface,
        foregroundColor: PeachColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black54,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: PeachColors.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: PeachColors.darkText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: PeachColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: PeachColors.darkCard,
        elevation: 2,
        shadowColor: Colors.black38,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PeachColors.darkCard,
        hintStyle: GoogleFonts.poppins(color: PeachColors.grey, fontSize: 14),
        labelStyle: GoogleFonts.poppins(color: PeachColors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PeachColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PeachColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PeachColors.error, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PeachColors.darkSurface,
        selectedItemColor: primary,
        unselectedItemColor: PeachColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      ),
      textTheme: _buildTextTheme(PeachColors.darkText),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.12),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PeachColors.darkCard,
        selectedColor: PeachColors.primary.withOpacity(0.25),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: PeachColors.darkText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: PeachColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.poppins(
          color: PeachColors.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: PeachColors.darkText,
          fontSize: 14,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color base) {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
          color: base, fontSize: 28, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.poppins(
          color: base, fontSize: 24, fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.poppins(
          color: base, fontSize: 20, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.poppins(
          color: base, fontSize: 22, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.poppins(
          color: base, fontSize: 18, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppins(
          color: base, fontSize: 16, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(
          color: base, fontSize: 17, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(
          color: base, fontSize: 15, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.poppins(
          color: base, fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.poppins(
          color: base, fontSize: 15, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.poppins(
          color: base, fontSize: 13, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.poppins(
          color: base.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.poppins(
          color: base, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.poppins(
          color: base, fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.poppins(
          color: base.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w400),
    );
  }
}
