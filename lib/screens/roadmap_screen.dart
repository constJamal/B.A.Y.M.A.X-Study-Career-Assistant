import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/ai_service.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final _controller = TextEditingController();
  String _response = "Enter your current tech stack to begin...";
  bool _loading = false;

  void _run() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() => _response = "Please log in to generate a career roadmap.");
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await AIService.consultBaymax(_controller.text, 'career');
      await Supabase.instance.client.from('career_logs').insert({
        'user_id': user.id,
        'task_type': 'career_roadmap',
        'user_input': _controller.text,
        'baymax_response': res,
      });
      setState(() => _response = res);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CAREER ROADMAP")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "e.g. Python, SQL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _run,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("GENERATE"),
            ),
            const SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
