import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/ai_service.dart';

class ArchitectScreen extends StatefulWidget {
  const ArchitectScreen({super.key});

  @override
  State<ArchitectScreen> createState() => _ArchitectScreenState();
}

class _ArchitectScreenState extends State<ArchitectScreen> {
  final _controller = TextEditingController();
  String _response = "Submit a project idea for architecture specs...";
  bool _loading = false;

  void _run() async {
    setState(() => _loading = true);
    try {
      final res = await AIService.consultBaymax(_controller.text, 'project');
      await Supabase.instance.client.from('career_logs').insert({
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'task_type': 'project_architect',
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
      appBar: AppBar(title: const Text("PROJECT ARCHITECT")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "e.g. Hospital Management System",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading ? null : _run,
              child: const Text("BUILD SCHEMA"),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.black87,
              child: Text(
                _response,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
