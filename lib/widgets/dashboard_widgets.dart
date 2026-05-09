import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/skill_forge_state_provider.dart';
import 'glassmorphic_container.dart';

class CognitiveVelocityGauge extends ConsumerWidget {
  const CognitiveVelocityGauge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    final forgeState = ref.watch(forgeProvider);
    final progress = forgeState.progress;

    return GlassmorphicContainer(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cognitive Velocity',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  forgeState.topic.isEmpty 
                      ? 'No active Forge sequence'
                      : 'On track to master ${forgeState.topic} in ${forgeState.duration}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: theme.primaryColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: theme.fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MarketPulseFeed extends ConsumerWidget {
  final String identity;
  const MarketPulseFeed({super.key, required this.identity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    
    final List<String> pulses = identity == 'Entrepreneurial'
        ? ['Y-Combinator S26 Applications Open', 'AI SaaS valuations up 15%', 'New VC fund targeting AI infra']
        : identity == 'Cybersecurity'
            ? ['Zero-day discovered in popular NPM package', 'Demand for Cloud Security Engineers +20%']
            : ['Senior Flutter Devs in high demand', 'Remote work trends stabilizing in Q2'];

    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: theme.secondaryColor),
              const SizedBox(width: 8),
              Text(
                'Market Pulse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: theme.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...pulses.map((pulse) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pulse,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class ActivePortalCard extends ConsumerWidget {
  const ActivePortalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    final forgeState = ref.watch(forgeProvider);

    // Find the next active documentation URL from the Forge curriculum
    final activeDocs = forgeState.curriculum.where((item) => item.type == 'doc').toList();
    final docTitle = activeDocs.isNotEmpty ? activeDocs.first.title : 'System Architecture Guide';
    final docUrl = activeDocs.isNotEmpty ? activeDocs.first.url : 'https://docs.flutter.dev';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'active_portal_icon',
            child: Icon(Icons.menu_book, color: theme.primaryColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Portal',
                  style: TextStyle(
                    color: theme.secondaryColor, 
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  docTitle,
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: theme.fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  docUrl,
                  style: TextStyle(
                    color: theme.primaryColor.withOpacity(0.7),
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: theme.primaryColor, size: 20),
        ],
      ),
    );
  }
}

class InterestBasedWidget extends ConsumerWidget {
  final String identity;
  
  const InterestBasedWidget({super.key, required this.identity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    final isEntrepreneur = identity == 'Entrepreneurial';

    return GlassmorphicContainer(
      borderColor: theme.accentColor.withOpacity(0.3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEntrepreneur ? Icons.rocket_launch : Icons.military_tech,
              color: theme.accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEntrepreneur ? 'Startup Milestone' : 'Skill Mastery',
                  style: TextStyle(
                    color: theme.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEntrepreneur 
                      ? 'Launch MVP to initial 100 beta testers.' 
                      : 'Achieve Senior Level proficiency in System Design.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
