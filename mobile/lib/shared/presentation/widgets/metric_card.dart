import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'glass_card.dart';

enum MetricStatus {
  neutral,
  positive,
  warning,
  danger,
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.status = MetricStatus.neutral,
    this.statusLabel,
    this.trend,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final MetricStatus status;
  final String? statusLabel;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(status);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      glowColor: statusColor.withOpacity(0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    color: statusColor,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              if (statusLabel != null)
                _StatusBadge(
                  label: statusLabel!,
                  color: statusColor,
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null || trend != null) ...[
            const SizedBox(height: 8),
            Text(
              [subtitle, trend].whereType<String>().join(' • '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(MetricStatus status) {
    return switch (status) {
      MetricStatus.positive => AppColors.success,
      MetricStatus.warning => AppColors.warning,
      MetricStatus.danger => AppColors.danger,
      MetricStatus.neutral => AppColors.secondaryAccent,
    };
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
