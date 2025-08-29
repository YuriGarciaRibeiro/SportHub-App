import 'package:flutter/material.dart';

/// AppLogo
/// Reusable logo widget used across Splash and Login screens.
/// - Adapts to theme by default (primary background, onPrimary icon)
/// - Can be customized via backgroundColor/iconColor/size
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 100,
    this.borderRadius = 20,
    this.icon = Icons.sports_soccer,
    this.backgroundColor,
    this.iconColor,
    this.shadowOpacity = 0.1,
  });

  final double size;
  final double borderRadius;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double shadowOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color bg = backgroundColor ?? theme.primaryColor;
    final Color fg = iconColor ?? (backgroundColor == null
        ? colorScheme.onPrimary
        : theme.primaryColor);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(shadowOpacity),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: fg,
      ),
    );
  }
}
