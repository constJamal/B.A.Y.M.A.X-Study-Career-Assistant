import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

class SideMenuDrawer extends ConsumerStatefulWidget {
  const SideMenuDrawer({super.key});

  @override
  ConsumerState<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends ConsumerState<SideMenuDrawer> {
  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    setState(() => _isSigningOut = true);
    try {
      await AuthService().signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: $e'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
      setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider.notifier).currentTheme;
    final onboardingState = ref.watch(onboardingProvider);

    return Drawer(
      backgroundColor: theme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Profile Section at Top
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryColor.withOpacity(0.8),
                  theme.secondaryColor.withOpacity(0.6),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),

                // User Name
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: theme.fontFamily,
                  ),
                ),
                const SizedBox(height: 6),

                // Role / Identity
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    onboardingState.computedRole,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: theme.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    theme: theme,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuItem(
                    icon: Icons.school_rounded,
                    label: 'Learning Path',
                    theme: theme,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuItem(
                    icon: Icons.assessment_rounded,
                    label: 'Progress',
                    theme: theme,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    theme: theme,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_rounded,
                    label: 'Help & Support',
                    theme: theme,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),

          // Sign Out Button at Bottom
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSigningOut ? null : _handleSignOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  foregroundColor: Colors.red[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red[300]!, width: 1.5),
                  ),
                  elevation: 0,
                ),
                icon: _isSigningOut
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.red[400]),
                        ),
                      )
                    : Icon(Icons.logout_rounded, size: 20),
                label: Text(
                  _isSigningOut ? 'Signing out...' : 'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: theme.fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required ApparelTheme theme,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: theme.fontFamily,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: theme.secondaryColor.withOpacity(0.5),
        size: 14,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      hoverColor: theme.primaryColor.withOpacity(0.1),
    );
  }
}
