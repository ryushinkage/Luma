import '../../domain/services/token_storage.dart';

class InMemoryTokenStorage implements TokenStorage {
  String? _accessToken;

  @override
  Future<void> saveAccessToken(String token) async {
    // TODO: Replace with secure device storage before real authentication.
    _accessToken = token;
  }

  @override
  Future<String?> readAccessToken() async {
    return _accessToken;
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
  }
}
