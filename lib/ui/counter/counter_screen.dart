import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/user_settings.dart';


import '../../state/history_controller.dart';
import '../../state/jaap_controller.dart';
import '../../state/settings_controller.dart';
import '../focus/focus_mode_screen.dart';
import '../meditation/meditation_screen.dart';
import '../widgets/completion_toast.dart';
import '../widgets/mala_beads.dart';
import '../widgets/minimal_ring.dart';
import '../widgets/streak_badge.dart';
import 'widgets/profile_sheet.dart';
import 'widgets/quick_actions.dart';

class CounterScreen extends StatefulWidget {
  final JaapController jaapController;
  final SettingsController settingsController;
  final HistoryController? historyController;

  const CounterScreen({
    super.key,
    required this.jaapController,
    required this.settingsController,
    this.historyController,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> with SingleTickerProviderStateMixin {
  late AnimationController _tapAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _tapAnimController, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _tapAnimController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _tapAnimController.forward().then((_) => _tapAnimController.reverse());
    widget.jaapController.increment();
  }

  void _openProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (context) => ProfileSheet(jaapController: widget.jaapController),
    );
  }

  void _openQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (context) => QuickActionsSheet(jaapController: widget.jaapController),
    );
  }

  void _openFocusMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FocusModeScreen(jaapController: widget.jaapController),
      ),
    );
  }

  void _openMeditation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MeditationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: Listenable.merge([widget.jaapController, widget.settingsController]),
      builder: (context, _) {
        final profile = widget.jaapController.activeProfile;

        if (profile == null) {
          return _buildEmptyState(context, l10n);
        }

        final currentCount = profile.currentCount;
        final malaSize = profile.malaSize > 0 ? profile.malaSize : 108;
        final totalMalas = profile.totalMalasCompleted;
        final progress = (currentCount / malaSize).clamp(0.0, 1.0);
        final counterStyle = widget.settingsController.counterStyle;
        final accentColor = AppColors.parseHex(
          profile.accentColorHex,
          fallback: widget.settingsController.currentAccent.color,
        );
        final isMalaPulse = widget.jaapController.isMalaCompletedPulse;

        // Daily Goal computation
        final todayCount = widget.jaapController.getTodayCountForActiveProfile();
        final dailyGoal = profile.dailyGoal;
        final goalProgress = dailyGoal > 0 ? (todayCount / dailyGoal).clamp(0.0, 1.0) : 0.0;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top Header Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Profile Switcher Pill
                      Flexible(
                        child: InkWell(
                          onTap: _openProfileSheet,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    profile.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.historyController != null) ...[
                        const SizedBox(width: 8),
                        StreakBadge(
                          historyController: widget.historyController!,
                          jaapController: widget.jaapController,
                        ),
                      ],
                      const SizedBox(width: 4),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.self_improvement_rounded, size: 22),
                        tooltip: l10n.translate('meditation'),
                        onPressed: _openMeditation,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.fullscreen_rounded, size: 24),
                        tooltip: l10n.translate('focusMode'),
                        onPressed: _openFocusMode,
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.more_horiz_rounded, size: 22),
                        tooltip: l10n.translate('quickActions'),
                        onPressed: _openQuickActions,
                      ),
                    ],
                  ),
                ),

                // Main Touch Counter Area (tap anywhere inside central area)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _handleTap,
                    onLongPress: _openQuickActions,
                    onHorizontalDragEnd: (details) {
                      // Swipe left to undo
                      if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
                        widget.jaapController.undo();
                      }
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Mantra Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              profile.originalText.isNotEmpty ? profile.originalText : profile.name,
                              textAlign: TextAlign.center,
                              style: AppTypography.mantraTitle(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.originalText.isNotEmpty && profile.originalText != profile.name) ...[
                            const SizedBox(height: 4),
                            Text(
                              profile.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),

                          // Visualizer (Minimal Ring or Bead Mode)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 230,
                                height: 230,
                                child: counterStyle == CounterStyle.mala
                                    ? CustomPaint(
                                        painter: MalaBeadsPainter(
                                          currentCount: currentCount,
                                          totalBeads: malaSize,
                                          activeColor: accentColor,
                                          inactiveColor: isDark
                                              ? AppColors.darkSurfaceSubtle
                                              : AppColors.lightSurfaceSubtle,
                                        ),
                                      )
                                    : CustomPaint(
                                        painter: MinimalRingPainter(
                                          progress: progress,
                                          activeColor: accentColor,
                                          trackColor: isDark
                                              ? AppColors.darkSurfaceSubtle
                                              : AppColors.lightSurfaceSubtle,
                                          strokeWidth: 3.5,
                                        ),
                                      ),
                              ),

                              // Big Center Count
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$currentCount',
                                      style: AppTypography.counterDisplay(context),
                                    ),
                                    Text(
                                      '${l10n.translate('of')} $malaSize',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    if (totalMalas > 0) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${l10n.translate('mala')} ${totalMalas + 1}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          // Mala Completion Pulse Toast / Streak Celebration
                          CompletionToast(
                            visible: isMalaPulse,
                            icon: widget.jaapController.isStreakIncreased
                                ? Icons.local_fire_department_rounded
                                : Icons.check_circle_outline_rounded,
                            iconColor: widget.jaapController.isStreakIncreased
                                ? const Color(0xFFFF9800)
                                : accentColor,
                            text: widget.jaapController.isStreakIncreased
                                ? '${l10n.translate('streakIncreased')} 🔥'
                                : l10n.translate('malaComplete'),
                          ),

                          const SizedBox(height: 20),
                          // Daily Goal Progress Bar
                          if (dailyGoal > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l10n.translate('todaysPractice'),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        '$todayCount / $dailyGoal',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: goalProgress,
                                      minHeight: 4,
                                      backgroundColor: isDark
                                          ? AppColors.darkSurfaceSubtle
                                          : AppColors.lightSurfaceSubtle,
                                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Control Area: Quiet Undo and Tap hint
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        l10n.translate('tapToCount'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      if (widget.jaapController.canUndo)
                        TextButton.icon(
                          onPressed: widget.jaapController.undo,
                          icon: const Icon(Icons.undo_rounded, size: 16),
                          label: Text(
                            l10n.translate('undo'),
                            style: const TextStyle(fontSize: 13),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.translate('beginPractice'),
              style: AppTypography.headlineMedium(context),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('createFirstJaap'),
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(context),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _openProfileSheet,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.translate('createJaap')),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
