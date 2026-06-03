import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

class PremiumLockedCard extends StatelessWidget {
  const PremiumLockedCard({
    required this.featureName,
    required this.explanation,
    this.actionLabel = 'Оновити до Premium',
    this.onUpgradePressed,
    super.key,
  });

  final String featureName;
  final String explanation;
  final String actionLabel;
  final VoidCallback? onUpgradePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      glowColor: const Color(0x267C5CFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.lock_outline,
                color: AppColors.secondaryAccent,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            featureName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          GradientButton(
            label: actionLabel,
            icon: Icons.workspace_premium_outlined,
            onPressed: onUpgradePressed,
          ),
        ],
      ),
    );
  }
}
