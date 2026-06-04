abstract interface class ApiClient {
  Future<Map<String, Object?>> getJson(String endpoint);

  Future<Map<String, Object?>> postJson(
    String endpoint, {
    Map<String, Object?> body = const {},
  });

  Future<Map<String, Object?>> putJson(
    String endpoint, {
    Map<String, Object?> body = const {},
  });
}

class ApiRequestFailure implements Exception {
  const ApiRequestFailure(this.message);

  final String message;

  @override
  String toString() => 'ApiRequestFailure: $message';
}
