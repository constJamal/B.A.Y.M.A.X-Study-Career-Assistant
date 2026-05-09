import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingQuestion {
  final int id;
  final String title;
  final String description;
  final List<String> options;

  OnboardingQuestion({
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
  final String? computedRole; // The AI-determined Job Title stored in state

  OnboardingState({
    this.currentIndex = 0,
    this.answers = const {},
    this.isRegenerationRequired = false,
    this.hasStarted = false,
    this.computedRole,
  });

  OnboardingState copyWith({
    int? currentIndex,
    Map<int, String>? answers,
    bool? isRegenerationRequired,
    bool? hasStarted,
    String? computedRole,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isRegenerationRequired:
          isRegenerationRequired ?? this.isRegenerationRequired,
      hasStarted: hasStarted ?? this.hasStarted,
      computedRole: computedRole ?? this.computedRole,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  final List<OnboardingQuestion> questions = [
    OnboardingQuestion(
      id: 0,
      title: "Skills & Technical Stack",
      description:
          "List your current skills and technical stack (e.g., Python, Docker, Figma, SEO).",
      options: [], // Empty list signals the UI to show a TextField
    ),
    OnboardingQuestion(
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
    OnboardingQuestion(
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
    OnboardingQuestion(
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
    // ... consistent with your current questions
    OnboardingQuestion(
      id: 4,
      title: "Expertise Level",
      description: "How deep is your knowledge in the skills you listed?",
      options: ["Beginner", "Familiar", "Intermediate", "Advanced", "Expert"],
    ),
    OnboardingQuestion(
      id: 5,
      title: "Work Environment",
      description: "What is your ideal workspace?",
      options: ["Fully Remote", "Hybrid", "In-office", "Digital Nomad"],
    ),
    OnboardingQuestion(
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
    OnboardingQuestion(
      id: 7,
      title: "Risk Tolerance",
      description: "How do you feel about pivoting your career?",
      options: [
        "Safe & Calculated",
        "Moderate Risk",
        "High Risk / High Reward",
      ],
    ),
    OnboardingQuestion(
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
    OnboardingQuestion(
      id: 10,
      title: "Time Commitment",
      description: "How many hours can you put into this skill-to-role shift?",
      options: ["5-10 hours", "15-20 hours", "Full-time focus"],
    ),
  ];

  /// FIX: This method handles real-time text updates for the Skills TextField
  void setAnswer(String answer) {
    final currentAnswers = Map<int, String>.from(state.answers);

    // Only update and trigger rebuild if the text actually changed
    if (currentAnswers[state.currentIndex] != answer) {
      currentAnswers[state.currentIndex] = answer;

      state = state.copyWith(
        answers: currentAnswers,
        isRegenerationRequired: true,
        // Optional: clear computedRole while typing to indicate a change is in progress
        computedRole: null,
      );
    }
  }

  void answerCurrentAndNext(String answer) {
    // Update the answer first using setAnswer logic
    setAnswer(answer);

    // Move to the next question
    state = state.copyWith(
      currentIndex: state.currentIndex < questions.length - 1
          ? state.currentIndex + 1
          : state.currentIndex,
    );
  }

  /// AI Computation Logic: Derived from Skills + Mindset
  String get computedRole {
    final skills = state.answers[0]?.toLowerCase() ?? '';
    final mindset = state.answers[3] ?? '';

    if (skills.isEmpty) return 'Strategic Professional';

    if (skills.contains('flutter') || skills.contains('dart')) {
      if (mindset.contains('Startup')) return 'Lead Mobile Architect';
      if (mindset.contains('Freelance')) return 'Cross-Platform Specialist';
      return 'Senior Flutter Engineer';
    }
    if (skills.contains('python') ||
        skills.contains('data') ||
        skills.contains('ai')) {
      if (mindset.contains('Academic')) return 'AI Research Scientist';
      return 'Data Systems Architect';
    }
    if (skills.contains('figma') || skills.contains('design')) {
      return 'Product Design Lead';
    }
    if (skills.contains('marketing') || skills.contains('seo')) {
      return 'Growth Marketing Strategist';
    }

    // Dynamic Fallback: Uses the first skill entered
    return '${state.answers[0]!.split(',').first.trim()} Specialist';
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

  String get identityDomain {
    final mindset = state.answers[3]?.toLowerCase() ?? '';
    if (mindset.contains('entrepreneur') || mindset.contains('startup')) {
      return 'Entrepreneurial';
    } else if (mindset.contains('freelance')) {
      return 'Freelance';
    }
    return 'Corporate';
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
      return OnboardingNotifier();
    });
