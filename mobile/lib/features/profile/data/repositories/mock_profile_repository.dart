import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/user_profile_snapshot.dart';
import '../../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();

  @override
  Future<UserProfileSnapshot> getCurrentProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return UserProfileSnapshot(
      account: UserAccount(
        id: 'user-001',
        email: 'elena@example.com',
        name: 'Елена Морозова',
        googleId: 'google-mock-user-001',
        role: UserRole.user,
        createdAt: DateTime(2026, 5, 1),
        updatedAt: DateTime(2026, 6, 1),
      ),
      sleepSettings: const SleepProfileSettings(
        sleepGoal: 'Улучшить регулярность сна',
        preferredSleepTime: '23:00',
        preferredWakeTime: '07:00',
      ),
      subscription: UserSubscription(
        id: 'sub-001',
        userId: 'user-001',
        provider: 'PayPal',
        status: SubscriptionStatus.active,
        plan: SubscriptionPlan.premium,
        startedAt: DateTime(2026, 5, 20),
        expiresAt: DateTime(2026, 6, 20),
      ),
      notifications: const NotificationSettings(
        pushEnabled: true,
        sleepReminderTime: '22:30',
        smartRemindersEnabled: true,
        dataEntryReminderEnabled: true,
      ),
      integrations: const [
        ConnectedIntegration(
          id: 'google-oauth',
          name: 'Google OAuth',
          description: 'Основной способ входа в аккаунт',
          status: IntegrationStatus.connected,
        ),
        ConnectedIntegration(
          id: 'wearable-source',
          name: 'Wearable data source',
          description: 'Фазы сна и физиологические метрики',
          status: IntegrationStatus.planned,
        ),
      ],
      friends: const FriendsPreview(
        isReadyForBackend: false,
        connectedCount: 0,
        pendingInvites: 0,
        sharingEnabled: false,
        activeChallengesCount: 0,
        note:
            'Место под будущий sharing и challenges. Правила видимости данных и формат челленджей нужно подтвердить с backend/product.',
      ),
      endpointReferences: const [
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.currentUser,
          mockPurpose: 'User: id, email, name, googleId, role',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.userProfile,
          mockPurpose: 'UserProfile: sleepGoal, preferred times',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.activeSubscription,
          mockPurpose: 'Subscription: provider, plan, status, expiresAt',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.notificationSettings,
          mockPurpose: 'NotificationSettings for push and smart reminders',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.integrations,
          mockPurpose: 'Connected integrations and future wearable source',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.friends,
          mockPurpose: 'Friends list placeholder; backend contract is not final',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.friendsSharing,
          mockPurpose: 'Sharing settings placeholder for sleep progress visibility',
        ),
        ProfileEndpointReference(
          method: 'GET',
          path: ApiEndpoints.friendChallenges,
          mockPurpose: 'Challenges placeholder for future friend-based goals',
        ),
        ProfileEndpointReference(
          method: 'POST',
          path: ApiEndpoints.authLogout,
          mockPurpose: 'Logout/revoke session',
        ),
      ],
    );
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
