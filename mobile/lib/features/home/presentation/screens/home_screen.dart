import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _summary = _HomeSleepSummary(
    userName: 'Олено',
    sleepScore: '84',
    sleepScoreSubtitle: 'Добре відновлення',
    sleepDuration: '7 год 32 хв',
    sleepDurationSubtitle: 'Близько до цілі',
    recovery: '78%',
    recoverySubtitle: 'Стабільний ресурс',
    sleepEfficiency: '91%',
    sleepEfficiencySubtitle: 'Мало пробуджень',
    lastSleepWindow: '23:18 - 07:02',
    lastSleepNote: 'Останній сон був рівним, із коротким нічним пробудженням.',
    aiInsightTitle: 'Якість сну трохи знизилась цього тижня',
    aiInsightExplanation:
        'За демо-даними зниження може бути повʼязане з нерегулярним часом засинання та довшим вечірнім екранним часом.',
    aiRecommendation:
        'Спробуйте 30 хвилин без екранів перед сном і поверніться до стабільного вікна засинання.',
  );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeader(
                greeting: '${_greetingFor(now)}, ${_summary.userName}',
                dateLabel: _formatUkrainianDate(now),
              ),
              const SizedBox(height: 24),
              const _LastSleepSummaryCard(summary: _summary),
              const SizedBox(height: 20),
              const _MetricGrid(summary: _summary),
              const SizedBox(height: 20),
              AiInsightCard(
                title: _summary.aiInsightTitle,
                explanation: _summary.aiInsightExplanation,
                recommendationPreview: _summary.aiRecommendation,
                confidenceLabel: 'Демо-дані',
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Додати запис сну',
                icon: Icons.add_circle_outline,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _greetingFor(DateTime dateTime) {
    final hour = dateTime.hour;

    if (hour < 12) {
      return 'Доброго ранку';
    }

    if (hour < 18) {
      return 'Добрий день';
    }

    return 'Добрий вечір';
  }

  static String _formatUkrainianDate(DateTime dateTime) {
    const weekdays = [
      'понеділок',
      'вівторок',
      'середа',
      'четвер',
      'пʼятниця',
      'субота',
      'неділя',
    ];
    const months = [
      'січня',
      'лютого',
      'березня',
      'квітня',
      'травня',
      'червня',
      'липня',
      'серпня',
      'вересня',
      'жовтня',
      'листопада',
      'грудня',
    ];

    return '${weekdays[dateTime.weekday - 1]}, '
        '${dateTime.day} ${months[dateTime.month - 1]}';
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.greeting,
    required this.dateLabel,
  });

  final String greeting;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dateLabel,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _LastSleepSummaryCard extends StatelessWidget {
  const _LastSleepSummaryCard({
    required this.summary,
  });

  final _HomeSleepSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      glowColor: const Color(0x224DA8FF),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.secondaryAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.dark_mode_outlined,
                color: AppColors.secondaryAccent,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Останній сон',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary.lastSleepWindow,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  summary.lastSleepNote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({
    required this.summary,
  });

  final _HomeSleepSummary summary;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      MetricCard(
        title: 'Sleep Score',
        value: summary.sleepScore,
        subtitle: summary.sleepScoreSubtitle,
        status: MetricStatus.positive,
        statusLabel: 'Добре',
        trend: '+4 за ніч',
        icon: Icons.shield_moon_outlined,
      ),
      MetricCard(
        title: 'Тривалість сну',
        value: summary.sleepDuration,
        subtitle: summary.sleepDurationSubtitle,
        status: MetricStatus.neutral,
        statusLabel: 'Ціль',
        trend: '+18 хв',
        icon: Icons.schedule_outlined,
      ),
      MetricCard(
        title: 'Відновлення',
        value: summary.recovery,
        subtitle: summary.recoverySubtitle,
        status: MetricStatus.positive,
        statusLabel: 'Стабільно',
        trend: '+3%',
        icon: Icons.favorite_border,
      ),
      MetricCard(
        title: 'Ефективність сну',
        value: summary.sleepEfficiency,
        subtitle: summary.sleepEfficiencySubtitle,
        status: MetricStatus.positive,
        statusLabel: 'Висока',
        trend: '+2%',
        icon: Icons.bolt_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 360;
        final crossAxisCount = useTwoColumns ? 2 : 1;
        final childAspectRatio = useTwoColumns ? 0.94 : 1.9;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: metrics,
        );
      },
    );
  }
}

class _HomeSleepSummary {
  const _HomeSleepSummary({
    required this.userName,
    required this.sleepScore,
    required this.sleepScoreSubtitle,
    required this.sleepDuration,
    required this.sleepDurationSubtitle,
    required this.recovery,
    required this.recoverySubtitle,
    required this.sleepEfficiency,
    required this.sleepEfficiencySubtitle,
    required this.lastSleepWindow,
    required this.lastSleepNote,
    required this.aiInsightTitle,
    required this.aiInsightExplanation,
    required this.aiRecommendation,
  });

  final String userName;
  final String sleepScore;
  final String sleepScoreSubtitle;
  final String sleepDuration;
  final String sleepDurationSubtitle;
  final String recovery;
  final String recoverySubtitle;
  final String sleepEfficiency;
  final String sleepEfficiencySubtitle;
  final String lastSleepWindow;
  final String lastSleepNote;
  final String aiInsightTitle;
  final String aiInsightExplanation;
  final String aiRecommendation;
}
