import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glassmorphic_container.dart';
import '../widgets/shimmer_loading.dart';

class RoadmapScreen extends ConsumerStatefulWidget {
  const RoadmapScreen({super.key});

  @override
  ConsumerState<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends ConsumerState<RoadmapScreen> {
  final PageController _pageController = PageController();
  bool _isGeneratingStrategy = false;
  String? _generatedStrategy;
  final TextEditingController _skillsController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _generateStrategy(WidgetRef ref) {
    setState(() {
      _isGeneratingStrategy = true;
      _generatedStrategy = null;
    });

    final notifier = ref.read(onboardingProvider.notifier);

    // Determine the user identity
    final role = notifier.computedRole;
    final identity = notifier.identityDomain;

    // Shift the generative apparel
    final themeNotifier = ref.read(themeProvider.notifier);
    if (identity == 'Cybersecurity') {
      themeNotifier.shiftApparel(ApparelIdentity.cybersecurity);
    } else if (identity == 'Management') {
      themeNotifier.shiftApparel(ApparelIdentity.management);
    } else if (identity == 'Entrepreneurial') {
      themeNotifier.shiftApparel(ApparelIdentity.entrepreneurial);
    } else {
      themeNotifier.shiftApparel(ApparelIdentity.standard);
    }

    notifier.resetRegenerationFlag();

    // Simulate Groq LLM API Call for "Comprehensive Life Strategy" or "Venture Blueprint"
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isGeneratingStrategy = false;
          if (identity == 'Entrepreneurial') {
            _generatedStrategy =
                "Venture Blueprint: $role\n\nPhase 1: Skill Integration (Months 1-3)\n- Leverage current tech stack to build foundations\n- Define core value prop based on technical depth\n\nPhase 2: Market Validation (Months 4-6)\n- Target high-growth sectors compatible with $role mindset\n- Iterate based on early adoption feedback\n\nPhase 3: Scaling & Mastery (Months 7-12)\n- Advanced architectural patterns for $role excellence\n- Strategic monetization and leadership growth";
          } else {
            _generatedStrategy =
                "Specified Role Strategy: $role\n\n1. Transition Phase (0-6 Months)\n- Bridge current skills to $role requirements\n- Networking and brand building in target domain\n\n2. Career Consolidation (6-18 Months)\n- High-impact project delivery in target environment\n- Establishing domain authority and expert status\n\n3. Long-Term Trajectory (1-3 Years)\n- Senior leadership or specialized high-reward consultancy\n- Continuous skill evolution and industry mentoring";
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final theme = ref.watch(themeProvider.notifier).currentTheme;

    // If strategy is generated and no regeneration is required, show the result.
    if (_generatedStrategy != null && !state.isRegenerationRequired) {
      return _buildStrategyResult(theme, state.answers);
    }

    // If currently generating, show shimmer loader
    if (_isGeneratingStrategy) {
      return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ShimmerLoading(width: 80, height: 80, borderRadius: 40),
                const SizedBox(height: 24),
                Text(
                  'Synthesizing Life Strategy...',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.fontFamily,
                  ),
                ),
                const SizedBox(height: 16),
                const ShimmerCardList(count: 3, itemHeight: 120),
              ],
            ),
          ),
        ),
      );
    }

    if (!state.hasStarted) {
      return _buildIntroScreen(theme, notifier);
    }

    final currentQuestion = notifier.questions[state.currentIndex];

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background ambient glow
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.15),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: (state.currentIndex + 1) / notifier.questions.length,
                    backgroundColor: theme.cardColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 32),
                  // Header text with Hero animation
                  Row(
                    children: [
                      Hero(
                        tag: 'agent_header',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'Question ${state.currentIndex + 1}',
                            style: TextStyle(
                              color: theme.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                              fontFamily: theme.fontFamily,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' of ${notifier.questions.length}',
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: theme.fontFamily,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Wrap the question content in an AnimatedSwitcher for "high-end animations"
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      child: _buildQuestionContent(
                        key: ValueKey<int>(state.currentIndex),
                        currentQuestion: currentQuestion,
                        state: state,
                        notifier: notifier,
                        theme: theme,
                      ),
                    ),
                  ),

                  // Navigation Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.currentIndex > 0)
                        TextButton.icon(
                          onPressed: () {
                            notifier.goBack();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white70,
                          ),
                          label: const Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      if (state.answers.containsKey(state.currentIndex))
                        ElevatedButton(
                          onPressed: () {
                            if (notifier.isComplete &&
                                state.currentIndex ==
                                    notifier.questions.length - 1) {
                              _generateStrategy(ref);
                            } else {
                              // By calling answerCurrentAndNext with the same answer, it just moves forward
                              notifier.answerCurrentAndNext(
                                state.answers[state.currentIndex]!,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: theme.primaryColor.withOpacity(0.5),
                          ),
                          child: Text(
                            (notifier.isComplete &&
                                    state.currentIndex ==
                                        notifier.questions.length - 1)
                                ? 'Generate Strategy'
                                : 'Next',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent({
    required Key key,
    required OnboardingQuestion currentQuestion,
    required OnboardingState state,
    required OnboardingNotifier notifier,
    required ApparelTheme theme,
  }) {
    return SingleChildScrollView(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentQuestion.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: theme.fontFamily,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentQuestion.description,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 32),
          if (currentQuestion.options.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GlassmorphicContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _skillsController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) => notifier.setAnswer(val),
                  onSubmitted: (val) => notifier.answerCurrentAndNext(val),
                  decoration: const InputDecoration(
                    hintText: 'e.g., Python, Docker, Figma, SEO...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          else
            // Options List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentQuestion.options.length,
              itemBuilder: (context, index) {
                final option = currentQuestion.options[index];
                final isSelected = state.answers[state.currentIndex] == option;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      notifier.answerCurrentAndNext(option);
                      if (notifier.isComplete &&
                          state.currentIndex == notifier.questions.length - 1) {
                        _generateStrategy(ref);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      transform: Matrix4.translationValues(
                        isSelected ? 5.0 : 0.0,
                        0,
                        0,
                      ),
                      child: GlassmorphicContainer(
                        padding: const EdgeInsets.all(20),
                        borderColor: isSelected
                            ? theme.primaryColor
                            : Colors.white12,
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : Colors.white38,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.black,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildIntroScreen(ApparelTheme theme, OnboardingNotifier notifier) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'agent_header',
                child: Icon(
                  Icons.psychology,
                  size: 100,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Ready to Architect Your Future?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: theme.fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'I will ask you 10 questions to understand your identity and generate a personalized Venture Blueprint or Career Strategy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: theme.fontFamily,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog before starting
                    _showProceedConfirmation(context, theme, notifier);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "I'm Ready",
                    style: TextStyle(
                      color: theme.backgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProceedConfirmation(
    BuildContext context,
    ApparelTheme theme,
    OnboardingNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text(
          'Confirm to Proceed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: theme.fontFamily,
          ),
        ),
        content: Text(
          'Are you ready to proceed with the questionnaire? This will help us generate a personalized strategy for you.',
          style: TextStyle(color: Colors.white70, fontFamily: theme.fontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              notifier.startOnboarding();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
            ),
            child: Text(
              'Proceed',
              style: TextStyle(
                color: theme.backgroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyResult(ApparelTheme theme, Map<int, String> answers) {
    final notifier = ref.read(onboardingProvider.notifier);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          notifier.computedRole,
          style: TextStyle(
            color: theme.primaryColor,
            fontFamily: theme.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.secondaryColor),
            onPressed: () {
              // Allows user to edit answers from question 1
              final notifier = ref.read(onboardingProvider.notifier);
              // We could just go back to question 0
              notifier
                  .goBack(); // Actually need a dedicated method to jump to Q0, or just:
              setState(() {
                _generatedStrategy = null;
              });
            },
            tooltip: 'Retake Interview',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.accentColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: theme.accentColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Strategy Generated from your ${answers.length} profile dimensions.',
                      style: TextStyle(
                        color: theme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _generatedStrategy ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            GlassmorphicContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Summary',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: theme.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Mindset', answers[2] ?? '', theme),
                  _buildSummaryRow('Skills', answers[0] ?? '', theme),
                  _buildSummaryRow('Risk Tolerance', answers[6] ?? '', theme),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generatedStrategy = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.primaryColor),
                  ),
                ),
                child: Text(
                  'Edit Answers & Regenerate',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, ApparelTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
