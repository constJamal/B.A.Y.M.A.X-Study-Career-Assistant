import '../../core/failures/failure.dart';
import '../../core/utils/either.dart';
import '../entities/entities.dart';

/// Abstract authentication repository
abstract class AuthRepository {
  /// Sign up a new user
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in an existing user
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Get the current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    required Map<String, dynamic> updates,
  });

  /// Reset password with email verification
  Future<Either<Failure, void>> resetPassword(String email);
}

/// Abstract career mapping repository
abstract class CareerMappingRepository {
  /// Get career paths based on user input with market-aware agent
  /// The agent simulates real-time industry trend analysis
  Future<Either<Failure, List<CareerPath>>> getCareerPaths(
    String userInput, {
    bool includeMarketTrends = true,
  });

  /// Stream career paths for real-time response
  Stream<Either<Failure, CareerPath>> streamCareerPaths(String userInput);

  /// Get recommended next career moves based on knowledge graph
  Future<Either<Failure, List<CareerPath>>> getNextCareerMoves(
    String userId,
    Map<String, dynamic> knowledgeGraph,
  );
}

/// Abstract skill forge repository (with multi-agent critic pattern)
abstract class SkillForgeRepository {
  /// Generate a skill roadmap with critic validation
  /// First agent generates roadmap, second 'Critic' agent validates logical flow
  Future<Either<Failure, SkillRoadmap>> generateSkillRoadmap(String skillName);

  /// Stream skill roadmap generation with word-by-word streaming
  Stream<Either<Failure, String>> streamSkillRoadmap(String skillName);

  /// Get critic feedback on a generated roadmap
  Future<Either<Failure, String>> getCriticFeedback(SkillRoadmap roadmap);

  /// Save completed skill to knowledge graph
  Future<Either<Failure, void>> saveCompletedSkill(String userId, Skill skill);

  /// Get next recommended skill based on completed prerequisites
  Future<Either<Failure, Skill?>> getNextRecommendedSkill(
    String userId,
    Map<String, dynamic> knowledgeGraph,
  );
}
