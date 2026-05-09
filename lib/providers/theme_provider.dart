import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ApparelIdentity { cybersecurity, management, entrepreneurial, standard }

class ApparelTheme {
  final ThemeData themeData;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color accentColor;
  final String fontFamily;

  ApparelTheme({
    required this.themeData,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.accentColor,
    required this.fontFamily,
  });
}

class ThemeNotifier extends StateNotifier<ApparelIdentity> {
  ThemeNotifier() : super(ApparelIdentity.standard);

  void shiftApparel(ApparelIdentity newIdentity) {
    state = newIdentity;
  }

  ApparelTheme get currentTheme {
    switch (state) {
      case ApparelIdentity.cybersecurity:
        return _cybersecurityTheme();
      case ApparelIdentity.management:
        return _managementTheme();
      case ApparelIdentity.entrepreneurial:
        return _entrepreneurialTheme();
      case ApparelIdentity.standard:
        return _standardTheme();
    }
  }

  ApparelTheme _cybersecurityTheme() {
    return ApparelTheme(
      primaryColor: const Color(0xFF00FF41), // Matrix Green
      secondaryColor: const Color(0xFF008F11),
      backgroundColor: const Color(0xFF0D0D0D),
      cardColor: const Color(0xFF1A1A1A),
      accentColor: const Color(0xFF003B00),
      fontFamily: 'FiraCode', // or Roboto Mono
      themeData: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFF00FF41),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF41),
          secondary: Color(0xFF008F11),
          surface: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  ApparelTheme _managementTheme() {
    return ApparelTheme(
      primaryColor: const Color(0xFF0A2540), // Corporate Blue
      secondaryColor: const Color(0xFF635BFF),
      backgroundColor: const Color(0xFFF6F9FC), // Clean white/gray
      cardColor: Colors.white,
      accentColor: const Color(0xFF00D4FF),
      fontFamily: 'Inter',
      themeData: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF6F9FC),
        primaryColor: const Color(0xFF0A2540),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0A2540),
          secondary: Color(0xFF635BFF),
          surface: Colors.white,
        ),
      ),
    );
  }

  ApparelTheme _entrepreneurialTheme() {
    return ApparelTheme(
      primaryColor: const Color(0xFFFFD700), // Corporate Gold
      secondaryColor: const Color(0xFFE5C100), // Darker Gold
      backgroundColor: const Color(0xFF0A0A0A), // Deep Black
      cardColor: const Color(0xFF141414), // Slightly lighter black for cards
      accentColor: const Color(0xFFFFF099), // Light gold highlight
      fontFamily: 'Outfit',
      themeData: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFFFD700),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFE5C100),
          surface: Color(0xFF141414),
        ),
      ),
    );
  }

  ApparelTheme _standardTheme() {
    return ApparelTheme(
      primaryColor: const Color(0xFF6200EE),
      secondaryColor: const Color(0xFF03DAC6),
      backgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      accentColor: const Color(0xFFBB86FC),
      fontFamily: 'Roboto',
      themeData: ThemeData.dark(),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ApparelIdentity>((
  ref,
) {
  return ThemeNotifier();
});
