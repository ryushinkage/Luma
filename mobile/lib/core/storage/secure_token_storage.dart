import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/services/token_storage.dart';

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: 'accessToken',
      value: token,
    );
  }

  @override
  Future<String?> readAccessToken() async {
    return _storage.read(key: 'accessToken');
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: 'accessToken');
  }
}
