import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/entities.dart';
import '../data/datasources/auth_remote_datasource.dart';
import 'providers.dart';

/// Manages the global knowledge graph state for skill progression
class KnowledgeGraphService {
  final AuthRemoteDataSource _dataSource;

  KnowledgeGraphService(this._dataSource);

  /// Initialize knowledge graph for user
  Future<Map<String, dynamic>> initializeKnowledgeGraph(String userId) async {
    final graph = await _dataSource.getKnowledgeGraph(userId) ?? {};

    graph['completed_skills'] = graph['completed_skills'] ?? [];
    graph['in_progress_skills'] = graph['in_progress_skills'] ?? [];
    graph['skill_dependencies'] = graph['skill_dependencies'] ?? {};
    graph['learning_path'] = graph['learning_path'] ?? [];
    graph['mastery_levels'] = graph['mastery_levels'] ?? {};

    await _dataSource.updateKnowledgeGraph(userId, graph);
    return graph;
  }

  /// Add completed skill and update recommendations
  Future<Map<String, dynamic>> addCompletedSkill(
    String userId,
    Skill skill,
  ) async {
    final graph = await _dataSource.getKnowledgeGraph(userId) ?? {};

    final completedSkills = List<Map<String, dynamic>>.from(
      graph['completed_skills'] ?? [],
    );

    // Check if already completed
    if (!completedSkills.any((s) => s['name'] == skill.skillName)) {
      completedSkills.add({
        'name': skill.skillName,
        'completed_at': DateTime.now().toIso8601String(),
        'mastery_level': 1.0,
      });
    }

    graph['completed_skills'] = completedSkills;

    // Update mastery levels
    final masteryLevels = Map<String, double>.from(
      graph['mastery_levels'] ?? {},
    );
    masteryLevels[skill.skillName] = 1.0;
    graph['mastery_levels'] = masteryLevels;

    // Store next skills from current skill
    if (skill.nextSkills != null && skill.nextSkills!.isNotEmpty) {
      final learningPath = List<String>.from(graph['learning_path'] ?? []);
      for (final nextSkill in skill.nextSkills!) {
        if (!learningPath.contains(nextSkill)) {
          learningPath.add(nextSkill);
        }
      }
      graph['learning_path'] = learningPath;
    }

    await _dataSource.updateKnowledgeGraph(userId, graph);
    return graph;
  }

  /// Get recommended next skill based on completed skills
  Future<String?> getNextRecommendedSkill(Map<String, dynamic> graph) async {
    final learningPath = List<String>.from(graph['learning_path'] ?? []);
    final completedSkills = List<Map<String, dynamic>>.from(
      graph['completed_skills'] ?? [],
    );

    final completedNames = completedSkills
        .map((s) => s['name'] as String)
        .toSet();

    // Find first uncompleted skill in learning path
    for (final skill in learningPath) {
      if (!completedNames.contains(skill)) {
        return skill;
      }
    }

    return null;
  }

  /// Update skill mastery level
  Future<void> updateMasteryLevel(
    String userId,
    String skillName,
    double level,
  ) async {
    final graph = await _dataSource.getKnowledgeGraph(userId) ?? {};
    final masteryLevels = Map<String, double>.from(
      graph['mastery_levels'] ?? {},
    );

    masteryLevels[skillName] = level.clamp(0.0, 1.0);
    graph['mastery_levels'] = masteryLevels;

    await _dataSource.updateKnowledgeGraph(userId, graph);
  }

  /// Add skill to in-progress
  Future<void> startSkill(String userId, String skillName) async {
    final graph = await _dataSource.getKnowledgeGraph(userId) ?? {};
    final inProgress = List<Map<String, dynamic>>.from(
      graph['in_progress_skills'] ?? [],
    );

    if (!inProgress.any((s) => s['name'] == skillName)) {
      inProgress.add({
        'name': skillName,
        'started_at': DateTime.now().toIso8601String(),
      });
    }

    graph['in_progress_skills'] = inProgress;
    await _dataSource.updateKnowledgeGraph(userId, graph);
  }

  /// Remove skill from in-progress
  Future<void> completeSkill(String userId, String skillName) async {
    final graph = await _dataSource.getKnowledgeGraph(userId) ?? {};
    final inProgress = List<Map<String, dynamic>>.from(
      graph['in_progress_skills'] ?? [],
    );

    inProgress.removeWhere((s) => s['name'] == skillName);
    graph['in_progress_skills'] = inProgress;

    await _dataSource.updateKnowledgeGraph(userId, graph);
  }

  /// Get full knowledge graph stats
  Future<Map<String, dynamic>> getKnowledgeGraphStats(String userId) async {
    final graph = await _dataSource.getKnowledgeGraph(userId) ?? {};

    return {
      'total_completed': (graph['completed_skills'] as List?)?.length ?? 0,
      'in_progress': (graph['in_progress_skills'] as List?)?.length ?? 0,
      'learning_path_remaining':
          ((graph['learning_path'] as List?)?.length ?? 0) -
          ((graph['completed_skills'] as List?)?.length ?? 0),
      'average_mastery': _calculateAverageMastery(graph),
      'next_skill': await getNextRecommendedSkill(graph),
    };
  }

  /// Calculate average mastery across all skills
  double _calculateAverageMastery(Map<String, dynamic> graph) {
    final masteryLevels =
        (graph['mastery_levels'] as Map<String, dynamic>?) ?? {};

    if (masteryLevels.isEmpty) return 0.0;

    final total = masteryLevels.values.whereType<num>().fold<double>(
      0,
      (sum, level) => sum + level.toDouble(),
    );

    return total / masteryLevels.length;
  }
}

/// Riverpod provider for knowledge graph service
final knowledgeGraphServiceProvider = Provider<KnowledgeGraphService>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return KnowledgeGraphService(dataSource);
});

/// Riverpod provider for knowledge graph state
final knowledgeGraphProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
      final service = ref.watch(knowledgeGraphServiceProvider);
      return service.initializeKnowledgeGraph(userId);
    });

/// Riverpod provider for knowledge graph stats
final knowledgeGraphStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
      final service = ref.watch(knowledgeGraphServiceProvider);
      return service.getKnowledgeGraphStats(userId);
    });
