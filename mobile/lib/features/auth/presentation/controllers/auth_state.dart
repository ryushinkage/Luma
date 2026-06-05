enum AuthStatus {
  idle,
  loading,
  authenticated,
  registered,
  completingOnboarding,
  onboardingComplete,
  failure,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? errorMessage;

  bool get isLoading {
    return status == AuthStatus.loading ||
        status == AuthStatus.completingOnboarding;
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isRegistered => status == AuthStatus.registered;
  bool get isOnboardingComplete => status == AuthStatus.onboardingComplete;

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
