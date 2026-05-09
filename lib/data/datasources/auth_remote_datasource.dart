import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/failures/failure.dart';
import '../models/user_model.dart';

/// Remote authentication data source
class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource(this._supabase);

  /// Sign up new user
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerFailure(message: 'Sign up failed');
      }

      // Create user profile
      await _supabase.from('profiles').insert({
        'id': response.user!.id,
        'full_name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        fullName: name,
        createdAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  /// Sign in user
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AuthFailure(message: 'Sign in failed');
      }

      // Fetch user profile
      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(profileData);
    } on AuthException catch (e) {
      throw AuthFailure(message: e.message, code: e.statusCode);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final profileData = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(profileData);
    } catch (e) {
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _supabase.from('profiles').update(updates).eq('id', userId);

      final updated = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(updated);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  /// Get knowledge graph for user
  Future<Map<String, dynamic>?> getKnowledgeGraph(String userId) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select('knowledge_graph')
          .eq('id', userId)
          .single();

      return data['knowledge_graph'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Update knowledge graph
  Future<void> updateKnowledgeGraph(
    String userId,
    Map<String, dynamic> graph,
  ) async {
    try {
      await _supabase
          .from('profiles')
          .update({'knowledge_graph': graph})
          .eq('id', userId);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
