class ApiClient {
  static const Duration defaultDelay = Duration(milliseconds: 500);
  static const Duration longDelay = Duration(milliseconds: 1000);

  static Future<T> simulateNetworkCall<T>(
    Future<T> Function() operation, {
    Duration? delay,
  }) async {
    await Future.delayed(delay ?? defaultDelay);
    return await operation();
  }

  static Future<T> simulateLongNetworkCall<T>(
    Future<T> Function() operation,
  ) async {
    await Future.delayed(longDelay);
    return await operation();
  }
}
