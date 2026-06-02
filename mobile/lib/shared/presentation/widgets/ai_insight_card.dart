import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'glass_card.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({
    required this.title,
    required this.explanation,
    this.recommendationPreview,
    this.confidenceLabel,
    this.disclaimer =
        'AI-рекомендації є wellness-підказками й не замінюють медичну консультацію.',
    this.aiLabel = 'AI-інсайт',
    super.key,
  });

  final String aiLabel;
  final String title;
  final String explanation;
  final String? recommendationPreview;
  final String? confidenceLabel;
  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppGradients.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: GlassCard(
          borderRadius: 23,
          borderColor: Colors.transparent,
          backgroundColor: AppColors.surfacePrimary,
          glowColor: const Color(0x337C5CFF),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppGradients.aiSurface,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: AppColors.secondaryAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        aiLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.secondaryAccent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      if (confidenceLabel != null)
                        Text(
                          confidenceLabel!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
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
                  if (recommendationPreview != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      recommendationPreview!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    disclaimer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
