enum UserRole {
  user,
  admin,
}

enum SubscriptionPlan {
  free,
  premium,
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
}

enum IntegrationStatus {
  connected,
  planned,
}

class UserAccount {
  const UserAccount({
    required this.id,
    required this.email,
    required this.name,
    required this.googleId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String googleId;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class SleepProfileSettings {
  const SleepProfileSettings({
    required this.sleepGoal,
    required this.preferredSleepTime,
    required this.preferredWakeTime,
  });

  final String sleepGoal;
  final String preferredSleepTime;
  final String preferredWakeTime;
}

class UserSubscription {
  const UserSubscription({
    required this.id,
    required this.userId,
    required this.provider,
    required this.status,
    required this.plan,
    required this.startedAt,
    required this.expiresAt,
  });

  final String id;
  final String userId;
  final String provider;
  final SubscriptionStatus status;
  final SubscriptionPlan plan;
  final DateTime? startedAt;
  final DateTime? expiresAt;

  bool get isPremium {
    return plan == SubscriptionPlan.premium &&
        status == SubscriptionStatus.active;
  }
}

class NotificationSettings {
  const NotificationSettings({
    required this.pushEnabled,
    required this.sleepReminderTime,
    required this.smartRemindersEnabled,
    required this.dataEntryReminderEnabled,
  });

  final bool pushEnabled;
  final String sleepReminderTime;
  final bool smartRemindersEnabled;
  final bool dataEntryReminderEnabled;
}

class ConnectedIntegration {
  const ConnectedIntegration({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  final String id;
  final String name;
  final String description;
  final IntegrationStatus status;
}

class FriendsPreview {
  const FriendsPreview({
    required this.isReadyForBackend,
    required this.connectedCount,
    required this.pendingInvites,
    required this.sharingEnabled,
    required this.activeChallengesCount,
    required this.note,
  });

  final bool isReadyForBackend;
  final int connectedCount;
  final int pendingInvites;
  final bool sharingEnabled;
  final int activeChallengesCount;
  final String note;
}

class ProfileEndpointReference {
  const ProfileEndpointReference({
    required this.method,
    required this.path,
    required this.mockPurpose,
  });

  final String method;
  final String path;
  final String mockPurpose;
}

class UserProfileSnapshot {
  const UserProfileSnapshot({
    required this.account,
    required this.sleepSettings,
    required this.subscription,
    required this.notifications,
    required this.integrations,
    required this.friends,
    required this.endpointReferences,
  });

  final UserAccount account;
  final SleepProfileSettings sleepSettings;
  final UserSubscription subscription;
  final NotificationSettings notifications;
  final List<ConnectedIntegration> integrations;
  final FriendsPreview friends;
  final List<ProfileEndpointReference> endpointReferences;
}
