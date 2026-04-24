import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import '../services/ai_service.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class CareerPath {
  final String title;
  final String summary;
  final List<String> keySkills;
  final List<String> nextSteps;

  CareerPath({
    required this.title,
    required this.summary,
    required this.keySkills,
    required this.nextSteps,
  });

  factory CareerPath.fromMap(Map<String, dynamic> map) {
    return CareerPath(
      title: map['title']?.toString() ?? 'Untitled',
      summary: map['summary']?.toString() ?? '',
      keySkills: _listFrom(map['key_skills']),
      nextSteps: _listFrom(map['next_steps']),
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

class _RoadmapScreenState extends State<RoadmapScreen> {
  final _controller = TextEditingController();
  final List<CareerPath> _paths = [];
  String _feedback =
      'Enter your skills, interests, or goals to generate a structured career path.';
  String _rawOutput = '';
  bool _loading = false;

  Future<void> _run() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => _feedback = 'Please log in to generate a career roadmap.');
      return;
    }

    if (_controller.text.trim().isEmpty) {
      setState(
        () =>
            _feedback = 'Please type your current skills and interests first.',
      );
      return;
    }

    setState(() {
      _loading = true;
      _feedback = 'Building career paths...';
      _paths.clear();
      _rawOutput = '';
    });

    try {
      final raw = await AIService.consultBaymax(_controller.text, 'career');
      await Supabase.instance.client.from('career_logs').insert({
        'user_id': user.id,
        'task_type': 'career_roadmap',
        'user_input': _controller.text,
        'baymax_response': raw,
      });

      final parsed = _parseCareerPaths(raw);
      setState(() {
        _rawOutput = raw;
        if (parsed.isNotEmpty) {
          _paths.addAll(parsed);
          _feedback = 'Career paths generated successfully.';
        } else {
          _feedback =
              'I could not parse the AI response. Review the raw output below.';
        }
      });
    } catch (error) {
      setState(
        () => _feedback = 'Error generating roadmap: ${error.toString()}',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  List<CareerPath> _parseCareerPaths(String raw) {
    for (final candidate in [raw, _extractJsonObject(raw)]) {
      if (candidate == null) continue;
      try {
        final decoded = jsonDecode(candidate);
        if (decoded is Map<String, dynamic> &&
            decoded['career_paths'] is List) {
          return (decoded['career_paths'] as List)
              .whereType<Map<String, dynamic>>()
              .map(CareerPath.fromMap)
              .toList();
        }
      } catch (_) {
        continue;
      }
    }
    return [];
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

  Widget _buildRawOutput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(158, 158, 158, 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Raw AI Output',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: SingleChildScrollView(
              child: SelectableText(
                _rawOutput,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChips(List<String> skills) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: skills
          .map(
            (skill) => Chip(
              label: Text(skill),
              backgroundColor: AppConfig.surfaceGrey,
            ),
          )
          .toList(),
    );
  }

  Widget _buildCareerCard(CareerPath path) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              path.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              path.summary,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            if (path.keySkills.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Key Skills',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _buildSkillChips(path.keySkills),
            ],
            if (path.nextSteps.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Next Steps',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: path.nextSteps
                    .map(
                      (step) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.surfaceGrey,
      appBar: AppBar(
        title: const Text('Career Path Builder'),
        centerTitle: true,
        backgroundColor: AppConfig.primaryNavy,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.04),
                    offset: Offset(0, 8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Turn your skills into mapped career routes.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Type your strengths, technologies, and interests below to get structured career paths with recommended skills and next steps.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. Python, SQL, React, analytics, product design',
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
                          : const Text('Generate Career Paths'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _feedback,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_paths.isNotEmpty)
              ..._paths.map((path) => _buildCareerCard(path))
            else ...[
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
                      'What to expect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Three structured career paths based on your skills.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Clear next steps for each path.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Recommended skills and role direction.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
            if (_paths.isEmpty && _rawOutput.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildRawOutput(),
            ],
          ],
        ),
      ),
    );
  }
}
