import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../data/models/jaap_profile.dart';
import '../../../state/history_controller.dart';
import '../../../state/jaap_controller.dart';

class ManualEntrySheet extends StatefulWidget {
  final HistoryController historyController;
  final JaapController jaapController;

  const ManualEntrySheet({
    super.key,
    required this.historyController,
    required this.jaapController,
  });

  @override
  State<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<ManualEntrySheet> {
  late JaapProfile _selectedProfile;
  final TextEditingController _countController = TextEditingController(text: '108');
  final DateTime _selectedDate = DateTime.now();

  static const List<int> presets = [27, 54, 108, 216, 540, 1008];

  @override
  void initState() {
    super.initState();
    _selectedProfile = widget.jaapController.activeProfile ??
        widget.jaapController.profiles.first;
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final count = int.tryParse(_countController.text.trim()) ?? 0;
    if (count <= 0) return;

    widget.historyController.addManualSession(
      profileId: _selectedProfile.id,
      profileName: _selectedProfile.name,
      count: count,
      malaSize: _selectedProfile.malaSize,
      date: _selectedDate,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 16),
          Text(
            l10n.translate('addPreviousJaap'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          // Profile dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedProfile.id,
            decoration: InputDecoration(
              labelText: l10n.translate('navJaap'),
              filled: true,
              fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: widget.jaapController.profiles.map((p) {
              return DropdownMenuItem(
                value: p.id,
                child: Text(p.name),
              );
            }).toList(),
            onChanged: (id) {
              if (id != null) {
                setState(() {
                  _selectedProfile = widget.jaapController.profiles.firstWhere((p) => p.id == id);
                });
              }
            },
          ),
          const SizedBox(height: 16),
          // Quick Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets.map((p) {
              return ActionChip(
                label: Text('+$p'),
                onPressed: () {
                  setState(() {
                    _countController.text = '$p';
                  });
                },
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // Custom Count Field
          TextField(
            controller: _countController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.translate('jaaps'),
              filled: true,
              fillColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _saveEntry,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                l10n.translate('add'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
