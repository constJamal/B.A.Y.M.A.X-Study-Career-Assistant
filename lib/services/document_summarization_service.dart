import 'dart:convert';
import 'package:http/http.dart' as http;

class DocumentSummarizationService {
  static const String _groqApiUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  // Note: In production, store API key in environment variables
  static const String _groqApiKey = 'YOUR_GROQ_API_KEY';

  /// Generates a bullet-point summary from extracted document text
  static Future<String> generateBulletPointSummary(
    String documentText,
    String documentName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Authorization': 'Bearer $_groqApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mixtral-8x7b-32768',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert document summarizer. Create clear, concise bullet points that capture the key insights and main ideas from the document. Each bullet point should be a complete thought that stands alone. Include relevant page references where mentioned in the document.',
            },
            {
              'role': 'user',
              'content':
                  'Please summarize the following document "$documentName" as a bullet-point list. Format each bullet point starting with "• " on a new line:\n\n$documentText',
            },
          ],
          'temperature': 0.5,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summaryText = data['choices'][0]['message']['content'];
        return summaryText;
      } else {
        throw Exception('Failed to generate summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating summary: $e');
    }
  }

  /// Generates a focused bullet-point summary based on a specific query
  static Future<String> generateFocusedSummary(
    String documentText,
    String query,
    String documentName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Authorization': 'Bearer $_groqApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mixtral-8x7b-32768',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert document analyst. Extract and summarize information from documents as concise bullet points. Focus on answering the user\'s specific query while maintaining accuracy and relevance.',
            },
            {
              'role': 'user',
              'content':
                  'Document: "$documentName"\n\nUser Query: $query\n\nPlease provide bullet-point answers from the document. Format each bullet point starting with "• " on a new line:\n\n$documentText',
            },
          ],
          'temperature': 0.3,
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summaryText = data['choices'][0]['message']['content'];
        return summaryText;
      } else {
        throw Exception('Failed to generate summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating focused summary: $e');
    }
  }

  /// Parses bullet points from the generated summary
  static List<String> parseBulletPoints(String summary) {
    final lines = summary.split('\n');
    final bulletPoints = <String>[];

    for (String line in lines) {
      final trimmed = line.trim();
      // Match bullet points starting with •, -, *, or digits followed by .
      if ((trimmed.startsWith('•') ||
              trimmed.startsWith('-') ||
              trimmed.startsWith('*') ||
              RegExp(r'^\d+\.').hasMatch(trimmed)) &&
          trimmed.length > 1) {
        // Remove the bullet character
        String point = trimmed;
        if (trimmed.startsWith('•') ||
            trimmed.startsWith('-') ||
            trimmed.startsWith('*')) {
          point = trimmed.substring(1).trim();
        } else if (RegExp(r'^\d+\.').hasMatch(trimmed)) {
          point = trimmed.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
        }
        if (point.isNotEmpty) {
          bulletPoints.add(point);
        }
      }
    }

    return bulletPoints;
  }

  /// Validates if document text is suitable for summarization
  static bool isValidDocumentText(String text) {
    // Check if text has minimum length and content
    return text.trim().length > 100 &&
        text.split(' ').length > 20; // At least 20 words
  }
}
