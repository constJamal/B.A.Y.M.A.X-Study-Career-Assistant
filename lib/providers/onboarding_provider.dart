import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constants.dart';

// --- MODELS ---

class OnboardingQuestion {
  final int id;
  final String title;
  final String description;
  final List<String> options;

  const OnboardingQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
  });
}

class OnboardingState {
  final int currentIndex;
  final Map<int, String> answers;
  final bool isRegenerationRequired;
  final bool hasStarted;
  final String? aiRole;
  final String? aiDomain;
  final bool isGeneratingPersonality;

  const OnboardingState({
    this.currentIndex = 0,
    this.answers = const {},
    this.isRegenerationRequired = false,
    this.hasStarted = false,
    this.aiRole,
    this.aiDomain,
    this.isGeneratingPersonality = false,
  });

  // Manual copyWith to replace Freezed functionality
  OnboardingState copyWith({
    int? currentIndex,
    Map<int, String>? answers,
    bool? isRegenerationRequired,
    bool? hasStarted,
    String? aiRole,
    String? aiDomain,
    bool? isGeneratingPersonality,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isRegenerationRequired:
          isRegenerationRequired ?? this.isRegenerationRequired,
      hasStarted: hasStarted ?? this.hasStarted,
      aiRole: aiRole ?? this.aiRole,
      aiDomain: aiDomain ?? this.aiDomain,
      isGeneratingPersonality:
          isGeneratingPersonality ?? this.isGeneratingPersonality,
    );
  }

  // --- LOGIC GETTERS ---

  String get computedRole {
    final skills = answers[0]?.toLowerCase() ?? '';
    final mindsetAnswer = answers[3] ?? '';

    if (skills.isEmpty) return 'Strategic Professional';

    if (skills.contains('flutter') || skills.contains('dart')) {
      if (mindsetAnswer.contains('Startup')) return 'Lead Mobile Architect';
      if (mindsetAnswer.contains('Freelance'))
        return 'Cross-Platform Specialist';
      return 'Senior Flutter Engineer';
    }

    if (skills.contains('python') ||
        skills.contains('data') ||
        skills.contains('ai')) {
      if (mindsetAnswer.contains('Academic')) return 'AI Research Scientist';
      return 'Data Systems Architect';
    }

    if (skills.contains('figma') || skills.contains('design')) {
      return 'Product Design Lead';
    }

    if (skills.contains('marketing') || skills.contains('seo')) {
      return 'Growth Marketing Strategist';
    }

    // Default fallback
    return '${answers[0]!.split(',').first.trim()} Specialist';
  }

  bool get isEntrepreneurial =>
      answers[3]?.toLowerCase().contains('entrepreneur') ??
      false || (answers[3]?.toLowerCase().contains('startup') ?? false);

  String get identityDomain {
    if (isEntrepreneurial) return 'Entrepreneurial';
    return (answers[3]?.toLowerCase().contains('freelance') ?? false)
        ? 'Freelance'
        : 'Corporate';
  }
}

// --- NOTIFIER ---

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  final List<OnboardingQuestion> questions = [
    const OnboardingQuestion(
      id: 0,
      title: "Skills & Technical Stack",
      description:
          "List your current skills and technical stack (e.g., Python, Docker, Figma, SEO).",
      options: [],
    ),
    const OnboardingQuestion(
      id: 1,
      title: "Core Passions",
      description: "What drives you when you are working with these tools?",
      options: [
        "Building scalable systems",
        "Solving complex logic",
        "Creative Design & UI",
        "Data & Analytics",
        "Security & Auditing",
      ],
    ),
    const OnboardingQuestion(
      id: 2,
      title: "Work Style",
      description: "How do you prefer to apply your skills?",
      options: [
        "Tinkering with hardware/low-level tech",
        "Rapid prototyping",
        "Deep research & learning",
        "Collaborative team projects",
      ],
    ),
    const OnboardingQuestion(
      id: 3,
      title: "Professional Mindset",
      description: "Where do you want these skills to take you?",
      options: [
        "Corporate Stability (9-5)",
        "High-growth Startup",
        "Solo Entrepreneur / Indie Hacker",
        "Freelance Consultant",
        "Academic Researcher",
      ],
    ),
    const OnboardingQuestion(
      id: 4,
      title: "Expertise Level",
      description: "How deep is your knowledge in the skills you listed?",
      options: ["Beginner", "Familiar", "Intermediate", "Advanced", "Expert"],
    ),
    const OnboardingQuestion(
      id: 5,
      title: "Work Environment",
      description: "What is your ideal workspace?",
      options: ["Fully Remote", "Hybrid", "In-office", "Digital Nomad"],
    ),
    const OnboardingQuestion(
      id: 6,
      title: "Learning Speed",
      description: "How do you upgrade your stack?",
      options: [
        "Video Tutorials",
        "Documentation & Books",
        "Hands-on Building",
        "Mentorship",
      ],
    ),
    const OnboardingQuestion(
      id: 7,
      title: "Risk Tolerance",
      description: "How do you feel about pivoting your career?",
      options: [
        "Safe & Calculated",
        "Moderate Risk",
        "High Risk / High Reward",
      ],
    ),
    const OnboardingQuestion(
      id: 8,
      title: "Financial Goal",
      description: "What is the primary motive for this roadmap?",
      options: [
        "High Base Salary",
        "Equity & Ownership",
        "Freedom & Flexibility",
        "Pure Passion",
      ],
    ),
    const OnboardingQuestion(
      id: 10,
      title: "Time Commitment",
      description: "How many hours can you put into this skill-to-role shift?",
      options: ["5-10 hours", "15-20 hours", "Full-time focus"],
    ),
  ];

  void setAnswer(String answer) {
    final currentAnswers = Map<int, String>.from(state.answers);
    if (currentAnswers[state.currentIndex] != answer) {
      currentAnswers[state.currentIndex] = answer;
      state = state.copyWith(
        answers: currentAnswers,
        isRegenerationRequired: true,
      );
    }
  }

  void answerCurrentAndNext(String answer) {
    setAnswer(answer);
    state = state.copyWith(
      currentIndex: state.currentIndex < questions.length - 1
          ? state.currentIndex + 1
          : state.currentIndex,
    );
  }

  void goBack() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void startOnboarding() => state = state.copyWith(hasStarted: true);

  void resetRegenerationFlag() =>
      state = state.copyWith(isRegenerationRequired: false);

  /// Generate AI-driven personality based on collected answers
  /// Calls Supabase Edge Function or API to determine optimal role and domain
  Future<void> generateAIPersonality() async {
    // Set loading state
    state = state.copyWith(isGeneratingPersonality: true);

    try {
      // Collect answers for AI prompt
      final skills = state.answers[0] ?? 'Not specified';
      final passions = state.answers[1] ?? 'Not specified';
      final workStyle = state.answers[2] ?? 'Not specified';
      final mindset = state.answers[3] ?? 'Not specified';
      final expertise = state.answers[4] ?? 'Not specified';
      final environment = state.answers[5] ?? 'Not specified';
      final learningStyle = state.answers[6] ?? 'Not specified';
      final riskTolerance = state.answers[7] ?? 'Not specified';
      final financialGoal = state.answers[8] ?? 'Not specified';
      final timeCommitment = state.answers[10] ?? 'Not specified';

      // Construct detailed prompt for AI
      final prompt = '''
Based on the following professional profile, determine the most high-value, modern job title and professional domain for this user in 2026:

Skills & Stack: $skills
Core Passions: $passions
Work Style: $workStyle
Professional Mindset: $mindset
Expertise Level: $expertise
Work Environment: $environment
Learning Style: $learningStyle
Risk Tolerance: $riskTolerance
Financial Goal: $financialGoal
Time Commitment: $timeCommitment

Please respond with ONLY a JSON object in this format (no markdown, no code blocks):
{
  "role": "Exact job title or role name",
  "domain": "Professional domain (e.g., Entrepreneurial, Corporate, Freelance, Academic)",
  "reasoning": "Brief explanation of why this role fits"
}
''';

      // Call AI API - using OpenAI as default (can be replaced with Supabase Edge Function)
      // Configuration should be in environment variables or secure storage

      // For now, use a mock response (replace with actual API call in production)
      final aiResponse = await _callAIPersonalityAPI(prompt);

      // Parse response
      if (aiResponse != null) {
        state = state.copyWith(
          aiRole: aiResponse['role'],
          aiDomain: aiResponse['domain'],
          isGeneratingPersonality: false,
        );
      } else {
        // Fallback to hardcoded logic if API fails
        state = state.copyWith(
          aiRole: state.computedRole,
          aiDomain: state.identityDomain,
          isGeneratingPersonality: false,
        );
      }
    } catch (e) {
      print('Error generating AI personality: $e');
      // Fallback on error
      state = state.copyWith(
        aiRole: state.computedRole,
        aiDomain: state.identityDomain,
        isGeneratingPersonality: false,
      );
    }
  }

  /// Call AI API to generate personality
  /// Returns parsed JSON response or null if failed
  Future<Map<String, dynamic>?> _callAIPersonalityAPI(String prompt) async {
    try {
      // Use Supabase Edge Function with configuration from constants
      final supabaseUrl = AppConfig.supabaseUrl;
      final supabaseKey = AppConfig.supabaseAnonKey;
      const functionName = 'generate-ai-personality';

      final response = await http
          .post(
            Uri.parse('$supabaseUrl/functions/v1/$functionName'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $supabaseKey',
            },
            body: jsonEncode({
              'prompt': prompt,
              'model': 'gpt-4',
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'role': jsonResponse['role'] ?? 'AI-Determined Professional',
          'domain': jsonResponse['domain'] ?? 'Strategic Professional',
        };
      }
      return null;
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }

  bool get isComplete =>
      state.currentIndex == questions.length - 1 &&
      state.answers.containsKey(state.currentIndex);

  // Proxy getters for UI compatibility
  String get computedRole => state.aiRole ?? state.computedRole;
  String get identityDomain => state.aiDomain ?? state.identityDomain;
  bool get isEntrepreneurial => state.isEntrepreneurial;
}

// --- PROVIDER ---

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
