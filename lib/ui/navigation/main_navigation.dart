import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/storage_service.dart';
import '../../state/history_controller.dart';
import '../../state/jaap_controller.dart';
import '../../state/settings_controller.dart';
import '../counter/counter_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final SettingsController settingsController;
  final JaapController jaapController;
  final HistoryController historyController;
  final StorageService storageService;

  const MainNavigation({
    super.key,
    required this.settingsController,
    required this.jaapController,
    required this.historyController,
    required this.storageService,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final screens = [
      CounterScreen(
        jaapController: widget.jaapController,
        settingsController: widget.settingsController,
        historyController: widget.historyController,
      ),
      HistoryScreen(
        historyController: widget.historyController,
        jaapController: widget.jaapController,
      ),
      SettingsScreen(
        settingsController: widget.settingsController,
        jaapController: widget.jaapController,
        storageService: widget.storageService,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        height: 64,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.radio_button_unchecked_rounded),
            selectedIcon: const Icon(Icons.radio_button_checked_rounded),
            label: l10n.translate('navJaap'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart_rounded),
            label: l10n.translate('navHistory'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.tune_outlined),
            selectedIcon: const Icon(Icons.tune_rounded),
            label: l10n.translate('navMore'),
          ),
        ],
      ),
    );
  }
}
