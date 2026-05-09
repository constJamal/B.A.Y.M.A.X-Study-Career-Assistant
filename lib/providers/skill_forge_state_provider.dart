import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurriculumItem {
  final String title;
  final String type; // 'doc', 'video', 'repo'
  final String url;
  final String description;

  CurriculumItem({
    required this.title,
    required this.type,
    required this.url,
    required this.description,
  });
}

class ForgeState {
  final String topic;
  final String mastery;
  final String duration;
  final double progress;
  final List<CurriculumItem> curriculum;
  final bool isForging;

  ForgeState({
    this.topic = '',
    this.mastery = 'Beginner',
    this.duration = '',
    this.progress = 0.0,
    this.curriculum = const [],
    this.isForging = false,
  });

  ForgeState copyWith({
    String? topic,
    String? mastery,
    String? duration,
    double? progress,
    List<CurriculumItem>? curriculum,
    bool? isForging,
  }) {
    return ForgeState(
      topic: topic ?? this.topic,
      mastery: mastery ?? this.mastery,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      curriculum: curriculum ?? this.curriculum,
      isForging: isForging ?? this.isForging,
    );
  }
}

class ForgeNotifier extends StateNotifier<ForgeState> {
  ForgeNotifier() : super(ForgeState());

  void setInputs(String topic, String mastery, String duration) {
    state = state.copyWith(topic: topic, mastery: mastery, duration: duration);
  }

  void updateProgress(double newProgress) {
    state = state.copyWith(progress: newProgress);
  }

  Future<void> forgeCurriculum() async {
    state = state.copyWith(isForging: true);

    // Simulate calling the Groq Integration API
    // which would return a JSON containing the structured curriculum with 2026 industry standards.
    await Future.delayed(const Duration(seconds: 3));

    // Generate personalized curriculum based on topic, mastery level, and duration
    final curriculum = _generatePersonalizedCurriculum(
      state.topic,
      state.mastery,
      state.duration,
    );

    state = state.copyWith(
      isForging: false,
      curriculum: curriculum,
      progress: 0.1, // Reset progress for the new forge
    );
  }

  List<CurriculumItem> _generatePersonalizedCurriculum(
    String topic,
    String masteryLevel,
    String duration,
  ) {
    final items = <CurriculumItem>[];
    final realResources = _getRealResourcesForTopic(topic, masteryLevel);

    // Phase 1: Foundation (first 30% of time)
    items.add(
      CurriculumItem(
        title:
            '${realResources['foundationTitle'] ?? '$topic - Core Fundamentals'}',
        type: 'doc',
        url:
            realResources['foundationUrl'] ??
            'https://docs.example.com/$topic-fundamentals',
        description:
            '${realResources['foundationDesc'] ?? 'Essential concepts and foundations tailored for $masteryLevel level learners.'}  Target: ${_getPhaseWeeks(duration, 0.3)} weeks of study.',
      ),
    );

    // Phase 2: Deep Dive (middle 40% of time)
    if (masteryLevel == 'Intermediate' ||
        masteryLevel == 'Advanced' ||
        masteryLevel == 'Pro') {
      items.add(
        CurriculumItem(
          title:
              '${realResources['videoTitle'] ?? 'Advanced Patterns & Architecture'}',
          type: 'video',
          url:
              realResources['videoUrl'] ??
              'https://www.youtube.com/results?search_query=$topic+tutorial',
          description:
              '${realResources['videoDesc'] ?? 'Industry-standard design patterns and best practices.'}  Target: ${_getPhaseWeeks(duration, 0.4)} weeks of immersion.',
        ),
      );
    }

    // Phase 3: Practical Implementation (final 30% of time)
    items.add(
      CurriculumItem(
        title:
            '${realResources['projectTitle'] ?? 'Production-Ready Project: $topic'}',
        type: 'repo',
        url:
            realResources['projectUrl'] ?? 'https://github.com/search?q=$topic',
        description:
            '${realResources['projectDesc'] ?? 'Build a real-world application using $topic at $masteryLevel level.'}  Target: ${_getPhaseWeeks(duration, 0.3)} weeks to complete.',
      ),
    );

    // Add specialized content based on mastery level
    if (masteryLevel == 'Advanced' || masteryLevel == 'Pro') {
      items.add(
        CurriculumItem(
          title:
              '${realResources['advancedTitle'] ?? '$topic Performance Optimization & Scaling'}',
          type: 'doc',
          url:
              realResources['advancedUrl'] ??
              'https://github.com/topics/$topic-performance',
          description:
              realResources['advancedDesc'] ??
              'Advanced optimization techniques and scaling strategies for production systems.',
        ),
      );
    }

    if (masteryLevel == 'Pro') {
      items.add(
        CurriculumItem(
          title:
              '${realResources['openSourceTitle'] ?? 'Contributing to $topic Open Source'}',
          type: 'doc',
          url:
              realResources['openSourceUrl'] ??
              'https://github.com/topics/$topic',
          description:
              realResources['openSourceDesc'] ??
              'Master $topic by contributing to real-world open source projects and learning from core maintainers.',
        ),
      );
    }

    return items;
  }

  Map<String, String> _getRealResourcesForTopic(
    String topic,
    String masteryLevel,
  ) {
    final topicLower = topic.toLowerCase();

    // Rust resources
    if (topicLower.contains('rust')) {
      return {
        'foundationTitle': 'The Rust Programming Language - Official Book',
        'foundationUrl': 'https://doc.rust-lang.org/book/',
        'foundationDesc':
            'Official Rust documentation covering ownership, borrowing, and core concepts.',
        'videoTitle': 'Rust Advanced Patterns - Rustlings & Exercises',
        'videoUrl': 'https://github.com/rust-lang/rustlings',
        'videoDesc':
            'Interactive exercises teaching advanced Rust patterns and idioms.',
        'projectTitle': 'Rust Systems Programming Project Repository',
        'projectUrl': 'https://github.com/rust-lang/rust',
        'projectDesc':
            'Work on systems-level Rust projects or explore real implementations.',
        'advancedTitle': 'Rust Performance & Async Programming Deep Dive',
        'advancedUrl': 'https://tokio.rs/',
        'advancedDesc':
            'Master async/await, concurrency patterns, and performance optimization.',
        'openSourceTitle': 'Contribute to Official Rust Repositories',
        'openSourceUrl': 'https://github.com/rust-lang/rust/contribute',
        'openSourceDesc':
            'Contribute to the Rust compiler and standard library.',
      };
    }

    // Flutter resources
    if (topicLower.contains('flutter')) {
      return {
        'foundationTitle': 'Flutter Official Documentation & Codelabs',
        'foundationUrl': 'https://flutter.dev/docs',
        'foundationDesc':
            'Comprehensive Flutter guides including architecture and state management.',
        'videoTitle': 'Flutter Advanced Architecture - YouTube Series',
        'videoUrl':
            'https://www.youtube.com/c/FlutterDev/search?query=architecture',
        'videoDesc':
            'In-depth tutorials on advanced Flutter patterns and best practices.',
        'projectTitle': 'Flutter Example Applications Repository',
        'projectUrl': 'https://github.com/flutter/samples',
        'projectDesc':
            'Real-world Flutter applications demonstrating best practices.',
        'advancedTitle': 'Flutter Performance & Platform Channels',
        'advancedUrl': 'https://flutter.dev/docs/performance',
        'advancedDesc':
            'Optimize Flutter apps and master native platform integration.',
        'openSourceTitle': 'Contribute to Flutter Framework',
        'openSourceUrl': 'https://github.com/flutter/flutter/contribute',
        'openSourceDesc':
            'Contribute to the Flutter framework and help shape its future.',
      };
    }

    // Python resources
    if (topicLower.contains('python')) {
      return {
        'foundationTitle': 'Python Official Documentation',
        'foundationUrl': 'https://docs.python.org/3/',
        'foundationDesc':
            'Complete Python reference and tutorials from the official source.',
        'videoTitle': 'Real Python Advanced Tutorials',
        'videoUrl': 'https://realpython.com',
        'videoDesc':
            'In-depth Python tutorials on advanced topics and best practices.',
        'projectTitle': 'Awesome Python GitHub Repository',
        'projectUrl': 'https://github.com/vinta/awesome-python',
        'projectDesc':
            'Curated list of Python projects and libraries for various domains.',
        'advancedTitle': 'Python Performance & Optimization',
        'advancedUrl': 'https://wiki.python.org/moin/PythonSpeed',
        'advancedDesc':
            'Advanced optimization techniques and profiling strategies.',
        'openSourceTitle': 'Contribute to CPython',
        'openSourceUrl': 'https://github.com/python/cpython/contribute',
        'openSourceDesc':
            'Contribute to the Python language itself and its standard library.',
      };
    }

    // JavaScript/TypeScript resources
    if (topicLower.contains('javascript') ||
        topicLower.contains('typescript')) {
      return {
        'foundationTitle': 'MDN Web Docs - JavaScript Guide',
        'foundationUrl':
            'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
        'foundationDesc':
            'Comprehensive JavaScript documentation from Mozilla Developer Network.',
        'videoTitle': 'TypeScript Official Handbook',
        'videoUrl': 'https://www.typescriptlang.org/docs/',
        'videoDesc':
            'Complete TypeScript documentation and advanced type system guide.',
        'projectTitle': 'Awesome JavaScript Repository',
        'projectUrl': 'https://github.com/sorrycc/awesome-javascript',
        'projectDesc': 'Collection of JavaScript projects and frameworks.',
        'advancedTitle': 'JavaScript Performance & V8 Optimization',
        'advancedUrl': 'https://github.com/v8/v8/wiki',
        'advancedDesc':
            'Deep dive into JavaScript engines and performance optimization.',
        'openSourceTitle': 'Contribute to Node.js or TypeScript',
        'openSourceUrl': 'https://github.com/nodejs/node/contribute',
        'openSourceDesc':
            'Contribute to Node.js runtime or TypeScript compiler.',
      };
    }

    // React resources
    if (topicLower.contains('react')) {
      return {
        'foundationTitle': 'React Official Documentation',
        'foundationUrl': 'https://react.dev',
        'foundationDesc':
            'Official React documentation with interactive examples.',
        'videoTitle': 'React Advanced Patterns - Epic React Course',
        'videoUrl': 'https://github.com/kentcdodds/react-hooks',
        'videoDesc':
            'Advanced React patterns including hooks and performance optimization.',
        'projectTitle': 'Awesome React GitHub Repository',
        'projectUrl': 'https://github.com/enaqx/awesome-react',
        'projectDesc':
            'Curated list of React resources, libraries, and example projects.',
        'advancedTitle': 'React Performance & Concurrent Features',
        'advancedUrl': 'https://react.dev/blog',
        'advancedDesc':
            'Master concurrent rendering, code splitting, and performance tuning.',
        'openSourceTitle': 'Contribute to React',
        'openSourceUrl': 'https://github.com/facebook/react/contribute',
        'openSourceDesc':
            'Help build the future of React by contributing to the project.',
      };
    }

    // DevOps resources
    if (topicLower.contains('devops')) {
      return {
        'foundationTitle': 'DevOps Handbook & Best Practices',
        'foundationUrl': 'https://www.atlassian.com/devops',
        'foundationDesc':
            'Comprehensive DevOps fundamentals and industry best practices.',
        'videoTitle': 'Kubernetes Documentation',
        'videoUrl': 'https://kubernetes.io/docs/',
        'videoDesc':
            'Master container orchestration and modern DevOps practices.',
        'projectTitle': 'DevOps Project Examples on GitHub',
        'projectUrl': 'https://github.com/topics/devops',
        'projectDesc': 'Real-world DevOps projects and automation examples.',
        'advancedTitle': 'Advanced CI/CD Pipeline Architecture',
        'advancedUrl': 'https://www.jenkins.io/doc/',
        'advancedDesc':
            'Design and implement enterprise-grade CI/CD pipelines.',
        'openSourceTitle': 'Contribute to Kubernetes or Docker',
        'openSourceUrl': 'https://github.com/kubernetes/kubernetes/contribute',
        'openSourceDesc':
            'Help advance container technologies and cloud infrastructure.',
      };
    }

    // Default fallback for unlisted topics (searches on real platforms)
    return {
      'foundationTitle': '$topic - Official Documentation',
      'foundationUrl': 'https://github.com/topics/$topic',
      'foundationDesc':
          'Explore official documentation and resources for $topic.',
      'videoTitle': '$topic Learning Path',
      'videoUrl':
          'https://www.youtube.com/results?search_query=$topic+tutorial+for+beginners',
      'videoDesc': 'Video tutorials and learning resources from the community.',
      'projectTitle': '$topic Example Projects',
      'projectUrl': 'https://github.com/search?q=$topic',
      'projectDesc': 'Explore real-world projects and implementations.',
      'advancedTitle': '$topic Advanced Topics',
      'advancedUrl': 'https://github.com/topics/$topic',
      'advancedDesc': 'Advanced techniques and optimization strategies.',
      'openSourceTitle': 'Contribute to $topic Ecosystem',
      'openSourceUrl': 'https://github.com/topics/$topic',
      'openSourceDesc': 'Find open-source projects to contribute to.',
    };
  }

  String _getPhaseWeeks(String duration, double percentage) {
    // Parse duration string like "3 months", "12 weeks", "90 days"
    final weeks = _parseDurationToWeeks(duration);
    final phaseWeeks = (weeks * percentage).round();
    return phaseWeeks.toString();
  }

  int _parseDurationToWeeks(String duration) {
    duration = duration.toLowerCase().trim();

    if (duration.contains('month')) {
      final match = RegExp(r'(\d+)').firstMatch(duration);
      if (match != null) {
        final months = int.parse(match.group(1)!);
        return months * 4; // Approximate: 1 month = 4 weeks
      }
    } else if (duration.contains('week')) {
      final match = RegExp(r'(\d+)').firstMatch(duration);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
    } else if (duration.contains('day')) {
      final match = RegExp(r'(\d+)').firstMatch(duration);
      if (match != null) {
        final days = int.parse(match.group(1)!);
        return (days / 7).round();
      }
    }

    return 4; // Default: 1 month
  }
}

final forgeProvider = StateNotifierProvider<ForgeNotifier, ForgeState>((ref) {
  return ForgeNotifier();
});
