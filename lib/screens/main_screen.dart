import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/mission_provider.dart';
import '../core/constants.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch only the 'intent' property to optimize performance
    final intent = ref.watch(missionProvider.select((state) => state.intent));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Intent:',
              style: GoogleFonts.inter(color: AppConfig.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              intent ?? 'No active intent identified',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConfig.primaryBrand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
