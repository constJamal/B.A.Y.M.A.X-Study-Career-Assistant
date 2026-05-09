# Baymax - Production-Ready AI-Powered Career & Learning Platform

## Architecture Overview

This refactored version of Baymax implements a professional, production-ready architecture based on **Clean Architecture** principles with the following layers:

### Layer Hierarchy

```
┌─────────────────────────────────────────────────┐
│           PRESENTATION LAYER (UI)               │
│    - Screens, Widgets, State Management         │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│         PROVIDERS LAYER (Riverpod)              │
│    - Dependency Injection & State Management    │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│         DOMAIN LAYER (Business Logic)           │
│    - Entities, Use Cases, Repositories (Abstract)
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│           DATA LAYER (Implementation)           │
│    - Repository Implementations, Data Sources   │
│    - Models, API Clients                        │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│        CORE LAYER (Cross-cutting Concerns)      │
│    - Networking, Error Handling, Utils          │
└─────────────────────────────────────────────────┘
```

## Key Architectural Components

### 1. Repository Pattern with Dependency Inversion

**Benefits:**

- Business logic is independent of data sources
- Easy to swap implementations (e.g., mock for testing)
- Clear separation of concerns

**Structure:**

```
domain/repositories/          # Abstract interfaces
  - repositories.dart         # Defines contracts

data/repositories/            # Concrete implementations
  - auth_repository_impl.dart
  - career_mapping_repository_impl.dart
  - skill_forge_repository_impl.dart
  - study_buddy_repository_impl.dart
```

### 2. Clean Architecture with Either Type

All repository methods return `Either<Failure, Success>` for functional error handling:

```dart
// Instead of throwing exceptions:
Future<Either<Failure, User>> signUp({...})

// Usage in screens:
result.fold(
  (failure) => handleError(failure),
  (user) => handleSuccess(user),
);
```

### 3. Riverpod State Management

**Why Riverpod?**

- Compile-time safety (no runtime errors from typos)
- Built-in async support with FutureProvider
- Easy dependency injection
- Better performance than Provider

**Usage:**

```dart
// Define providers in providers/providers.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(dataSource);
});

// Use in widgets
final user = ref.watch(currentUserProvider);
```

### 4. Supabase Edge Functions for AI Services

**Why Edge Functions?**

- ✅ Secure: API keys never exposed to frontend
- ✅ Scalable: Serverless execution
- ✅ Flexible: Write custom business logic
- ✅ Fast: Execute near data

**All AI features delegate to Edge Functions:**

```
career-mapping-agent          # Market-Aware Career Paths
skill-forge-multi-agent       # Multi-Agent Critic Pattern
study-buddy-rag              # RAG with pgvector
skill-forge-critic           # Validation logic
recommend-next-skill         # Knowledge Graph integration
```

### 5. RAG (Retrieval-Augmented Generation)

**Study Buddy Implementation:**

- Upload PDFs → Extract text → Generate embeddings → Store in pgvector
- Query: Embed query → Find similar chunks → Generate grounded response
- Source Citations: Track which chunks were used

**Database:**

```sql
-- document_embeddings table with pgvector
CREATE TABLE document_embeddings (
  id UUID PRIMARY KEY,
  document_id UUID,
  chunk_text TEXT,
  embedding vector(1536),  -- OpenAI embeddings
  metadata JSONB
);

CREATE INDEX idx_embeddings_vector ON document_embeddings
  USING IVFFLAT(embedding vector_cosine_ops);
```

### 6. Multi-Agent Critic Pattern

**Skill Forge Implementation:**

- **Agent 1**: Generate comprehensive skill roadmap
- **Agent 2 (Critic)**: Validate logical flow and dependencies
- **Output**: Roadmap + validation feedback

### 7. Streaming Responses

**For better UX during long AI operations:**

```dart
// Stream word-by-word display
Stream<String> streamSkillRoadmap(String skillName) async* {
  yield* repository.streamSkillRoadmap(skillName)
    .transform(StreamTransformer(...))
    .map((chunk) => chunk); // Word-by-word
}

// In UI
StreamingTextDisplay(textStream: streamAsync)
```

### 8. Knowledge Graph State

**Global state for skill progression:**

```dart
// Structure
{
  "completed_skills": [
    {"name": "Flutter Basics", "completed_at": "...", "mastery_level": 1.0}
  ],
  "in_progress_skills": [...],
  "skill_dependencies": {"Advanced Dart": ["Flutter Basics"]},
  "learning_path": ["Flutter Basics", "Advanced Dart", "State Management"],
  "mastery_levels": {"Flutter Basics": 1.0}
}
```

**Service:**

```dart
final knowledgeGraphService = ref.watch(knowledgeGraphServiceProvider);
await knowledgeGraphService.addCompletedSkill(userId, skill);
```

## File Structure

```
lib/
├── core/
│   ├── constants.dart
│   ├── theme_manager.dart
│   ├── failures/
│   │   └── failure.dart         # Error types
│   ├── network/
│   │   └── supabase_edge_function_client.dart
│   └── utils/
│       ├── either.dart          # Either<L,R> type
│       ├── retry_util.dart      # Retry with backoff
│       ├── streaming_response_handler.dart
│       └── EDGE_FUNCTIONS_GUIDE.dart
│
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── ai_remote_datasource.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── models.dart         # All freezed models
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── career_mapping_repository_impl.dart
│       ├── skill_forge_repository_impl.dart
│       └── study_buddy_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── entities.dart       # Domain models
│   └── repositories/
│       └── repositories.dart   # Abstract interfaces
│
├── presentation/
│   ├── widgets/
│   │   ├── shimmer_loader.dart
│   │   └── ai_response_widgets.dart
│   └── screens/
│       ├── signup_screen_refactored.dart
│       ├── skill_forge_screen_refactored.dart
│       └── study_buddy_screen_refactored.dart
│
├── providers/
│   ├── providers.dart
│   └── knowledge_graph_provider.dart
│
└── main.dart
```

## Usage Examples

### Example 1: User Signup with Error Handling

```dart
// In UI layer
final authRepository = ref.read(authRepositoryProvider);

final result = await authRepository.signUp(
  email: email,
  password: password,
  name: name,
);

result.fold(
  (failure) {
    // Handle error
    showSnackbar('Error: ${failure.message}');
  },
  (user) {
    // Handle success
    ref.invalidate(currentUserProvider);
    navigate('/home');
  },
);
```

### Example 2: Generate Skill Roadmap with Streaming

```dart
// Watch provider for async data
final roadmapAsync = ref.watch(skillRoadmapProvider(skillName));
final streamAsync = ref.watch(skillRoadmapStreamProvider(skillName));

// In UI
roadmapAsync.when(
  loading: () => ShimmerLoader(...),
  error: (error, _) => ErrorWidget(error: error),
  data: (roadmap) => SkillRoadmapDisplay(roadmap: roadmap),
)
```

### Example 3: Save Skill to Knowledge Graph

```dart
final knowledgeGraphService = ref.watch(knowledgeGraphServiceProvider);
final currentUser = ref.watch(currentUserProvider);

currentUser.whenData((user) {
  knowledgeGraphService.addCompletedSkill(user.id, skill)
    .then((_) {
      ref.invalidate(knowledgeGraphStatsProvider);
    });
});
```

## Testing Strategy

### Unit Tests

```dart
// Test repositories in isolation
test('AuthRepository signs up user', () async {
  final mockDataSource = MockAuthRemoteDataSource();
  final repo = AuthRepositoryImpl(mockDataSource);

  final result = await repo.signUp(...);

  expect(result, isA<Right>());
  expect(result.getOrNull(), isA<User>());
});
```

### Integration Tests

- Test repository + data source integration
- Mock Supabase responses

### Widget Tests

- Test UI components with mock providers

## Deployment Checklist

- [ ] Deploy Supabase Edge Functions (see `EDGE_FUNCTIONS_GUIDE.dart`)
- [ ] Create pgvector table for document embeddings
- [ ] Set environment variables in Supabase
- [ ] Update `AppConfig` with production URLs/keys
- [ ] Run code generation: `flutter pub run build_runner build`
- [ ] Build APK/IPA for release
- [ ] Test on real devices

## API Reference

### AuthRepository

```dart
Future<Either<Failure, User>> signUp(...)
Future<Either<Failure, User>> signIn(...)
Future<Either<Failure, void>> signOut()
Future<Either<Failure, User?>> getCurrentUser()
Future<Either<Failure, User>> updateProfile(...)
Future<Either<Failure, void>> resetPassword(...)
```

### CareerMappingRepository

```dart
Future<Either<Failure, List<CareerPath>>> getCareerPaths(...)
Stream<Either<Failure, CareerPath>> streamCareerPaths(...)
Future<Either<Failure, List<CareerPath>>> getNextCareerMoves(...)
```

### SkillForgeRepository

```dart
Future<Either<Failure, SkillRoadmap>> generateSkillRoadmap(...)
Stream<Either<Failure, String>> streamSkillRoadmap(...)
Future<Either<Failure, String>> getCriticFeedback(...)
Future<Either<Failure, void>> saveCompletedSkill(...)
Future<Either<Failure, Skill?>> getNextRecommendedSkill(...)
```

### StudyBuddyRepository

```dart
Future<Either<Failure, StudySummary>> summarizeDocument(...)
Stream<Either<Failure, String>> streamDocumentSummary(...)
Future<Either<Failure, StudySummary>> queryDocument(...)
Future<Either<Failure, String>> uploadDocument(...)
Future<Either<Failure, List<SourceCitation>>> getSourceCitations(...)
```

## Performance Optimizations

1. **Shimmer Loaders**: Perceived latency reduction
2. **Streaming Responses**: Progressive rendering (word-by-word)
3. **Exponential Backoff Retry**: Smart error recovery
4. **pgvector Indexing**: Fast similarity search for RAG
5. **Provider Caching**: Automatic result caching with Riverpod
6. **Code Generation**: Compile-time type safety with Freezed

## Security Considerations

✅ **API Keys secured in Edge Functions** - Never exposed to frontend  
✅ **JWT authentication** - Via Supabase Auth  
✅ **Row-level security** - Documents accessible only to owner  
✅ **Input validation** - All inputs validated before processing  
✅ **Error messages** - Generic messages in production

## Troubleshooting

### "Provider not found" error

- Ensure `ProviderScope` wraps the app in `main.dart`
- Run `flutter clean && flutter pub get`

### "Edge Function timeout"

- Check Edge Function logs in Supabase console
- Increase timeout in Supabase settings

### "pgvector not installed"

- Enable pgvector extension in Supabase: `CREATE EXTENSION vector;`

### "Embeddings mismatch"

- Ensure all embeddings use same model (text-embedding-3-small)
- Regenerate embeddings if model changes

## Migration from Old Architecture

See `migration_guide.md` for step-by-step instructions to migrate existing screens.

---

**Last Updated:** May 2026  
**Version:** 2.0.0 (Production Ready)
