class AuthSessionResponse {
  const AuthSessionResponse({
    required this.accessToken,
    this.refreshToken,
    this.userId,
  });

  final String accessToken;
  final String? refreshToken;
  final String? userId;

  factory AuthSessionResponse.fromJson(Map<String, Object?> json) {
    final accessToken = findAccessToken(json);

    if (accessToken is! String || accessToken.isEmpty) {
      throw const AuthSessionParsingFailure('Missing accessToken.');
    }

    return AuthSessionResponse(
      accessToken: accessToken,
      refreshToken: json['refreshToken'] as String?,
      userId: json['userId'] as String?,
    );
  }

  static String? findAccessToken(Map<String, Object?> json) {
    final directToken = json['accessToken'] ?? json['token'];
    if (directToken is String && directToken.isNotEmpty) {
      return directToken;
    }

    final data = json['data'];
    if (data is Map) {
      final dataToken = data['accessToken'] ?? data['token'];
      if (dataToken is String && dataToken.isNotEmpty) {
        return dataToken;
      }
    }

    return null;
  }
}

class AuthSessionParsingFailure implements Exception {
  const AuthSessionParsingFailure(this.message);

  final String message;
}
