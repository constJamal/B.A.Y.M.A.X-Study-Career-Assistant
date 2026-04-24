import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class AIService {
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  static Future<String> consultBaymax(String input, String mode) async {
    final systemPrompt = mode == 'career'
        ? "You are BAYMAX, an elite Career Architect. The user will give you skills, technologies, interests, and experience. Return only valid JSON with a single object containing a career_paths array. Each career path must include title, summary, key_skills, and next_steps. Use this exact JSON format and nothing else:\n{\n  \"career_paths\": [\n    {\n      \"title\": \"...\",\n      \"summary\": \"...\",\n      \"key_skills\": [\"...\", \"...\"],\n      \"next_steps\": [\"...\", \"...\"]\n    }\n  ]\n}\n"
        : mode == 'project'
        ? "You are BAYMAX, a Senior Systems Architect. The user will describe a project idea. Return only valid JSON with a single object containing frontend, backend, database, deployment, and key_features. Use this exact JSON format and nothing else:\n{\n  \"frontend\": \"...\",\n  \"backend\": \"...\",\n  \"database\": \"...\",\n  \"deployment\": \"...\",\n  \"key_features\": [\"...\", \"...\"]\n}\n"
        : mode == 'skill_forge'
        ? "You are BAYMAX, a Skill Mastery Coach. The user will name a skill they want to learn. Return only valid JSON with a single object containing a skills array. Each skill must include skill_name, description, learning_resources, practice_projects, and time_estimate. Use this exact JSON format and nothing else:\n{\n  \"skills\": [\n    {\n      \"skill_name\": \"...\",\n      \"description\": \"...\",\n      \"learning_resources\": [\"...\", \"...\"],\n      \"practice_projects\": [\"...\", \"...\"],\n      \"time_estimate\": \"...\"\n    }\n  ]\n}\n"
        : "You are BAYMAX, a Senior Systems Architect. Provide a Database Schema and API strategy for this project.";

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer ${AppConfig.groqApiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {"role": "system", "content": systemPrompt},
          {"role": "user", "content": input},
        ],
        "temperature": 0.5,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['choices'][0]['message']['content'];
    } else {
      throw Exception('Baymax Service Error: ${response.statusCode}');
    }
  }
}
