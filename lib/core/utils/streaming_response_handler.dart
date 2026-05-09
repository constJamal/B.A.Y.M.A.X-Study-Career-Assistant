import 'dart:async';

/// Handles streaming responses with buffering for smooth word-by-word display
class StreamingResponseHandler {
  final Duration bufferDuration;

  StreamingResponseHandler({
    this.bufferDuration = const Duration(milliseconds: 50),
  });

  /// Process a stream of text chunks and emit word-by-word
  Stream<String> processStream(Stream<String> sourceStream) async* {
    await for (final chunk in sourceStream) {
      if (chunk.isEmpty) continue;

      // If the chunk contains spaces, split and yield words
      if (chunk.contains(' ')) {
        final words = chunk.split(' ');
        for (int i = 0; i < words.length; i++) {
          final isLast = i == words.length - 1;
          yield words[i] + (isLast ? '' : ' ');

          // Simulate smooth word-by-word latency if needed
          if (bufferDuration.inMilliseconds > 0) {
            await Future.delayed(bufferDuration);
          }
        }
      } else {
        // Otherwise just yield the chunk
        yield chunk;
        if (bufferDuration.inMilliseconds > 0) {
          await Future.delayed(bufferDuration);
        }
      }
    }
  }

  /// Accumulate streamed chunks into a single string
  Future<String> accumulateStream(Stream<String> sourceStream) async {
    final buffer = StringBuffer();
    await for (final chunk in sourceStream) {
      buffer.write(chunk);
    }
    return buffer.toString();
  }

  /// Stream with error handling and retry
  Stream<String> streamWithErrorHandling(
    Stream<String> Function() streamProvider, {
    int maxRetries = 3,
  }) async* {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        yield* processStream(streamProvider());
        return;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          yield 'ERROR: Failed after $maxRetries attempts - $e';
        }
      }
    }
  }
}
