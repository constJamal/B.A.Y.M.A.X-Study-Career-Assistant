/// Represents a value that can be either a success or a failure
abstract class Either<L, R> {
  const Either();

  /// Fold the Either: if it's a Left (failure), apply leftFn, if it's a Right (success), apply rightFn
  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    if (this is Left) {
      return leftFn((this as Left<L, R>).value);
    } else {
      return rightFn((this as Right<L, R>).value);
    }
  }

  /// Map the right value if it exists
  Either<L, T> map<T>(T Function(R) fn) {
    if (this is Left) {
      return Left((this as Left<L, R>).value);
    } else {
      return Right(fn((this as Right<L, R>).value));
    }
  }

  /// Map the left value if it exists
  Either<T, R> mapLeft<T>(T Function(L) fn) {
    if (this is Left) {
      return Left(fn((this as Left<L, R>).value));
    } else {
      return Right((this as Right<L, R>).value);
    }
  }

  /// Get right value or null
  R? getOrNull() {
    if (this is Right) {
      return (this as Right<L, R>).value;
    }
    return null;
  }

  /// Check if this is a success (Right)
  bool isRight() => this is Right;

  /// Check if this is a failure (Left)
  bool isLeft() => this is Left;
}

/// Represents a failure state
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  String toString() => 'Left($value)';
}

/// Represents a success state
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  String toString() => 'Right($value)';
}
