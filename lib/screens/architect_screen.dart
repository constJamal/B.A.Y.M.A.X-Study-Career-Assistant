import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/baymax_app_bar.dart';
import '../services/ai_service.dart';

class ArchitectScreen extends StatefulWidget {
  const ArchitectScreen({super.key});

  @override
  State<ArchitectScreen> createState() => _ArchitectScreenState();
}

class ProjectArchitecture {
  final String frontend;
  final String backend;
  final String database;
  final String deployment;
  final List<String> keyFeatures;

  ProjectArchitecture({
    required this.frontend,
    required this.backend,
    required this.database,
    required this.deployment,
    required this.keyFeatures,
  });

  factory ProjectArchitecture.fromMap(Map<String, dynamic> map) {
    return ProjectArchitecture(
      frontend: map['frontend']?.toString() ?? 'Not specified',
      backend: map['backend']?.toString() ?? 'Not specified',
      database: map['database']?.toString() ?? 'Not specified',
      deployment: map['deployment']?.toString() ?? 'Not specified',
      keyFeatures: _listFrom(map['key_features']),
    );
  }

  static List<String> _listFrom(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String) {
      return value
          .split(RegExp(r'\n|,'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return [];
  }
}

class _ArchitectScreenState extends State<ArchitectScreen> {
  final _controller = TextEditingController();
  ProjectArchitecture? _architecture;
  String _feedback =
      'Describe your project idea to generate a structured architecture.';
  String _rawOutput = '';
  bool _loading = false;

  Future<void> _run() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(
        () => _feedback = 'Please log in to generate project architecture.',
      );
      return;
    }

    if (_controller.text.trim().isEmpty) {
      setState(() => _feedback = 'Please describe your project idea first.');
      return;
    }

    setState(() {
      _loading = true;
      _feedback = 'Designing project architecture...';
      _architecture = null;
      _rawOutput = '';
    });

    try {
      final raw = await AIService.consultBaymax(_controller.text, 'project');
      await Supabase.instance.client.from('career_logs').insert({
        'user_id': user.id,
        'task_type': 'project_architect',
        'user_input': _controller.text,
        'baymax_response': raw,
      });

      final parsed = _parseArchitecture(raw);
      setState(() {
        _rawOutput = raw;
        if (parsed != null) {
          _architecture = parsed;
          _feedback = 'Project architecture generated successfully.';
        } else {
          _feedback =
              'I could not parse the AI response. Review the raw output below.';
        }
      });
    } catch (error) {
      setState(
        () => _feedback = 'Error generating architecture: ${error.toString()}',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  ProjectArchitecture? _parseArchitecture(String raw) {
    for (final candidate in [raw, _extractJsonObject(raw)]) {
      if (candidate == null) continue;
      try {
        final decoded = jsonDecode(candidate);
        if (decoded is Map<String, dynamic>) {
          return ProjectArchitecture.fromMap(decoded);
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  String? _extractJsonObject(String input) {
    final start = input.indexOf('{');
    if (start < 0) return null;

    var depth = 0;
    for (var i = start; i < input.length; i++) {
      final char = input[i];
      if (char == '{') {
        depth++;
      } else if (char == '}') {
        depth--;
        if (depth == 0) {
          return input.substring(start, i + 1);
        }
      }
    }
    return null;
  }

  Widget _buildArchitectureCard() {
    if (_architecture == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildComponentCard(
          'Frontend',
          _architecture!.frontend,
          Icons.web,
          AppConfig.accentBlue,
        ),
        const SizedBox(height: 16),
        _buildComponentCard(
          'Backend',
          _architecture!.backend,
          Icons.code,
          AppConfig.primaryNavy,
        ),
        const SizedBox(height: 16),
        _buildComponentCard(
          'Database',
          _architecture!.database,
          Icons.storage,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildComponentCard(
          'Deployment',
          _architecture!.deployment,
          Icons.cloud_upload,
          Colors.green,
        ),
        const SizedBox(height: 20),
        const Text(
          'Key Features',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _architecture!.keyFeatures
              .map(
                (feature) => Chip(
                  label: Text(feature),
                  backgroundColor: AppConfig.surfaceGrey,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildComponentCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Builder(
      builder: (context) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRawOutput() {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : const Color.fromRGBO(158, 158, 158, 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raw AI Output',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: SingleChildScrollView(
                child: SelectableText(
                  _rawOutput,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      appBar: const BaymaxAppBar(title: 'Project Architect'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black26
                        : const Color.fromRGBO(0, 0, 0, 0.04),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Design your project architecture.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Describe your project idea to get recommendations for frontend, backend, database, and deployment strategies.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. A social media app for students with chat and posts',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: AppConfig.surfaceGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _loading ? null : _run,
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Generate Architecture'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _feedback,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_architecture != null) _buildArchitectureCard(),
            if (_architecture == null && _rawOutput.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildRawOutput(),
            ],
            if (_architecture == null && _rawOutput.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'What you\'ll get',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Frontend framework recommendations.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Backend technology stack.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Database choice and setup.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Deployment strategy.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
