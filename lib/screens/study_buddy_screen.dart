import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../widgets/baymax_app_bar.dart';

class StudyBuddyScreen extends StatelessWidget {
  const StudyBuddyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const BaymaxAppBar(title: 'Study Buddy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Study Buddy',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI-powered companion for personalized learning. Use AI Skill Forging to develop expertise in any field.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppConfig.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConfig.accentTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppConfig.accentTeal.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    size: 48,
                    color: AppConfig.accentTeal,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get Started with AI Skill Forging',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.accentTeal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Navigate to the Forge tab to begin building your skills with AI assistance. Track your progress on the Roadmap.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppConfig.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
