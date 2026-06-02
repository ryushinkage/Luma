import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
    this.backgroundColor = AppColors.glassSurface,
    this.borderColor = AppColors.border,
    this.glowColor,
    this.onPressed,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color? glowColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: glowColor ?? const Color(0x1A4DA8FF),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onPressed == null) {
      return content;
    }

    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: content,
        ),
      ),
    );
  }
}
