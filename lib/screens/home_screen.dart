import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/skill_forge_state_provider.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/side_menu_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(onboardingProvider.notifier).identityDomain;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideMenuDrawer(),
      backgroundColor: ref
          .watch(themeProvider.notifier)
          .currentTheme
          .backgroundColor,
      body: SafeArea(
        child: _DashboardView(identity: identity, scaffoldKey: _scaffoldKey),
      ),
    );
  }
}

class _DashboardView extends ConsumerWidget {
  final String identity;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _DashboardView({required this.identity, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    // We watch forgeProvider just to trigger rebuilds if it updates
    ref.watch(forgeProvider);

    return Stack(
      children: [
        // AI Command Center ambient background
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor.withOpacity(0.05),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.1),
                  blurRadius: 150,
                  spreadRadius: 80,
                ),
              ],
            ),
          ),
        ),

        SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    icon: Icon(
                      Icons.menu_rounded,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                    tooltip: 'Open Menu',
                    style: IconButton.styleFrom(
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'AI Command Center',
                        style: TextStyle(
                          color: theme.secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontFamily: theme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Agent Alpha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: theme.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Hero(
                    tag: 'profile_avatar',
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.psychology,
                        color: theme.primaryColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Identity Chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.accentColor),
                ),
                child: Text(
                  'Active Identity: $identity',
                  style: TextStyle(
                    color: theme.accentColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: theme.fontFamily,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Phase 3 Widgets

              // 1. Cognitive Velocity Gauge
              const CognitiveVelocityGauge(),
              const SizedBox(height: 24),

              // 2. Interest-Based Quantities
              InterestBasedWidget(identity: identity),
              const SizedBox(height: 24),

              // 3. Active Portal
              const ActivePortalCard(),
              const SizedBox(height: 24),

              // 4. Market Pulse Feed
              MarketPulseFeed(identity: identity),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
