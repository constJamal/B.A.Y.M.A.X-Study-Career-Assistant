import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/skill_forge_state_provider.dart';
import '../widgets/glassmorphic_container.dart';
import '../widgets/shimmer_loading.dart';

class SkillForgeScreen extends ConsumerStatefulWidget {
  const SkillForgeScreen({super.key});

  @override
  ConsumerState<SkillForgeScreen> createState() => _SkillForgeScreenState();
}

class _SkillForgeScreenState extends ConsumerState<SkillForgeScreen> {
  late TextEditingController _topicController;
  late TextEditingController _durationController;
  late String _masteryLevel;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(forgeProvider);
    _topicController = TextEditingController(text: initialState.topic);
    _durationController = TextEditingController(text: initialState.duration);
    _masteryLevel = initialState.mastery.isEmpty
        ? 'Beginner'
        : initialState.mastery;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _forgeCurriculum() {
    if (_topicController.text.isEmpty || _durationController.text.isEmpty)
      return;

    final notifier = ref.read(forgeProvider.notifier);
    notifier.setInputs(
      _topicController.text,
      _masteryLevel,
      _durationController.text,
    );
    notifier.forgeCurriculum();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    final forgeState = ref.watch(forgeProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Data-Grounded Skill Forge',
          style: TextStyle(
            color: theme.primaryColor,
            fontFamily: theme.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are we building today?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: theme.fontFamily,
              ),
            ),
            const SizedBox(height: 24),
            GlassmorphicContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('Topic / Skill', theme),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _topicController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'e.g. Flutter Web, Rust, DevOps',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInputLabel('Current Mastery Level', theme),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _masteryLevel,
                    dropdownColor: theme.cardColor,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ['Beginner', 'Intermediate', 'Advanced', 'Pro']
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _masteryLevel = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildInputLabel('Target Duration', theme),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _durationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'e.g. 2 weeks, 30 days',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: forgeState.isForging ? null : _forgeCurriculum,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: forgeState.isForging
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Forge Curriculum',
                              style: TextStyle(
                                color: theme.backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (forgeState.isForging)
              const ShimmerCardList(count: 3, itemHeight: 120)
            else if (forgeState.curriculum.isNotEmpty)
              _buildTechnicalSpecUI(forgeState, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label, ApparelTheme theme) {
    return Text(
      label,
      style: TextStyle(
        color: theme.secondaryColor,
        fontWeight: FontWeight.w600,
        fontFamily: theme.fontFamily,
      ),
    );
  }

  Widget _buildTechnicalSpecUI(ForgeState forgeState, ApparelTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Technical Spec Sheet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: theme.fontFamily,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.accentColor),
              ),
              child: const Text(
                '2026 Verified',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: forgeState.curriculum.length,
          itemBuilder: (context, index) {
            final item = forgeState.curriculum[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GlassmorphicContainer(
                padding: const EdgeInsets.all(16),
                borderColor: theme.secondaryColor.withValues(alpha: 0.3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForType(item.type),
                        color: theme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: theme.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.link,
                                color: theme.accentColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.url,
                                  style: TextStyle(
                                    color: theme.accentColor,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'doc':
        return Icons.description;
      case 'video':
        return Icons.play_circle_filled;
      case 'repo':
        return Icons.code;
      default:
        return Icons.article;
    }
  }
}
