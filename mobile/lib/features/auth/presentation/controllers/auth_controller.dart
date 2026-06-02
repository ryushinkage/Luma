import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthState _state = const AuthState();

  AuthState get state => _state;

  Future<void> signInWithGoogle() async {
    if (_state.isLoading) {
      return;
    }

    _setState(const AuthState(status: AuthStatus.loading));

    try {
      await _authRepository.signInWithGoogle();
      _setState(const AuthState(status: AuthStatus.authenticated));
    } on Exception {
      _setState(
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Не вдалося увійти. Спробуйте ще раз.',
        ),
      );
    }
  }

  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }
}
