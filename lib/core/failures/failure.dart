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
  const ServerFailure({required super.message, super.code});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Generic app failures
class AppFailure extends Failure {
  const AppFailure({required super.message, super.code});
}

/// AI/LLM service failures
class AIServiceFailure extends Failure {
  const AIServiceFailure({required super.message, super.code});
}
