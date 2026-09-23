import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';

import '../../state/history_controller.dart';
import '../../state/jaap_controller.dart';
import '../widgets/streak_sheet.dart';
import 'widgets/manual_entry_sheet.dart';
import 'widgets/weekly_chart.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController historyController;
  final JaapController jaapController;

  const HistoryScreen({
    super.key,
    required this.historyController,
    required this.jaapController,
  });

  void _openManualEntry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (_) => ManualEntrySheet(
        historyController: historyController,
        jaapController: jaapController,
      ),
    );
  }

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
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: historyController,
      builder: (context, _) {
        final streak = historyController.currentStreakDays;
        final grouped = historyController.groupedSessionsByDate;
        final profiles = jaapController.profiles;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.translate('navHistory'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            actions: [
              TextButton.icon(
                onPressed: () => _openManualEntry(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.translate('manualEntry')),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter row if multiple profiles exist
                if (profiles.length > 1) ...[
                  Row(
                    children: [
                      Text(
                        'Filter:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String?>(
                        value: historyController.selectedProfileFilter,
                        underline: const SizedBox(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All Jaaps'),
                          ),
                          ...profiles.map((p) => DropdownMenuItem<String?>(
                                value: p.id,
                                child: Text(p.name),
                              )),
                        ],
                        onChanged: historyController.setProfileFilter,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Streak Banner (Tappable to view detailed breakdown)
                InkWell(
                  onTap: () => _openStreakSheet(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 22,
                          color: Color(0xFFFF9800),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$streak ${l10n.translate('dayStreak')}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Summary 3-Column Metric Cards
                Row(
                  children: [
                    _buildStatCard(
                      context,
                      title: l10n.translate('todaysPractice'),
                      primaryValue: '${historyController.todayTotalJaaps}',
                      subValue: '${historyController.todayTotalMalas} ${l10n.translate('malas')}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      context,
                      title: l10n.translate('thisWeek'),
                      primaryValue: '${historyController.weekTotalJaaps}',
                      subValue: '${historyController.weekTotalMalas} ${l10n.translate('malas')}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      context,
                      title: l10n.translate('allTime'),
                      primaryValue: '${historyController.allTimeTotalJaaps}',
                      subValue: '${historyController.allTimeTotalMalas} ${l10n.translate('malas')}',
                      isDark: isDark,
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Weekly Bar Chart
                WeeklyChart(data: historyController.weeklyBarData),

                const SizedBox(height: 24),
                Text(
                  'Practice History',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                // Grouped Date Session List
                if (grouped.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Center(
                      child: Text(
                        'No practice history yet.\nBegin chanting on the Jaap tab.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: grouped.keys.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final date = grouped.keys.elementAt(index);
                      final sessions = grouped[date]!;
                      final totalDayCount = sessions.fold(0, (sum, s) => sum + s.count);
                      final totalDayMalas = sessions.fold(0, (sum, s) => sum + s.malaCompleted);

                      final dateLabel = _formatDateHeader(date);

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
                                  dateLabel,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '$totalDayCount ${l10n.translate('jaaps')}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalDayMalas ${l10n.translate('malas')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            ...sessions.map((s) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        s.jaapProfileName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      if (s.isManualEntry) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppColors.darkSurfaceSubtle
                                                : AppColors.lightSurfaceSubtle,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Manual',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                      const Spacer(),
                                      Text(
                                        '+${s.count}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String primaryValue,
    required String subValue,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              primaryValue,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subValue,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('MMM d, yyyy').format(date);
  }
}
