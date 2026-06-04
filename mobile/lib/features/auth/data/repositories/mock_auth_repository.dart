import '../../domain/entities/auth_onboarding_draft.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/token_storage.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO: Development-only mock. Production auth now uses backend
    // email/password endpoints until Google OAuth is reintroduced.
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final normalizedEmail = email.trim().toLowerCase();
    final isMockUser = normalizedEmail == 'demo@sleep.local';
    final isMockPassword = password == 'sleep1234';

    if (!isMockUser || !isMockPassword) {
      throw const MockAuthFailure(
        'Используйте mock: demo@sleep.local / sleep1234.',
      );
    }
  }

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO: Development-only mock for email/password registration.
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (!email.trim().contains('@') || password.length < 8) {
      throw const MockAuthFailure(
        'Для mock-регистрации нужен email и пароль от 8 символов.',
      );
    }
  }

  @override
  Future<void> saveOnboardingDraft(AuthOnboardingDraft draft) async {
    // TODO: Send onboarding profile to /api/users/me/onboarding-profile.
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> signOut() async {
    // TODO: Call backend logout/revocation endpoint when it is available.
    await _tokenStorage.clear();
  }
}

class MockAuthFailure implements Exception {
  const MockAuthFailure(this.message);

  final String message;
}
