import 'package:logger/logger.dart';

final logger = Logger();

/// Retry utility with exponential backoff
class RetryUtil {
  static Future<T> retry<T>({
    required Future<T> Function() fn,
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await fn();
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        logger.w(
          'Retry attempt $attempt/$maxRetries after ${delay.inMilliseconds}ms',
          error: e,
        );
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }
  }

  /// Stream-based retry for better control
  static Stream<T> retryStream<T>({
    required Stream<T> Function() fn,
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async* {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        yield* fn();
        return;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        logger.w(
          'Stream retry attempt $attempt/$maxRetries after ${delay.inMilliseconds}ms',
          error: e,
        );
        await Future.delayed(delay);
        delay *= 2;
      }
    }
  }
}
