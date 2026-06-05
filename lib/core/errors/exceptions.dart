abstract class AppException {
  final String message;

  const AppException({
    required this.message,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required String message,
    this.statusCode,
  }) : super(message: message);
}

class NetworkException extends AppException {
  const NetworkException({
    required String message,
  }) : super(message: message);
}

class CacheException extends AppException {
  const CacheException({
    required String message,
  }) : super(message: message);
}

class ValidationException extends AppException {
  const ValidationException({
    required String message,
  }) : super(message: message);
}
