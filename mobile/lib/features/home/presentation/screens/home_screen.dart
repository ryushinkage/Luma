import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/presentation/widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _summary = _HomeSleepSummary(
    userName: 'Елена',
    sleepScore: '82',
    qualityScore: '78%',
    duration: '7ч 15м',
    efficiency: '88%',
    regularity: '72%',
    sleepDebt: '45м',
    recovery: '76%',
    sleepWindow: '23:35 - 06:50',
    sleepDate: 'Последняя ночь',
    source: 'Manual',
    wakeTimeMinutes: 18,
    aiInsightTitle: 'Режим стал стабильнее, но долг сна еще сохраняется',
    aiInsightExplanation:
        'За последнюю неделю сон ближе к целевому окну, но в днях с поздним экранным временем качество ниже. Это выглядит как wellness-паттерн, а не медицинский вывод.',
    aiRecommendation:
        'На 3 вечера удерживайте отход ко сну в пределах 30 минут и сократите экран перед сном до 45 минут.',
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
                dateLabel: _formatRussianDate(now),
              ),
              const SizedBox(height: 24),
              const _TodayScoreCard(summary: _summary),
              const SizedBox(height: 16),
              const _MetricGrid(summary: _summary),
              const SizedBox(height: 16),
              const _SleepPatternCard(summary: _summary),
              const SizedBox(height: 16),
              AiInsightCard(
                aiLabel: 'AI sleep-coach',
                title: _summary.aiInsightTitle,
                explanation: _summary.aiInsightExplanation,
                recommendationPreview: _summary.aiRecommendation,
                confidenceLabel: 'Demo analytics',
                disclaimer:
                    'AI-инсайты являются wellness-рекомендациями и не заменяют медицинскую консультацию.',
              ),
              const SizedBox(height: 16),
              _RiskIndicatorCard(
                title: 'Индикатор внимания',
                value: 'Возможный sleep debt pattern',
                description:
                    'Система отслеживает накопленный дефицит сна относительно цели. Это предупреждение о паттерне, не диагноз.',
              ),
              const SizedBox(height: 16),
              PremiumLockedCard(
                featureName: 'Корреляции привычек и качества сна',
                explanation:
                    'Premium откроет долгосрочные связи между кофеином, стрессом, экранным временем и качеством сна.',
                actionLabel: 'Подготовить Premium',
                onUpgradePressed: () {},
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Добавить запись сна',
                icon: Icons.add_circle_outline,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.addSleepEntry);
                },
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
      return 'Доброе утро';
    }

    if (hour < 18) {
      return 'Добрый день';
    }

    return 'Добрый вечер';
  }

  static String _formatRussianDate(DateTime dateTime) {
    const weekdays = [
      'понедельник',
      'вторник',
      'среда',
      'четверг',
      'пятница',
      'суббота',
      'воскресенье',
    ];
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
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

class _TodayScoreCard extends StatelessWidget {
  const _TodayScoreCard({
    required this.summary,
  });

  final _HomeSleepSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      glowColor: const Color(0x337C5CFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today sleep analytics',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.secondaryAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      summary.sleepScore,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Sleep score',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _ScoreRing(value: 0.82),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(
            icon: Icons.bedtime_outlined,
            label: summary.sleepDate,
            value: summary.sleepWindow,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.sensors_outlined,
            label: 'Источник данных',
            value: summary.source,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.visibility_outlined,
            label: 'Awake time',
            value: '${summary.wakeTimeMinutes} мин',
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 86,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 8,
            backgroundColor: AppColors.border,
            color: AppColors.secondaryAccent,
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Icon(
              Icons.shield_moon_outlined,
              color: AppColors.textPrimary.withOpacity(0.9),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
        title: 'Длительность',
        value: summary.duration,
        subtitle: 'Базовая daily metric',
        status: MetricStatus.positive,
        statusLabel: 'Цель',
        trend: '+15м',
        icon: Icons.schedule_outlined,
      ),
      MetricCard(
        title: 'Качество',
        value: summary.qualityScore,
        subtitle: 'Subjective + metrics',
        status: MetricStatus.neutral,
        statusLabel: 'Stable',
        trend: '-3%',
        icon: Icons.auto_graph_outlined,
      ),
      MetricCard(
        title: 'Эффективность',
        value: summary.efficiency,
        subtitle: 'Сон / время в постели',
        status: MetricStatus.positive,
        statusLabel: 'Good',
        trend: '+2%',
        icon: Icons.bolt_outlined,
      ),
      MetricCard(
        title: 'Sleep debt',
        value: summary.sleepDebt,
        subtitle: 'Относительно цели',
        status: MetricStatus.warning,
        statusLabel: 'Attention',
        trend: '-10м',
        icon: Icons.timelapse_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 360;

        return GridView.count(
          crossAxisCount: useTwoColumns ? 2 : 1,
          childAspectRatio: useTwoColumns ? 0.92 : 1.9,
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

class _SleepPatternCard extends StatelessWidget {
  const _SleepPatternCard({
    required this.summary,
  });

  final _HomeSleepSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Регулярность и восстановление',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _ProgressLine(
            label: 'Regularity score',
            valueLabel: summary.regularity,
            value: 0.72,
          ),
          const SizedBox(height: 14),
          _ProgressLine(
            label: 'Recovery',
            valueLabel: summary.recovery,
            value: 0.76,
          ),
          const SizedBox(height: 18),
          _MiniTrendPreview(),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.valueLabel,
    required this.value,
  });

  final String label;
  final String valueLabel;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              valueLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AppColors.border,
            color: AppColors.secondaryAccent,
          ),
        ),
      ],
    );
  }
}

class _MiniTrendPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bars = [0.42, 0.58, 0.54, 0.72, 0.66, 0.78, 0.74];

    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final bar in bars) ...[
            Expanded(
              child: FractionallySizedBox(
                heightFactor: bar,
                alignment: Alignment.bottomCenter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: AppGradients.primary,
                  ),
                ),
              ),
            ),
            if (bar != bars.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _RiskIndicatorCard extends StatelessWidget {
  const _RiskIndicatorCard({
    required this.title,
    required this.value,
    required this.description,
  });

  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      glowColor: AppColors.warning.withOpacity(0.12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.info_outline,
                color: AppColors.warning,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
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

class _HomeSleepSummary {
  const _HomeSleepSummary({
    required this.userName,
    required this.sleepScore,
    required this.qualityScore,
    required this.duration,
    required this.efficiency,
    required this.regularity,
    required this.sleepDebt,
    required this.recovery,
    required this.sleepWindow,
    required this.sleepDate,
    required this.source,
    required this.wakeTimeMinutes,
    required this.aiInsightTitle,
    required this.aiInsightExplanation,
    required this.aiRecommendation,
  });

  final String userName;
  final String sleepScore;
  final String qualityScore;
  final String duration;
  final String efficiency;
  final String regularity;
  final String sleepDebt;
  final String recovery;
  final String sleepWindow;
  final String sleepDate;
  final String source;
  final int wakeTimeMinutes;
  final String aiInsightTitle;
  final String aiInsightExplanation;
  final String aiRecommendation;
}
