enum AuthStatus {
  idle,
  loading,
  authenticated,
  failure,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
