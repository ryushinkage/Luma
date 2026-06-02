import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/token_storage.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  @override
  Future<void> signInWithGoogle() async {
    // TODO: Replace with Google OAuth flow and backend token exchange.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // TODO: Store only backend-issued tokens through a secure storage adapter.
    // Mock login intentionally does not persist any token.
  }

  @override
  Future<void> signOut() async {
    // TODO: Call backend logout/revocation endpoint when it is available.
    await _tokenStorage.clear();
  }
}
