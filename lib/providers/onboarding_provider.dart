import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  const OnboardingState({
    this.currentIndex = 0,
    this.answers = const {},
    this.isRegenerationRequired = false,
    this.hasStarted = false,
  });

  // Manual copyWith to replace Freezed functionality
  OnboardingState copyWith({
    int? currentIndex,
    Map<int, String>? answers,
    bool? isRegenerationRequired,
    bool? hasStarted,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isRegenerationRequired:
          isRegenerationRequired ?? this.isRegenerationRequired,
      hasStarted: hasStarted ?? this.hasStarted,
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

  bool get isComplete =>
      state.currentIndex == questions.length - 1 &&
      state.answers.containsKey(state.currentIndex);

  // Proxy getters for UI compatibility
  String get computedRole => state.computedRole;
  String get identityDomain => state.identityDomain;
  bool get isEntrepreneurial => state.isEntrepreneurial;
}

// --- PROVIDER ---

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
