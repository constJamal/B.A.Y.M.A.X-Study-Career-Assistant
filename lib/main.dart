import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants.dart';
import 'core/theme_manager.dart';
import 'core/utils/retry_util.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  } catch (e) {
    logger.e('Failed to initialize Supabase: $e');
    rethrow;
  }

  runApp(const ProviderScope(child: BaymaxApp()));
}

class BaymaxApp extends StatelessWidget {
  const BaymaxApp({super.key});

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppConfig.primaryBrand,
      scaffoldBackgroundColor: AppConfig.surfaceLight,
      colorScheme: ColorScheme.light(
        primary: AppConfig.primaryBrand,
        onPrimary: Colors.white,
        secondary: AppConfig.accentTeal,
        surface: AppConfig.surfaceLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConfig.primaryBrand,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppConfig.primaryBrand,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      colorScheme: const ColorScheme.dark(
        primary: AppConfig.primaryBrand,
        onPrimary: Colors.white,
        secondary: AppConfig.accentTeal,
        surface: Color(0xFF242424),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1A1A1A)),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: TextStyle(
          color: Colors.white.withAlpha((255 * 0.87).round()),
        ),
        bodySmall: TextStyle(
          color: Colors.white.withAlpha((255 * 0.70).round()),
        ),
        titleLarge: const TextStyle(color: Colors.white),
        titleMedium: TextStyle(
          color: Colors.white.withAlpha((255 * 0.87).round()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: mode,
          home: const AuthCheck(),
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;
        return session == null ? const LoginScreen() : const MainNavigator();
      },
    );
  }
}
