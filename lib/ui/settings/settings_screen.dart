import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/user_settings.dart';
import '../../state/jaap_controller.dart';
import '../../state/settings_controller.dart';
import 'sankalp_screen.dart';
import 'widgets/sound_guide_sheet.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settingsController;
  final JaapController jaapController;
  final StorageService storageService;

  const SettingsScreen({
    super.key,
    required this.settingsController,
    required this.jaapController,
    required this.storageService,
  });

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentCode = settingsController.settings.localeCode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.translate('chooseLanguage'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: AppLocalizations.supportedLanguages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final lang = AppLocalizations.supportedLanguages[index];
                  final isSelected = currentCode == lang.code;

                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: isSelected
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                        : null,
                    title: Text(lang.nativeName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    subtitle: Text(lang.name, style: const TextStyle(fontSize: 12)),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () {
                      settingsController.setLocale(lang.code);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData(BuildContext context) {
    final jsonStr = storageService.exportAllData();
    Clipboard.setData(ClipboardData(text: jsonStr));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup JSON copied to clipboard! Save it safely.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _importData(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Paste your exported backup JSON below:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: '{ ... }',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final ok = await storageService.importData(controller.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'Backup restored successfully!' : 'Invalid backup JSON.'),
                  ),
                );
              }
            },
            child: const Text('Restore'),
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
      listenable: settingsController,
      builder: (context, _) {
        final settings = settingsController.settings;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.translate('navMore'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Sankalp Challenge Card Entry
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                tileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
                leading: Icon(
                  Icons.spa_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 26,
                ),
                title: Text(
                  l10n.translate('sankalp'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Set a 40-day practice commitment'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SankalpScreen(jaapController: jaapController),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('practice')),

              // Counter Style Segmented Control
              _buildSettingCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('counterStyle'),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<CounterStyle>(
                        segments: [
                          ButtonSegment(
                            value: CounterStyle.minimal,
                            label: Text(l10n.translate('styleMinimal')),
                          ),
                          ButtonSegment(
                            value: CounterStyle.mala,
                            label: Text(l10n.translate('styleMala')),
                          ),
                        ],
                        selected: {settings.counterStyle},
                        onSelectionChanged: (set) {
                          settingsController.setCounterStyle(set.first);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              _buildSettingCard(
                isDark: isDark,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Auto-start next Mala', style: TextStyle(fontSize: 14)),
                  value: settings.autoStartNextMala,
                  onChanged: settingsController.setAutoStartNextMala,
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('soundAndHaptics')),

              _buildSettingCard(
                isDark: isDark,
                child: Column(
                  children: [
                    // Tap Sound
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.translate('tapSound'), style: const TextStyle(fontSize: 14)),
                        DropdownButton<TapSoundType>(
                          value: settings.tapSound,
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(value: TapSoundType.off, child: Text(l10n.translate('noSound'))),
                            DropdownMenuItem(value: TapSoundType.soft, child: Text(l10n.translate('soft'))),
                            DropdownMenuItem(value: TapSoundType.wood, child: Text(l10n.translate('wood'))),
                            DropdownMenuItem(value: TapSoundType.bead, child: Text(l10n.translate('bead'))),
                          ],
                          onChanged: (val) {
                            if (val != null) settingsController.setTapSound(val);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    // Completion Sound
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.translate('completionSound'), style: const TextStyle(fontSize: 14)),
                        DropdownButton<CompletionSoundType>(
                          value: settings.completionSound,
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(value: CompletionSoundType.none, child: Text(l10n.translate('noSound'))),
                            DropdownMenuItem(value: CompletionSoundType.softBell, child: Text(l10n.translate('bell'))),
                            DropdownMenuItem(value: CompletionSoundType.templeBell, child: Text(l10n.translate('templeBell'))),
                          ],
                          onChanged: (val) {
                            if (val != null) settingsController.setCompletionSound(val);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    // Haptics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.translate('haptics'), style: const TextStyle(fontSize: 14)),
                        DropdownButton<HapticLevel>(
                          value: settings.hapticLevel,
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(value: HapticLevel.off, child: Text(l10n.translate('hapticOff'))),
                            DropdownMenuItem(value: HapticLevel.light, child: Text(l10n.translate('hapticLight'))),
                            DropdownMenuItem(value: HapticLevel.medium, child: Text(l10n.translate('hapticMedium'))),
                          ],
                          onChanged: (val) {
                            if (val != null) settingsController.setHapticLevel(val);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    // Sound Guide & Custom Audio Files
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const SoundGuideSheet(),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.queue_music_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sound Files & Indications',
                                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'View all app audio files & custom paths',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
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
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('appearance')),

              _buildSettingCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.translate('theme'), style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: [
                          ButtonSegment(value: ThemeMode.light, label: Text(l10n.translate('themeLight'))),
                          ButtonSegment(value: ThemeMode.dark, label: Text(l10n.translate('themeDark'))),
                          ButtonSegment(value: ThemeMode.system, label: Text(l10n.translate('themeSystem'))),
                        ],
                        selected: {settings.themeMode},
                        onSelectionChanged: (set) => settingsController.setThemeMode(set.first),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.translate('accent'), style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppColors.accents.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final accent = AppColors.accents[index];
                          final isSel = settings.accentIndex == index;
                          return GestureDetector(
                            onTap: () => settingsController.setAccentIndex(index),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: accent.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSel ? Colors.white : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: isSel
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('language')),

              _buildSettingCard(
                isDark: isDark,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.translate_rounded),
                  title: Text(l10n.translate('language')),
                  subtitle: Text(
                    AppLocalizations.supportedLanguages
                        .firstWhere((l) => l.code == settings.localeCode,
                            orElse: () => AppLocalizations.supportedLanguages.first)
                        .nativeName,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLanguagePicker(context),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('data')),

              _buildSettingCard(
                isDark: isDark,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.upload_file_rounded),
                      title: Text(l10n.translate('backupData')),
                      onTap: () => _exportData(context),
                    ),
                    const Divider(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.download_rounded),
                      title: Text(l10n.translate('restoreData')),
                      onTap: () => _importData(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle(context, l10n.translate('about')),

              _buildSettingCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.spa_rounded,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jaap Counter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${l10n.translate('version')} 1.0.0',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Developed by Sarthak Kumar',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      l10n.translate('privacyNotice'),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required Widget child, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: child,
    );
  }
}
