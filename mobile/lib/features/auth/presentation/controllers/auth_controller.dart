import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_onboarding_draft.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthState _state = const AuthState();

  AuthState get state => _state;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(
      action: () => _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
      successStatus: AuthStatus.authenticated,
      failureMessage: 'Не удалось войти. Проверьте почту, пароль и backend.',
    );
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(
      action: () => _authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
      ),
      successStatus: AuthStatus.registered,
      failureMessage:
          'Не удалось зарегистрироваться. Проверьте данные и backend.',
    );
  }

  Future<void> completeOnboarding(AuthOnboardingDraft draft) async {
    if (_state.isLoading) {
      return;
    }

    _setState(const AuthState(status: AuthStatus.completingOnboarding));

    try {
      await _authRepository.saveOnboardingDraft(draft);
      _setState(const AuthState(status: AuthStatus.onboardingComplete));
    } on Exception {
      _setState(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Не удалось сохранить профиль сна на backend.',
        ),
      );
    }
  }

  void resetError() {
    if (_state.status != AuthStatus.failure) {
      return;
    }

    _setState(const AuthState());
  }

  Future<void> _runAuthAction({
    required AsyncCallback action,
    required AuthStatus successStatus,
    required String failureMessage,
  }) async {
    if (_state.isLoading) {
      return;
    }

    _setState(const AuthState(status: AuthStatus.loading));

    try {
      await action();
      _setState(AuthState(status: successStatus));
    } on Exception {
      _setState(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: failureMessage,
        ),
      );
    }
  }

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
