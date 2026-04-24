import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import 'architect_screen.dart';
import 'roadmap_screen.dart';
import 'skill_forge_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Map<String, dynamic>>> _loadRecentActivity() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final response = await Supabase.instance.client
        .from('career_logs')
        .select('task_type, user_input, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(5);

    final list = response as List<dynamic>?;
    if (list == null) return [];
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signed out successfully.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: ${error.toString()}')),
      );
    }
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon, {
    Color color = AppConfig.primaryNavy,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                      color.r.round(),
                      color.g.round(),
                      color.b.round(),
                      0.12,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(15, 23, 42, 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppConfig.primaryNavy, size: 22),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> item) {
    final type =
        item['task_type']?.toString().replaceAll('_', ' ').toUpperCase() ??
        'SESSION';
    final input = item['user_input']?.toString() ?? '';
    final createdAt = item['created_at']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                createdAt,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            input,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'guest@baymax.ai';

    return Scaffold(
      backgroundColor: AppConfig.surfaceGrey,
      appBar: AppBar(
        title: const Text('BAYMAX DASHBOARD'),
        centerTitle: true,
        backgroundColor: AppConfig.primaryNavy,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: _signOut,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadRecentActivity(),
        builder: (context, snapshot) {
          final activities = snapshot.data ?? [];
          final roadmapCount = activities
              .where((item) => item['task_type'] == 'career_roadmap')
              .length;
          final architectCount = activities
              .where((item) => item['task_type'] == 'project_architect')
              .length;
          final totalCount = activities.length;
          final lastSession = activities.isNotEmpty
              ? activities.first['created_at']?.toString() ?? 'Recently'
              : 'No sessions yet';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.06),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 34,
                            backgroundColor: AppConfig.primaryNavy,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Your personalized AI workspace is ready.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildMetricCard(
                            'Sessions',
                            '$totalCount',
                            Icons.timeline,
                          ),
                          const SizedBox(width: 14),
                          _buildMetricCard(
                            'Last activity',
                            lastSession,
                            Icons.access_time,
                            color: AppConfig.accentBlue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildActionCard(
                      title: 'Career Roadmap',
                      subtitle: 'Generate skill-driven career paths',
                      icon: Icons.map_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RoadmapScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      title: 'Skill Forge',
                      subtitle: 'Master skills with personalized plans',
                      icon: Icons.build_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SkillForgeScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildActionCard(
                      title: 'Project Architect',
                      subtitle: 'Design your next system architecture',
                      icon: Icons.architecture_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ArchitectScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 12,
                      height: 120,
                    ), // Placeholder for future feature
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildMetricCard(
                      'Roadmaps',
                      '$roadmapCount',
                      Icons.rocket_launch,
                      color: AppConfig.accentBlue,
                    ),
                    const SizedBox(width: 14),
                    _buildMetricCard(
                      'Architect',
                      '$architectCount',
                      Icons.build,
                      color: AppConfig.primaryNavy,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else if (activities.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'No activity yet. Start by generating your first career roadmap or architecture plan.',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                else
                  Column(children: activities.map(_buildActivityItem).toList()),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'What this dashboard gives you',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '• Fast access to roadmap and architect tools.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '• Live session overview from your recent AI interactions.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '• One-tap sign out with secure session handling.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
