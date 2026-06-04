class ApiEndpoints {
  const ApiEndpoints._();

  static const authLogout = '/api/auth/logout';
  static const authEmailPasswordLogin = '/api/auth/login';
  static const authEmailPasswordRegister = '/api/auth/register';
  static const onboardingProfile = '/api/users/me/onboarding-profile';
  static const currentUser = '/api/users/me';
  static const userProfile = '/api/users/me/profile';
  static const notificationSettings = '/api/users/me/notification-settings';
  static const integrations = '/api/users/me/integrations';
  static const privacySettings = '/api/users/me/privacy';
  static const activeSubscription = '/api/subscriptions/me';
  static const reportExport = '/api/ai-reports/export';

  // TODO: Confirm the friends contract with backend/product docs.
  static const friends = '/api/users/me/friends';
  static const friendsSharing = '/api/users/me/friends/sharing';
  static const friendChallenges = '/api/users/me/friends/challenges';
}
