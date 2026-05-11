import '../../core/failures/failure.dart';
import '../../core/network/supabase_edge_function_client.dart';
import '../models/models.dart';

/// Remote AI/LLM data source via Supabase Edge Functions
class AIRemoteDataSource {
  final SupabaseEdgeFunctionClient _edgeFunctionClient;

  AIRemoteDataSource(this._edgeFunctionClient);

  /// Get career paths via market-aware agent Edge Function
  Future<List<CareerPathModel>> getCareerPaths(String userInput) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'career-mapping-agent',
        body: {'user_input': userInput, 'include_market_trends': true},
      );

      final careerPaths = (response['career_paths'] as List)
          .map((e) => CareerPathModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return careerPaths;
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Stream career paths for real-time updates
  Stream<String> streamCareerPaths(String userInput) {
    try {
      return _edgeFunctionClient.streamFunction(
        'career-mapping-agent',
        body: {
          'user_input': userInput,
          'include_market_trends': true,
          'stream': true,
        },
      );
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Generate skill roadmap with multi-agent critic pattern
  /// First agent generates, second 'Critic' agent validates logical flow
  Future<SkillRoadmapModel> generateSkillRoadmap(String skillName) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'skill-forge-multi-agent',
        body: {'skill_name': skillName, 'enable_critic': true},
      );

      return SkillRoadmapModel.fromJson(response);
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Stream skill roadmap generation (word-by-word)
  Stream<String> streamSkillRoadmap(String skillName) {
    try {
      return _edgeFunctionClient.streamFunction(
        'skill-forge-multi-agent',
        body: {'skill_name': skillName, 'enable_critic': true, 'stream': true},
      );
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Get critic feedback on roadmap
  Future<String> getCriticFeedback(Map<String, dynamic> roadmap) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'skill-forge-critic',
        body: {'roadmap': roadmap},
      );

      return response['feedback'] as String;
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Get next recommended skill based on knowledge graph
  Future<SkillModel?> getNextRecommendedSkill(
    String userId,
    Map<String, dynamic> knowledgeGraph,
  ) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'recommend-next-skill',
        body: {'user_id': userId, 'knowledge_graph': knowledgeGraph},
      );

      if (response['skill'] == null) return null;

      return SkillModel.fromJson(response['skill'] as Map<String, dynamic>);
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }
}
