# Migration Guide: Old Architecture → New Clean Architecture

## Overview

This guide helps you migrate existing screens from the old simple setState pattern to the new production-ready Clean Architecture with Riverpod.

## Step-by-Step Migration

### Step 1: Understand the New Flow

**Old Pattern:**

```dart
// Direct service calls
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  void _handleAction() async {
    final result = await AIService.consultBaymax(input, mode);
    setState(() { /* update UI */ });
  }
}
```

**New Pattern:**

```dart
// Repository via Riverpod
class MyScreenRefactored extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreenRefactored> createState() => _MyScreenRefactoredState();
}

class _MyScreenRefactoredState extends ConsumerState<MyScreenRefactored> {
  void _handleAction() async {
    final repository = ref.read(myRepositoryProvider);
    final result = await repository.doAction();
    result.fold(
      (failure) => handleError(failure),
      (success) => handleSuccess(success),
    );
  }
}
```

### Step 2: Convert StatefulWidget to ConsumerStatefulWidget

**Before:**

```dart
class SkillForgeScreen extends StatefulWidget {
  const SkillForgeScreen({super.key});

  @override
  State<SkillForgeScreen> createState() => _SkillForgeScreenState();
}

class _SkillForgeScreenState extends State<SkillForgeScreen> {
  // ...
}
```

**After:**

```dart
class SkillForgeScreen extends ConsumerStatefulWidget {
  const SkillForgeScreen({super.key});

  @override
  ConsumerState<SkillForgeScreen> createState() => _SkillForgeScreenState();
}

class _SkillForgeScreenState extends ConsumerState<SkillForgeScreen> {
  // Now you can use ref.read() and ref.watch()
}
```

### Step 3: Replace Service Calls with Repository Calls

**Before:**

```dart
void _handleSignup() async {
  try {
    await AuthService().signUp(
      email,
      password,
      name,
    );
    Navigator.pop(context);
  } catch (e) {
    showError(e.toString());
  }
}
```

**After:**

```dart
void _handleSignup() async {
  final authRepository = ref.read(authRepositoryProvider);

  final result = await authRepository.signUp(
    email: email,
    password: password,
    name: name,
  );

  result.fold(
    (failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${failure.message}')),
      );
    },
    (user) {
      ref.invalidate(currentUserProvider);
      Navigator.pop(context);
    },
  );
}
```

### Step 4: Handle Async Data with Providers

**Before:**

```dart
class _MyScreenState extends State<MyScreen> {
  Future<List<CareerPath>>? _careerPaths;

  @override
  void initState() {
    super.initState();
    _careerPaths = AIService.getCareerPaths(input);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _careerPaths,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(...);
        }
        return CareerPathsList(paths: snapshot.data!);
      },
    );
  }
}
```

**After:**

```dart
class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final careerPathsAsync = ref.watch(careerPathsProvider(input));

    return careerPathsAsync.when(
      loading: () => ShimmerLoader(...),
      error: (error, _) => ErrorWidget(error: error),
      data: (paths) => CareerPathsList(paths: paths),
    );
  }
}
```

### Step 5: Replace setState with invalidate

**Before:**

```dart
void _updateData() async {
  final data = await service.fetchData();
  setState(() => _cachedData = data);
}
```

**After:**

```dart
void _updateData() async {
  final repository = ref.read(myRepositoryProvider);
  await repository.updateData();

  // Refresh the provider
  ref.invalidate(myDataProvider);
}
```

### Step 6: Use Streaming for Real-time Data

**Before:**

```dart
// No streaming support
```

**After:**

```dart
class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final streamAsync = ref.watch(skillRoadmapStreamProvider(skillName));

    return streamAsync.when(
      data: (chunk) => StreamingTextDisplay(textStream: streamAsync),
      loading: () => LoadingIndicator(),
      error: (error, _) => ErrorWidget(error: error),
    );
  }
}
```

### Step 7: Integrate Knowledge Graph

**Before:**

```dart
// No knowledge graph tracking
```

**After:**

```dart
void _saveCompletedSkill(Skill skill) async {
  final currentUser = ref.watch(currentUserProvider);
  final knowledgeGraphService = ref.watch(knowledgeGraphServiceProvider);

  currentUser.whenData((user) {
    knowledgeGraphService.addCompletedSkill(user.id, skill)
      .then((_) {
        ref.invalidate(knowledgeGraphStatsProvider);
      });
  });
}
```

## Common Migration Patterns

### Pattern 1: Form Submission

**Before:**

```dart
class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signIn(email, password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      child: _isLoading ? CircularProgressIndicator() : Text('Login'),
    );
  }
}
```

**After:**

```dart
class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signIn(
        email: email,
        password: password,
      );

      result.fold(
        (failure) => _showError(failure.message),
        (user) {
          ref.invalidate(currentUserProvider);
          Navigator.pushReplacementNamed(context, '/home');
        },
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      child: _isLoading ? CircularProgressIndicator() : Text('Login'),
    );
  }
}
```

### Pattern 2: Conditional UI Rendering

**Before:**

```dart
class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService().getCurrentUser();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return LoadingScreen();
    if (_user == null) return NoUserScreen();
    return UserProfileScreen(user: _user!);
  }
}
```

**After:**

```dart
class _ProfileScreenState extends ConsumerWidget {
  const _ProfileScreenState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => LoadingScreen(),
      error: (error, _) => ErrorScreen(error: error),
      data: (user) => user == null
        ? NoUserScreen()
        : UserProfileScreen(user: user),
    );
  }
}
```

### Pattern 3: Error Handling

**Before:**

```dart
void _handleAction() async {
  try {
    final data = await service.fetchData();
    setState(() => _data = data);
  } on SocketException catch (e) {
    _showError('Network error: $e');
  } on TimeoutException catch (e) {
    _showError('Request timeout');
  } catch (e) {
    _showError('Unknown error: $e');
  }
}
```

**After:**

```dart
void _handleAction() async {
  final repository = ref.read(myRepositoryProvider);
  final result = await repository.fetchData();

  result.fold(
    (failure) {
      // Typed error handling
      final message = switch (failure) {
        NetworkFailure() => 'Network error: ${failure.message}',
        ServerFailure() => 'Server error: ${failure.message}',
        _ => 'Unknown error: ${failure.message}',
      };
      _showError(message);
    },
    (data) => setState(() => _data = data),
  );
}
```

## Checklist for Migrating a Screen

- [ ] Change `StatefulWidget` to `ConsumerStatefulWidget`
- [ ] Change `State<T>` to `ConsumerState<T>`
- [ ] Replace all service calls with repository calls
- [ ] Convert `setState` to `ref.invalidate`
- [ ] Replace `FutureBuilder` with `ref.watch` + `.when()`
- [ ] Replace exception handling with `.fold()` pattern
- [ ] Add error messages using typed `Failure` classes
- [ ] Integrate shimmer loaders for loading states
- [ ] Add knowledge graph integration where applicable
- [ ] Test all user interactions
- [ ] Test error scenarios

## New Dependencies Required

```yaml
dependencies:
  riverpod: ^2.6.1
  flutter_riverpod: ^2.6.1
  freezed_annotation: ^2.4.1
  equatable: ^2.0.5
  shimmer: ^3.0.0
```

## Running Code Generation

After creating/modifying freezed models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch
```

## Testing Migration

### Unit Test Example

```dart
test('SignUp failure returns left', () async {
  final mockDataSource = MockAuthRemoteDataSource();
  when(mockDataSource.signUp(...))
    .thenThrow(ServerFailure(message: 'Error'));

  final repo = AuthRepositoryImpl(mockDataSource);
  final result = await repo.signUp(...);

  expect(result, isA<Left>());
  expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
});
```

### Widget Test Example

```dart
testWidgets('Shows error snackbar on signup failure', (tester) async {
  await tester.pumpWidget(
    ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      ],
      child: BaymaxApp(),
    ),
  );

  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  expect(find.byType(SnackBar), findsOneWidget);
});
```

## Troubleshooting

**Issue:** "Provider not found exception"  
**Solution:** Ensure `ProviderScope` is at the root of your app

**Issue:** "ref is not available"  
**Solution:** Use `ConsumerStatefulWidget` or `ConsumerWidget`

**Issue:** "Data is null after state change"  
**Solution:** Use `ref.invalidate()` to refresh the provider

**Issue:** "Build failed - Freezed code not generated"  
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs`

## Performance Tips

1. Use `ref.read()` for one-time operations
2. Use `ref.watch()` for reactive updates
3. Leverage Riverpod's built-in caching
4. Use `.select()` to watch specific fields only
5. Implement pagination for large lists

---

**Note:** The old `services/` folder and direct service calls are deprecated. Use repositories instead.
