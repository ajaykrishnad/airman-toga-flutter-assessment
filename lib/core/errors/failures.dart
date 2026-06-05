abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
  });
}
