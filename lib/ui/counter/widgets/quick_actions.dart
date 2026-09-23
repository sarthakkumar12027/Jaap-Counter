import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/jaap_controller.dart';

class QuickActionsSheet extends StatelessWidget {
  final JaapController jaapController;

  const QuickActionsSheet({
    super.key,
    required this.jaapController,
  });

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
            l10n.translate('quickActions'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAddButton(context, 10),
              const SizedBox(width: 8),
              _buildAddButton(context, 27),
              const SizedBox(width: 8),
              _buildAddButton(context, 108),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.undo_rounded),
            title: Text(l10n.translate('undo')),
            enabled: jaapController.canUndo,
            onTap: () {
              Navigator.pop(context);
              jaapController.undo();
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh_rounded, color: Colors.orangeAccent),
            title: Text(l10n.translate('resetCount')),
            onTap: () {
              Navigator.pop(context);
              jaapController.resetCurrentCount();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, int count) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          jaapController.addCountDirect(count);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          '+$count',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
