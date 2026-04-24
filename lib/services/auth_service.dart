import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<void> signUp(String email, String password, String name) async {
    final res = await _supabase.auth.signUp(email: email, password: password);
    if (res.user != null) {
      await _supabase.from('profiles').insert({
        'id': res.user!.id,
        'full_name': name,
        'section': '6B',
        'major': 'BSIT',
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async => await _supabase.auth.signOut();
}
