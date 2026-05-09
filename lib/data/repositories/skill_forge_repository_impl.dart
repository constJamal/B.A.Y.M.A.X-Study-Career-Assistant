import 'dart:async';
import '../models/models.dart';
import '../../core/failures/failure.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/ai_remote_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of SkillForgeRepository
class SkillForgeRepositoryImpl implements SkillForgeRepository {
  final AIRemoteDataSource _aiDataSource;
  final AuthRemoteDataSource _authDataSource;

  SkillForgeRepositoryImpl(this._aiDataSource, this._authDataSource);

  @override
  Future<Either<Failure, SkillRoadmap>> generateSkillRoadmap(
    String skillName,
  ) async {
    try {
      final roadmapModel = await _aiDataSource.generateSkillRoadmap(skillName);
      return Right(roadmapModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, String>> streamSkillRoadmap(String skillName) async* {
    try {
      yield* _aiDataSource
          .streamSkillRoadmap(skillName)
          .transform(
            StreamTransformer.fromHandlers(
              handleData: (chunk, sink) {
                sink.add(Right(chunk));
              },
              handleError: (error, stack, sink) {
                sink.add(Left(AIServiceFailure(message: error.toString())));
              },
            ),
          );
    } catch (e) {
      yield Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCriticFeedback(
    SkillRoadmap roadmap,
  ) async {
    try {
      final feedback = await _aiDataSource.getCriticFeedback({
        'skills': roadmap.skills.map((s) => s.toJson()).toList(),
        'skill_dependencies': roadmap.skillDependencies,
        'generated_prompt': roadmap.generatedPrompt,
      });
      return Right(feedback);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCompletedSkill(
    String userId,
    Skill skill,
  ) async {
    try {
      // Get current knowledge graph
      final graph = await _authDataSource.getKnowledgeGraph(userId);
      final updatedGraph = graph ?? {};

      // Initialize or update completed skills
      if (!updatedGraph.containsKey('completed_skills')) {
        updatedGraph['completed_skills'] = [];
      }

      final completedSkills = List<Map<String, dynamic>>.from(
        updatedGraph['completed_skills'] ?? [],
      );
      completedSkills.add({
        'name': skill.skillName,
        'completed_at': DateTime.now().toIso8601String(),
      });

      updatedGraph['completed_skills'] = completedSkills;

      // Update knowledge graph
      await _authDataSource.updateKnowledgeGraph(userId, updatedGraph);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Skill?>> getNextRecommendedSkill(
    String userId,
    Map<String, dynamic> knowledgeGraph,
  ) async {
    try {
      final skillModel = await _aiDataSource.getNextRecommendedSkill(
        userId,
        knowledgeGraph,
      );
      return Right(skillModel?.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AIServiceFailure(message: e.toString()));
    }
  }
}

extension on Skill {
  Map<String, dynamic> toJson() => {
    'skill_name': skillName,
    'description': description,
    'learning_resources': learningResources,
    'practice_projects': practiceProjects,
    'time_estimate': timeEstimate,
    'prerequisites': prerequisites,
    'next_skills': nextSkills,
  };
}
