import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../core/network/supabase_edge_function_client.dart';
import '../data/datasources/ai_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/career_mapping_repository_impl.dart';
import '../data/repositories/skill_forge_repository_impl.dart';
import '../data/repositories/study_buddy_repository_impl.dart';
import '../domain/entities/entities.dart';
import '../domain/repositories/repositories.dart';

// ============ Core Providers ============

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Supabase Edge Function client provider
final edgeFunctionClientProvider = Provider<SupabaseEdgeFunctionClient>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseEdgeFunctionClient(supabase);
});

// ============ Data Source Providers ============

/// Auth remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSource(supabase);
});

/// AI remote data source provider
final aiRemoteDataSourceProvider = Provider<AIRemoteDataSource>((ref) {
  final edgeClient = ref.watch(edgeFunctionClientProvider);
  return AIRemoteDataSource(edgeClient);
});

// ============ Repository Providers ============

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

/// Career mapping repository provider
final careerMappingRepositoryProvider = Provider<CareerMappingRepository>((
  ref,
) {
  final dataSource = ref.watch(aiRemoteDataSourceProvider);
  return CareerMappingRepositoryImpl(dataSource);
});

/// Skill forge repository provider
final skillForgeRepositoryProvider = Provider<SkillForgeRepository>((ref) {
  final aiDataSource = ref.watch(aiRemoteDataSourceProvider);
  final authDataSource = ref.watch(authRemoteDataSourceProvider);
  return SkillForgeRepositoryImpl(aiDataSource, authDataSource);
});

/// Study buddy repository provider
final studyBuddyRepositoryProvider = Provider<StudyBuddyRepository>((ref) {
  final dataSource = ref.watch(aiRemoteDataSourceProvider);
  return StudyBuddyRepositoryImpl(dataSource);
});

// ============ State Providers ============

/// Current authenticated user provider
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final result = await authRepository.getCurrentUser();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
});

/// User sign out provider
final signOutProvider = FutureProvider.family<void, void>((ref, _) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final result = await authRepository.signOut();

  result.fold(
    (failure) => throw Exception(failure.message),
    (_) => ref.invalidate(currentUserProvider),
  );
});

/// Career paths provider
final careerPathsProvider = FutureProvider.family<List<CareerPath>, String>((
  ref,
  userInput,
) async {
  final repository = ref.watch(careerMappingRepositoryProvider);
  final result = await repository.getCareerPaths(userInput);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (paths) => paths,
  );
});

/// Career paths stream provider
final careerPathsStreamProvider = StreamProvider.family<CareerPath, String>((
  ref,
  userInput,
) async* {
  final repository = ref.watch(careerMappingRepositoryProvider);
  yield* repository.streamCareerPaths(userInput).asyncMap((either) {
    return either.fold(
      (failure) => throw Exception(failure.message),
      (path) => path,
    );
  });
});

/// Skill roadmap provider
final skillRoadmapProvider = FutureProvider.family<SkillRoadmap, String>((
  ref,
  skillName,
) async {
  final repository = ref.watch(skillForgeRepositoryProvider);
  final result = await repository.generateSkillRoadmap(skillName);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (roadmap) => roadmap,
  );
});

/// Skill roadmap stream provider
final skillRoadmapStreamProvider = StreamProvider.family<String, String>((
  ref,
  skillName,
) async* {
  final repository = ref.watch(skillForgeRepositoryProvider);
  yield* repository.streamSkillRoadmap(skillName).asyncMap((either) {
    return either.fold(
      (failure) => throw Exception(failure.message),
      (text) => text,
    );
  });
});

/// Document summary provider
final documentSummaryProvider = FutureProvider.family<StudySummary, String>((
  ref,
  documentId,
) async {
  final repository = ref.watch(studyBuddyRepositoryProvider);
  final result = await repository.summarizeDocument(documentId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (summary) => summary,
  );
});

/// Document summary stream provider
final documentSummaryStreamProvider = StreamProvider.family<String, String>((
  ref,
  documentId,
) async* {
  final repository = ref.watch(studyBuddyRepositoryProvider);
  yield* repository.streamDocumentSummary(documentId).asyncMap((either) {
    return either.fold(
      (failure) => throw Exception(failure.message),
      (text) => text,
    );
  });
});
