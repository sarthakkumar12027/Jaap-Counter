import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../state/history_controller.dart';
import '../../state/jaap_controller.dart';

class StreakSheet extends StatelessWidget {
  final HistoryController historyController;
  final JaapController jaapController;

  const StreakSheet({
    super.key,
    required this.historyController,
    required this.jaapController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListenableBuilder(
      listenable: historyController,
      builder: (context, _) {
        final currentStreak = historyController.currentStreakDays;
        final bestStreak = historyController.bestStreakDays;
        final isTodayCompleted = historyController.isTodayMalaCompleted;
        final weekStatus = historyController.currentWeekStreakStatus;
        final totalMalas = historyController.allTimeTotalMalas;

        return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Flame Header & Current Streak Count
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTodayCompleted
                        ? const Color(0xFFFF9800).withValues(alpha: 0.16)
                        : (currentStreak > 0
                            ? const Color(0xFFFF9800).withValues(alpha: 0.08)
                            : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle)),
                    border: Border.all(
                      color: isTodayCompleted
                          ? const Color(0xFFFF9800).withValues(alpha: 0.4)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      size: 44,
                      color: isTodayCompleted
                          ? const Color(0xFFFF9800)
                          : (currentStreak > 0
                              ? const Color(0xFFFFB74D)
                              : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  '$currentStreak',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  l10n.translate('dayStreak'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Status banner (Today Completed vs Incomplete)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isTodayCompleted
                        ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                        : const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isTodayCompleted
                          ? const Color(0xFF4CAF50).withValues(alpha: 0.25)
                          : const Color(0xFFFF9800).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isTodayCompleted
                            ? Icons.check_circle_rounded
                            : Icons.schedule_rounded,
                        size: 22,
                        color: isTodayCompleted
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isTodayCompleted
                              ? l10n.translate('streakCompletedToday')
                              : l10n.translate('streakPendingToday'),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 7-Day Calendar Streak Dots
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.translate('thisWeek'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '1 Mala / Day',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weekStatus.map((day) {
                          final isDone = day.isCompleted;
                          final isToday = day.isToday;

                          Color circleColor;
                          Widget iconWidget;

                          if (isDone) {
                            circleColor = const Color(0xFFFF9800);
                            iconWidget = const Icon(Icons.local_fire_department_rounded, size: 16, color: Colors.white);
                          } else if (isToday) {
                            circleColor = Colors.transparent;
                            iconWidget = Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                            );
                          } else {
                            circleColor = isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle;
                            iconWidget = const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              Text(
                                day.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                                  color: isToday
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: circleColor,
                                  border: isToday && !isDone
                                      ? Border.all(color: primaryColor, width: 2)
                                      : (isDone ? null : Border.all(
                                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                          width: 1,
                                        )),
                                ),
                                child: Center(child: iconWidget),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Metrics Row: Best Streak & Total Malas
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.emoji_events_rounded, size: 16, color: Color(0xFFFFB74D)),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.translate('bestStreak'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$bestStreak ${l10n.translate('of') != 'of' ? '' : 'Days'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.radio_button_checked_rounded, size: 16, color: primaryColor),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.translate('malas'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$totalMalas',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Midnight Reset Info Footnote
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 15,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.translate('streakResetInfo'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
