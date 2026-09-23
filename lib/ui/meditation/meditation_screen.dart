import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../state/meditation_controller.dart';
import '../widgets/minimal_ring.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  final MeditationController _controller = MeditationController();
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    // 8-second calm breathing cycle (4s in, 4s out)
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.88, end: 1.08).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showCustomDurationDialog(BuildContext context) {
    final textController = TextEditingController(text: '${_controller.selectedMinutes}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Meditation Duration',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter meditation time in minutes:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                suffixText: 'mins',
                hintText: 'e.g. 45',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [45, 60, 90, 120].map((mins) {
                return ActionChip(
                  label: Text('$mins m'),
                  onPressed: () {
                    textController.text = '$mins';
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(textController.text.trim());
              if (val != null && val > 0 && val <= 360) {
                _controller.setDuration(val);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Set Time'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final isRunning = _controller.isRunning;
        final isMuted = _controller.isMuted;
        final defaultPresets = [5, 10, 15, 20, 30];
        final currentMins = _controller.selectedMinutes;
        final isCustomPreset = !defaultPresets.contains(currentMins);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                _controller.stopMeditation();
                Navigator.pop(context);
              },
            ),
            title: Text(
              l10n.translate('meditation'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: isMuted
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
                tooltip: isMuted ? 'Unmute Bell Sound' : 'Mute Bell Sound',
                onPressed: _controller.toggleMute,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  // Circular Breathing & Timer visualization
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated Breathing Aura
                        if (isRunning)
                          ScaleTransition(
                            scale: _breathAnimation,
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
                              ),
                            ),
                          ),

                        // Progress Ring
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CustomPaint(
                            painter: MinimalRingPainter(
                              progress: isRunning ? _controller.progressPercentage : 0.0,
                              activeColor: Theme.of(context).colorScheme.primary,
                              trackColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                              strokeWidth: 3.0,
                            ),
                          ),
                        ),

                        // Inner Timer and Text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _controller.formattedTimeRemaining,
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isRunning ? l10n.translate('breatheSoftly') : '${_controller.selectedMinutes} min',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mute / Sound Status Toggle Bar
                  TextButton.icon(
                    onPressed: _controller.toggleMute,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: (isMuted
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary)
                          .withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: Icon(
                      isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      size: 18,
                      color: isMuted
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      isMuted ? 'Sound Muted' : 'Continuous Bell Sound On',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isMuted
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Horizontally Scrollable Preset Duration Buttons + Manual Custom (+) Button
                  if (!isRunning) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...defaultPresets.map((mins) {
                            final isSel = currentMins == mins;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text('$mins m'),
                                selected: isSel,
                                onSelected: (_) => _controller.setDuration(mins),
                                selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                side: BorderSide(
                                  color: isSel
                                      ? Theme.of(context).colorScheme.primary
                                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                                showCheckmark: false,
                              ),
                            );
                          }),
                          if (isCustomPreset)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text('$currentMins m'),
                                selected: true,
                                onSelected: (_) {},
                                selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                showCheckmark: false,
                              ),
                            ),
                          // Manual Add Custom Time Button (+)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ActionChip(
                              avatar: Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              label: const Text('Custom'),
                              onPressed: () => _showCustomDurationDialog(context),
                              side: BorderSide(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: isRunning ? _controller.stopMeditation : _controller.startMeditation,
                      style: FilledButton.styleFrom(
                        backgroundColor: isRunning
                            ? (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle)
                            : Theme.of(context).colorScheme.primary,
                        foregroundColor: isRunning
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        isRunning ? l10n.translate('endSession') : 'Begin Meditation',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
