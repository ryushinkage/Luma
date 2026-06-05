import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';
import '../../domain/entities/user_profile_snapshot.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.loadProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    final didSignOut = await _controller.signOut();

    if (!mounted || !didSignOut) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
  }

  void _showMockAction(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label будет подключено после backend-контракта.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final profile = state.profile;

        if (state.isLoading && profile == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == ProfileStatus.failure && profile == null) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: EmptyState(
                  icon: Icons.person_outline,
                  title: 'Профиль не загрузился',
                  description: state.errorMessage ??
                      'Mock-данные профиля временно недоступны.',
                  actionLabel: 'Повторить',
                  onActionPressed: () {
                    _controller.loadProfile();
                  },
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ScreenHeader(
                    title: 'Профиль',
                    subtitle:
                        'Аккаунт, подписка и настройки Sleep Analytics.',
                    isRefreshing: state.status == ProfileStatus.loading,
                  ),
                  const SizedBox(height: 20),
                  _ProfileHeaderCard(account: profile!.account),
                  const SizedBox(height: 16),
                  _SubscriptionCard(
                    subscription: profile.subscription,
                    onPressed: () => _showMockAction('Управление подпиской'),
                  ),
                  const SizedBox(height: 16),
                  _SleepGoalCard(settings: profile.sleepSettings),
                  const SizedBox(height: 16),
                  _NotificationSettingsCard(
                    settings: profile.notifications,
                    onPressed: () => _showMockAction('Настройки уведомлений'),
                  ),
                  const SizedBox(height: 16),
                  _IntegrationsCard(
                    integrations: profile.integrations,
                    onPressed: () => _showMockAction('Интеграции'),
                  ),
                  const SizedBox(height: 16),
                  _FriendsPlaceholderCard(friends: profile.friends),
                  const SizedBox(height: 16),
                  _DataAndPrivacyCard(
                    isPremium: profile.subscription.isPremium,
                    onExportPressed: () =>
                        _showMockAction('Экспорт AI-отчетов'),
                    onPrivacyPressed: () =>
                        _showMockAction('Настройки приватности'),
                  ),
                  const SizedBox(height: 16),
                  _EndpointReferenceCard(
                    endpoints: profile.endpointReferences,
                  ),
                  const SizedBox(height: 20),
                  _LogoutButton(
                    isLoading: state.isSigningOut,
                    onPressed: state.isSigningOut ? null : _signOut,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({
    required this.title,
    required this.subtitle,
    required this.isRefreshing,
  });

  final String title;
  final String subtitle;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (isRefreshing)
          const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.account,
  });

  final UserAccount account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      glowColor: const Color(0x337C5CFF),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primary,
            ),
            child: SizedBox.square(
              dimension: 58,
              child: Center(
                child: Text(
                  _initials(account.name),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  account.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusPill(
                      icon: Icons.verified_user_outlined,
                      label: _roleLabel(account.role),
                      color: AppColors.secondaryAccent,
                    ),
                    const _StatusPill(
                      icon: Icons.g_mobiledata,
                      label: 'Google OAuth',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    return parts.take(2).map((part) => part.substring(0, 1)).join();
  }

  static String _roleLabel(UserRole role) {
    return switch (role) {
      UserRole.user => 'User',
      UserRole.admin => 'Admin',
    };
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.onPressed,
  });

  final UserSubscription subscription;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = subscription.isPremium;
    final statusColor = isPremium ? AppColors.success : AppColors.warning;

    return GlassCard(
      borderRadius: 24,
      glowColor: isPremium ? const Color(0x266EE7B7) : const Color(0x26FBBF24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.workspace_premium_outlined,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _planLabel(subscription.plan),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subscriptionSubtitle(subscription),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                icon: Icons.circle,
                label: _statusLabel(subscription.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 18),
          GradientButton(
            label: isPremium ? 'Управлять Premium' : 'Перейти на Premium',
            icon: Icons.payments_outlined,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  static String _planLabel(SubscriptionPlan plan) {
    return switch (plan) {
      SubscriptionPlan.free => 'Free plan',
      SubscriptionPlan.premium => 'Premium plan',
    };
  }

  static String _statusLabel(SubscriptionStatus status) {
    return switch (status) {
      SubscriptionStatus.active => 'Active',
      SubscriptionStatus.expired => 'Expired',
      SubscriptionStatus.cancelled => 'Cancelled',
    };
  }

  static String _subscriptionSubtitle(UserSubscription subscription) {
    final provider = subscription.provider;
    final expiresAt = subscription.expiresAt;

    if (expiresAt == null) {
      return 'Provider: $provider';
    }

    return 'Provider: $provider · до ${_formatDate(expiresAt)}';
  }
}

class _SleepGoalCard extends StatelessWidget {
  const _SleepGoalCard({
    required this.settings,
  });

  final SleepProfileSettings settings;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.flag_outlined,
            title: 'Sleep goal',
            subtitle: 'Персональная цель и предпочитаемое окно сна.',
          ),
          const SizedBox(height: 16),
          _InfoRow(
            label: 'Цель',
            value: settings.sleepGoal,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Bedtime',
                  value: settings.preferredSleepTime,
                  icon: Icons.bedtime_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactMetric(
                  label: 'Wake time',
                  value: settings.preferredWakeTime,
                  icon: Icons.wb_sunny_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingsCard extends StatelessWidget {
  const _NotificationSettingsCard({
    required this.settings,
    required this.onPressed,
  });

  final NotificationSettings settings;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.notifications_outlined,
            title: 'Уведомления',
            subtitle: 'Push, smart reminders и напоминания внести данные.',
          ),
          const SizedBox(height: 16),
          _SettingsRow(
            label: 'Push reminders',
            value: settings.pushEnabled ? 'Включены' : 'Выключены',
            icon: Icons.notifications_active_outlined,
          ),
          _SettingsRow(
            label: 'Sleep reminder',
            value: settings.sleepReminderTime,
            icon: Icons.schedule_outlined,
          ),
          _SettingsRow(
            label: 'Smart reminders',
            value: settings.smartRemindersEnabled ? 'Premium active' : 'Off',
            icon: Icons.auto_awesome_outlined,
          ),
          _SettingsRow(
            label: 'Data entry reminder',
            value: settings.dataEntryReminderEnabled ? 'Включено' : 'Off',
            icon: Icons.edit_calendar_outlined,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _IntegrationsCard extends StatelessWidget {
  const _IntegrationsCard({
    required this.integrations,
    required this.onPressed,
  });

  final List<ConnectedIntegration> integrations;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.hub_outlined,
            title: 'Интеграции',
            subtitle: 'Подключения для авторизации и будущих источников сна.',
          ),
          const SizedBox(height: 14),
          for (final integration in integrations)
            _IntegrationRow(
              integration: integration,
              isLast: integration == integrations.last,
            ),
        ],
      ),
    );
  }
}

class _FriendsPlaceholderCard extends StatelessWidget {
  const _FriendsPlaceholderCard({
    required this.friends,
  });

  final FriendsPreview friends;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      glowColor: const Color(0x224DA8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.group_outlined,
            title: 'Друзья',
            subtitle: 'Зарезервировано под sharing и challenges.',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Connected',
                  value: '${friends.connectedCount}',
                  icon: Icons.people_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactMetric(
                  label: 'Invites',
                  value: '${friends.pendingInvites}',
                  icon: Icons.mark_email_unread_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Sharing',
                  value: friends.sharingEnabled ? 'On' : 'Off',
                  icon: Icons.ios_share_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CompactMetric(
                  label: 'Challenges',
                  value: '${friends.activeChallengesCount}',
                  icon: Icons.flag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            friends.note,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataAndPrivacyCard extends StatelessWidget {
  const _DataAndPrivacyCard({
    required this.isPremium,
    required this.onExportPressed,
    required this.onPrivacyPressed,
  });

  final bool isPremium;
  final VoidCallback onExportPressed;
  final VoidCallback onPrivacyPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.privacy_tip_outlined,
            title: 'Данные и приватность',
            subtitle: 'Экспорт отчетов и настройки доступа к данным.',
          ),
          const SizedBox(height: 12),
          _ActionRow(
            label: 'Экспорт AI-отчетов',
            value: isPremium ? 'Premium' : 'Premium locked',
            icon: Icons.ios_share_outlined,
            onPressed: onExportPressed,
          ),
          _ActionRow(
            label: 'Privacy settings',
            value: 'User data only',
            icon: Icons.lock_outline,
            onPressed: onPrivacyPressed,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _EndpointReferenceCard extends StatelessWidget {
  const _EndpointReferenceCard({
    required this.endpoints,
  });

  final List<ProfileEndpointReference> endpoints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      backgroundColor: AppColors.surfacePrimary.withOpacity(0.72),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          iconColor: AppColors.textSecondary,
          collapsedIconColor: AppColors.textMuted,
          title: Text(
            'Mock REST endpoints',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Text(
            'Пути оставлены для замены mock-данных на backend.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          children: [
            const SizedBox(height: 8),
            for (final endpoint in endpoints)
              _EndpointRow(
                endpoint: endpoint,
                isLast: endpoint == endpoints.last,
              ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.logout_outlined),
        label: Text(isLoading ? 'Выходим...' : 'Выйти из аккаунта'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.danger,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.secondaryAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: AppColors.secondaryAccent,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.secondaryAccent, size: 18),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isLast = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return _ListRowShell(
      icon: icon,
      isLast: isLast,
      child: _InfoRow(label: label, value: value),
    );
  }
}

class _IntegrationRow extends StatelessWidget {
  const _IntegrationRow({
    required this.integration,
    required this.isLast,
  });

  final ConnectedIntegration integration;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = integration.status == IntegrationStatus.connected
        ? AppColors.success
        : AppColors.warning;

    return _ListRowShell(
      icon: integration.status == IntegrationStatus.connected
          ? Icons.check_circle_outline
          : Icons.hourglass_empty_outlined,
      iconColor: color,
      isLast: isLast,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: integration.name,
            value: _integrationStatusLabel(integration.status),
          ),
          const SizedBox(height: 4),
          Text(
            integration.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }

  static String _integrationStatusLabel(IntegrationStatus status) {
    return switch (status) {
      IntegrationStatus.connected => 'Connected',
      IntegrationStatus.planned => 'Planned',
    };
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onPressed,
    this.isLast = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return _ListRowShell(
      icon: icon,
      isLast: isLast,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(child: _InfoRow(label: label, value: value)),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EndpointRow extends StatelessWidget {
  const _EndpointRow({
    required this.endpoint,
    required this.isLast,
  });

  final ProfileEndpointReference endpoint;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatusPill(
                    icon: Icons.swap_horiz,
                    label: endpoint.method,
                    color: AppColors.secondaryAccent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      endpoint.path,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                endpoint.mockPurpose,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListRowShell extends StatelessWidget {
  const _ListRowShell({
    required this.icon,
    required this.child,
    this.iconColor = AppColors.secondaryAccent,
    this.isLast = false,
  });

  final IconData icon;
  final Widget child;
  final Color iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');

  return '$day.$month.${date.year}';
}
