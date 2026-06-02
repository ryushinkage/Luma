import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final button = Opacity(
      opacity: enabled ? 1 : 0.64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: enabled
              ? AppGradients.primary
              : const LinearGradient(
                  colors: [
                    AppColors.surfaceSecondary,
                    AppColors.surfacePrimary,
                  ],
                ),
        ),
        child: TextButton(
          onPressed: enabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            disabledForegroundColor: AppColors.textMuted,
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textPrimary,
                  ),
                )
              else if (icon != null)
                Icon(icon, size: 18),
              if (isLoading || icon != null) const SizedBox(width: 10),
              Text(label),
            ],
          ),
        ),
      ),
    );

    if (!fullWidth) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}
