import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EmptyStateIcon(icon: icon),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 28),
            GradientButton(
              label: actionLabel!,
              onPressed: onActionPressed,
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyStateIcon extends StatelessWidget {
  const _EmptyStateIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppGradients.primary,
        boxShadow: const [
          BoxShadow(
            color: Color(0x407C5CFF),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: AppColors.textPrimary,
        size: 30,
      ),
    );
  }
}
