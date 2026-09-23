import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/jaap_profile.dart';
import '../../state/jaap_controller.dart';
import '../../state/settings_controller.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  final SettingsController settingsController;
  final JaapController jaapController;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
    required this.settingsController,
    required this.jaapController,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Screen 2: Language
  String _selectedLanguage = 'en';

  // Screen 3: First Jaap setup
  final TextEditingController _mantraController = TextEditingController(text: 'Radhe Radhe');
  int _selectedMalaSize = 108;
  final TextEditingController _customMalaController = TextEditingController(text: '108');
  bool _isCustomMala = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.settingsController.settings.localeCode;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mantraController.dispose();
    _customMalaController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding({bool skipJaap = false}) async {
    await widget.settingsController.setLocale(_selectedLanguage);

    if (!skipJaap && _mantraController.text.trim().isNotEmpty) {
      int mala = _selectedMalaSize;
      if (_isCustomMala) {
        mala = int.tryParse(_customMalaController.text.trim()) ?? 108;
      }
      if (mala <= 0) mala = 108;

      final customName = _mantraController.text.trim();
      final newProfile = JaapProfile(
        id: 'jaap_${DateTime.now().millisecondsSinceEpoch}',
        name: customName,
        originalText: customName,
        transliteration: customName,
        malaSize: mala,
        dailyGoal: mala,
        accentColorHex: '0xFF5F7D6B',
        createdAt: DateTime.now(),
      );

      await widget.jaapController.addProfile(newProfile);
    }

    await widget.settingsController.completeOnboarding();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top minimal step indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  final isDone = index < _currentPage;
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isDone || isActive
                            ? Theme.of(context).colorScheme.primary
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildWelcomeStep(context, l10n),
                  _buildLanguageStep(context, l10n),
                  _buildFirstJaapStep(context, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 1: Welcome ---
  Widget _buildWelcomeStep(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  Icons.radio_button_checked_rounded,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            l10n.translate('tagline'),
            textAlign: TextAlign.center,
            style: AppTypography.headlineLarge(context),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('taglineSub'),
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge(
              context,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _nextPage,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                l10n.translate('continueBtn'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- Step 2: Language ---
  Widget _buildLanguageStep(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.translate('chooseLanguage'),
            style: AppTypography.headlineMedium(context),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: AppLocalizations.supportedLanguages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final lang = AppLocalizations.supportedLanguages[index];
                final isSelected = _selectedLanguage == lang.code;
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedLanguage = lang.code);
                    widget.settingsController.setLocale(lang.code);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          lang.nativeName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${lang.name})',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _nextPage,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                l10n.translate('continueBtn'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- Step 3: First Jaap ---
  Widget _buildFirstJaapStep(BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.translate('whatToCount'),
            style: AppTypography.headlineMedium(context),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _mantraController,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: l10n.translate('mantraNameHint'),
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.translate('mala'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMalaSizeOption(27),
              const SizedBox(width: 8),
              _buildMalaSizeOption(54),
              const SizedBox(width: 8),
              _buildMalaSizeOption(108),
              const SizedBox(width: 8),
              _buildCustomMalaOption(l10n),
            ],
          ),
          if (_isCustomMala) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _customMalaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Custom Mala Size',
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => _finishOnboarding(skipJaap: false),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                l10n.translate('startJaap'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () => _finishOnboarding(skipJaap: true),
              child: Text(
                l10n.translate('skipForNow'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMalaSizeOption(int size) {
    final isSelected = !_isCustomMala && _selectedMalaSize == size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMalaSize = size;
            _isCustomMala = false;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            '$size',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMalaOption(AppLocalizations l10n) {
    final isSelected = _isCustomMala;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _isCustomMala = true;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            l10n.translate('custom'),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
