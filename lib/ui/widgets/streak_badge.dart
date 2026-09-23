import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/history_controller.dart';
import '../../state/jaap_controller.dart';
import 'streak_sheet.dart';

class StreakBadge extends StatelessWidget {
  final HistoryController historyController;
  final JaapController jaapController;

  const StreakBadge({
    super.key,
    required this.historyController,
    required this.jaapController,
  });

  void _openStreakSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StreakSheet(
        historyController: historyController,
        jaapController: jaapController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: historyController,
      builder: (context, _) {
        final streak = historyController.currentStreakDays;
        final isTodayDone = historyController.isTodayMalaCompleted;

        final Color fireColor = isTodayDone
            ? const Color(0xFFFF9800)
            : (streak > 0 ? const Color(0xFFFFB74D) : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5));

        return InkWell(
          onTap: () => _openStreakSheet(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isTodayDone
                  ? const Color(0xFFFF9800).withValues(alpha: 0.12)
                  : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isTodayDone
                    ? const Color(0xFFFF9800).withValues(alpha: 0.35)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 18,
                  color: fireColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '$streak',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isTodayDone
                        ? const Color(0xFFFF9800)
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
