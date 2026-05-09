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

  /// Summarize document using RAG (Retrieval-Augmented Generation)
  /// PDFs are processed as vector embeddings using pgvector
  Future<StudySummaryModel> summarizeDocument(String documentId) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'study-buddy-rag',
        body: {'document_id': documentId, 'use_rag': true},
      );

      return StudySummaryModel.fromJson(response);
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Stream document summary using RAG
  Stream<String> streamDocumentSummary(String documentId) {
    try {
      return _edgeFunctionClient.streamFunction(
        'study-buddy-rag',
        body: {'document_id': documentId, 'use_rag': true, 'stream': true},
      );
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Query document with RAG
  Future<StudySummaryModel> queryDocument(
    String documentId,
    String query,
  ) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'study-buddy-rag-query',
        body: {'document_id': documentId, 'query': query, 'use_rag': true},
      );

      return StudySummaryModel.fromJson(response);
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Upload document for RAG embedding
  Future<String> uploadDocument(String filePath, String userId) async {
    try {
      // This would typically use multipart upload
      // For now, we call an edge function
      final response = await _edgeFunctionClient.callFunction(
        'upload-document-for-rag',
        body: {'file_path': filePath, 'user_id': userId},
      );

      return response['document_id'] as String;
    } catch (e) {
      throw AIServiceFailure(message: e.toString());
    }
  }

  /// Get source citations for a summary
  Future<List<SourceCitationModel>> getSourceCitations(String summaryId) async {
    try {
      final response = await _edgeFunctionClient.callFunction(
        'get-source-citations',
        body: {'summary_id': summaryId},
      );

      final citations = (response['citations'] as List)
          .map((e) => SourceCitationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return citations;
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
