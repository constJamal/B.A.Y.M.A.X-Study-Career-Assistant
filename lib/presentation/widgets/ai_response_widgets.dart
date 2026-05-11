import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../domain/entities/entities.dart';

/// Widget for displaying text that streams in word-by-word
class StreamingTextDisplay extends StatefulWidget {
  final Stream<String> textStream;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;

  const StreamingTextDisplay({
    super.key,
    required this.textStream,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  State<StreamingTextDisplay> createState() => _StreamingTextDisplayState();
}

class _StreamingTextDisplayState extends State<StreamingTextDisplay> {
  final StringBuffer _buffer = StringBuffer();
  late StreamSubscription<String> _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamingTextDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textStream != widget.textStream) {
      _subscription.cancel();
      _buffer.clear();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.textStream.listen(
      (chunk) {
        setState(() {
          _buffer.write(chunk);
        });
      },
      onError: (error) {
        setState(() {
          _buffer.write('\nError: $error');
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _buffer.toString(),
      style: widget.style ?? GoogleFonts.inter(fontSize: 14),
      maxLines: widget.maxLines,
      overflow: widget.maxLines != null ? widget.overflow : null,
    );
  }
}

/// Widget for displaying skill roadmap with critic feedback
class SkillRoadmapDisplay extends StatelessWidget {
  final SkillRoadmap roadmap;

  const SkillRoadmapDisplay({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Critic Feedback Section
          _CriticFeedbackCard(feedback: roadmap.criticFeedback),
          const SizedBox(height: 20),

          // Skills Timeline
          Text(
            'Learning Path',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConfig.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SkillTimelineWidget(
            skills: roadmap.skills,
            dependencies: roadmap.skillDependencies,
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying critic feedback with validation status
class _CriticFeedbackCard extends StatelessWidget {
  final String feedback;

  const _CriticFeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.successGreen.withValues(alpha: 0.1),
        border: Border.all(
          color: AppConfig.successGreen.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppConfig.successGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Validated Roadmap',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConfig.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feedback,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppConfig.textSecondary,
                    height: 1.5,
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

/// Widget for displaying skills in a timeline format
class _SkillTimelineWidget extends StatelessWidget {
  final List<Skill> skills;
  final Map<String, List<String>> dependencies;

  const _SkillTimelineWidget({
    required this.skills,
    required this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        final isLast = index == skills.length - 1;

        return _SkillTimelineItem(
          skill: skill,
          index: index,
          isLast: isLast,
          dependencies: dependencies[skill.skillName] ?? [],
        );
      },
    );
  }
}

/// Individual skill timeline item
class _SkillTimelineItem extends StatelessWidget {
  final Skill skill;
  final int index;
  final bool isLast;
  final List<String> dependencies;

  const _SkillTimelineItem({
    required this.skill,
    required this.index,
    required this.isLast,
    required this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline marker
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppConfig.accentTeal,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (!isLast)
              SizedBox(
                height: 80,
                child: Center(
                  child: Container(width: 2, color: AppConfig.borderLight),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Skill card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppConfig.borderLight),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.skillName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConfig.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  skill.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppConfig.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Estimated Time: ${skill.timeEstimate}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppConfig.warmOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
