import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

class CompletionToast extends StatelessWidget {
  final bool visible;
  final String? text;
  final IconData? icon;
  final Color? iconColor;

  const CompletionToast({
    super.key,
    required this.visible,
    this.text,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.92,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE8ECE9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: (iconColor ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.check_circle_outline_rounded,
                size: 16,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                text ?? l10n.translate('malaComplete'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
