import 'package:equatable/equatable.dart';

/// Base failure class for all exceptions in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required String message, String? code})
    : super(message: message, code: code);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required String message, String? code})
    : super(message: message, code: code);
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({required String message, String? code})
    : super(message: message, code: code);
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({required String message, String? code})
    : super(message: message, code: code);
}

/// Generic app failures
class AppFailure extends Failure {
  const AppFailure({required String message, String? code})
    : super(message: message, code: code);
}

/// AI/LLM service failures
class AIServiceFailure extends Failure {
  const AIServiceFailure({required String message, String? code})
    : super(message: message, code: code);
}
