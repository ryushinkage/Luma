import '../entities/auth_onboarding_draft.dart';

abstract interface class AuthRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> saveOnboardingDraft(AuthOnboardingDraft draft);

  Future<void> signOut();
}
