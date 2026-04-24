import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = Supabase.instance.client
        .from('career_logs')
        .stream(primaryKey: ['id'])
        .order('created_at');

    return Scaffold(
      appBar: AppBar(title: const Text("CONSULTATION HISTORY")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(logs[index]['task_type']),
              subtitle: Text(logs[index]['user_input']),
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: SingleChildScrollView(
                    child: Text(logs[index]['baymax_response']),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
