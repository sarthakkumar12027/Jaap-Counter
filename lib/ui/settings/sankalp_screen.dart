import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/sankalp_goal.dart';
import '../../state/jaap_controller.dart';

class SankalpScreen extends StatefulWidget {
  final JaapController jaapController;

  const SankalpScreen({
    super.key,
    required this.jaapController,
  });

  @override
  State<SankalpScreen> createState() => _SankalpScreenState();
}

class _SankalpScreenState extends State<SankalpScreen> {
  final TextEditingController _targetController = TextEditingController(text: '43200');
  final TextEditingController _daysController = TextEditingController(text: '40');
  bool _hasActiveSankalp = false;
  SankalpGoal? _currentSankalp;

  @override
  void initState() {
    super.initState();
    // Default 40 days of 1080/day = 43,200
    final profile = widget.jaapController.activeProfile;
    if (profile != null) {
      _currentSankalp = SankalpGoal(
        id: 'sankalp_active',
        jaapProfileId: profile.id,
        title: '40-Day Sankalp (${profile.name})',
        targetCount: 43200,
        currentCount: profile.totalLifetimeCount,
        totalDays: 40,
        startDate: DateTime.now().subtract(const Duration(days: 4)),
        endDate: DateTime.now().add(const Duration(days: 36)),
      );
      _hasActiveSankalp = true;
    }
  }

  @override
  void dispose() {
    _targetController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('sankalp'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasActiveSankalp && _currentSankalp != null) ...[
              // Active Sankalp Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currentSankalp!.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Day ${_currentSankalp!.currentDay} / ${_currentSankalp!.totalDays}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_currentSankalp!.currentCount} / ${_currentSankalp!.targetCount}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${(_currentSankalp!.progressPercentage * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _currentSankalp!.progressPercentage,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_currentSankalp!.daysRemaining} days remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

            Text(
              'Set New Sankalp',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'A Sankalp is a sacred commitment to complete a specific number of repetitions over a duration (e.g. 40 days).',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration (Days)',
                hintText: '40',
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Target Jaaps',
                hintText: '43200',
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  final days = int.tryParse(_daysController.text.trim()) ?? 40;
                  final target = int.tryParse(_targetController.text.trim()) ?? 43200;
                  final profile = widget.jaapController.activeProfile;

                  if (profile != null) {
                    setState(() {
                      _currentSankalp = SankalpGoal(
                        id: 'sankalp_${DateTime.now().millisecondsSinceEpoch}',
                        jaapProfileId: profile.id,
                        title: '$days-Day Sankalp (${profile.name})',
                        targetCount: target,
                        currentCount: 0,
                        totalDays: days,
                        startDate: DateTime.now(),
                        endDate: DateTime.now().add(Duration(days: days)),
                      );
                      _hasActiveSankalp = true;
                    });
                  }
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Start Sankalp', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
