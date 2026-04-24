import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import '../services/ai_service.dart';

class SkillForgeScreen extends StatefulWidget {
  const SkillForgeScreen({super.key});

  @override
  State<SkillForgeScreen> createState() => _SkillForgeScreenState();
}

class SkillForge {
  final String skillName;
  final String description;
  final List<String> learningResources;
  final List<String> practiceProjects;
  final String timeEstimate;

  SkillForge({
    required this.skillName,
    required this.description,
    required this.learningResources,
    required this.practiceProjects,
    required this.timeEstimate,
  });

  factory SkillForge.fromMap(Map<String, dynamic> map) {
    return SkillForge(
      skillName: map['skill_name']?.toString() ?? 'Unknown Skill',
      description: map['description']?.toString() ?? '',
      learningResources: _listFrom(map['learning_resources']),
      practiceProjects: _listFrom(map['practice_projects']),
      timeEstimate: map['time_estimate']?.toString() ?? 'Not specified',
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

class _SkillForgeScreenState extends State<SkillForgeScreen> {
  final _controller = TextEditingController();
  final List<SkillForge> _skills = [];
  String _feedback =
      'Enter a skill you want to master to get a personalized learning plan.';
  String _rawOutput = '';
  bool _loading = false;

  Future<void> _run() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => _feedback = 'Please log in to forge skills.');
      return;
    }

    if (_controller.text.trim().isEmpty) {
      setState(() => _feedback = 'Please enter a skill to forge.');
      return;
    }

    setState(() {
      _loading = true;
      _feedback = 'Forging your skill mastery plan...';
      _skills.clear();
      _rawOutput = '';
    });

    try {
      final raw = await AIService.consultBaymax(
        _controller.text,
        'skill_forge',
      );
      await Supabase.instance.client.from('career_logs').insert({
        'user_id': user.id,
        'task_type': 'skill_forge',
        'user_input': _controller.text,
        'baymax_response': raw,
      });

      final parsed = _parseSkills(raw);
      setState(() {
        _rawOutput = raw;
        if (parsed.isNotEmpty) {
          _skills.addAll(parsed);
          _feedback = 'Skill forge plan generated successfully.';
        } else {
          _feedback =
              'I could not parse the AI response. Review the raw output below.';
        }
      });
    } catch (error) {
      setState(() => _feedback = 'Error forging skills: ${error.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  List<SkillForge> _parseSkills(String raw) {
    for (final candidate in [raw, _extractJsonObject(raw)]) {
      if (candidate == null) continue;
      try {
        final decoded = jsonDecode(candidate);
        if (decoded is Map<String, dynamic> && decoded['skills'] is List) {
          return (decoded['skills'] as List)
              .whereType<Map<String, dynamic>>()
              .map(SkillForge.fromMap)
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

  Widget _buildSkillCard(SkillForge skill) {
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
              skill.skillName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              skill.description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  skill.timeEstimate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            if (skill.learningResources.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Learning Resources',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: skill.learningResources
                    .map(
                      (resource) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                resource,
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
            if (skill.practiceProjects.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Practice Projects',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: skill.practiceProjects
                    .map(
                      (project) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(
                                project,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.surfaceGrey,
      appBar: AppBar(
        title: const Text('Skill Forge'),
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
                    'Forge your skills with precision.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter a skill you want to master, and get a personalized learning plan with resources and projects.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. React development, machine learning, UI/UX design',
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
                          : const Text('Forge Skill'),
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
            if (_skills.isNotEmpty)
              ..._skills.map((skill) => _buildSkillCard(skill)).toList()
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
                      'What Skill Forge offers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Structured learning paths for any skill.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Curated resources and practice projects.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Time estimates for mastery.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• Personalized to your skill level.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
            if (_skills.isEmpty && _rawOutput.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildRawOutput(),
            ],
          ],
        ),
      ),
    );
  }
}
