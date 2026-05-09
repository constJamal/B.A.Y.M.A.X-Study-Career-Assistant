import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

import '../../core/utils/retry_util.dart';

/// Supabase Edge Function client wrapper
class SupabaseEdgeFunctionClient {
  final SupabaseClient _supabase;

  SupabaseEdgeFunctionClient(this._supabase);

  /// Call an edge function with retry logic
  Future<Map<String, dynamic>> callFunction(
    String functionName, {
    required Map<String, dynamic> body,
    int maxRetries = 3,
  }) async {
    return RetryUtil.retry(
      fn: () async {
        final response = await _supabase.functions.invoke(
          functionName,
          body: body,
        );

        if (response.status != 200) {
          throw Exception(
            'Edge Function Error [$functionName]: ${response.status} - ${response.data}',
          );
        }

        return Map<String, dynamic>.from(response.data);
      },
      maxRetries: maxRetries,
    );
  }

  /// Stream responses from edge function (for Server-Sent Events like behavior)
  Stream<String> streamFunction(
    String functionName, {
    required Map<String, dynamic> body,
  }) async* {
    try {
      final response = await _supabase.functions.invoke(
        functionName,
        body: {...body, 'stream': true},
      );

      if (response.status != 200) {
        throw Exception('Stream Error: ${response.status}');
      }

      // Handle streaming response
      final data = response.data;
      if (data is String) {
        // Split by newlines for SSE-like streaming
        final lines = data.split('\n');
        for (final line in lines) {
          if (line.isNotEmpty) {
            yield line;
          }
        }
      } else if (data is Map) {
        yield jsonEncode(data);
      }
    } catch (e) {
      yield 'ERROR: $e';
    }
  }

  /// Get authentication token
  String? getAuthToken() {
    return _supabase.auth.currentSession?.accessToken;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }
}
