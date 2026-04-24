import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class AIService {
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  static Future<String> consultBaymax(String input, String mode) async {
    final systemPrompt = mode == 'career'
        ? "You are BAYMAX, an elite Career Architect. Provide a professional 7-day action plan for the user's tech stack."
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
