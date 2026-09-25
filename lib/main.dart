import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_localizations.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/jaap_repository.dart';
import 'state/history_controller.dart';
import 'state/jaap_controller.dart';
import 'state/settings_controller.dart';
import 'ui/navigation/main_navigation.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prefer portrait orientation for one-handed spiritual practice
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final storageService = await StorageService.init();
  final jaapRepository = JaapRepository(storageService);

  final settingsController = SettingsController(storageService);
  final jaapController = JaapController(jaapRepository, settingsController);
  final historyController = HistoryController(jaapRepository, jaapController);

  runApp(JaapApp(
    storageService: storageService,
    settingsController: settingsController,
    jaapController: jaapController,
    historyController: historyController,
  ));
}

class JaapApp extends StatefulWidget {
  final StorageService storageService;
  final SettingsController settingsController;
  final JaapController jaapController;
  final HistoryController historyController;

  const JaapApp({
    super.key,
    required this.storageService,
    required this.settingsController,
    required this.jaapController,
    required this.historyController,
  });

  @override
  State<JaapApp> createState() => _JaapAppState();
}

class _JaapAppState extends State<JaapApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (context, _) {
        final settings = widget.settingsController;
        final accent = settings.currentAccent;

        return MaterialApp(
          title: 'Jaap',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: AppTheme.light(accent),
          darkTheme: AppTheme.dark(accent),
          locale: settings.currentLocale,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLanguages
              .map((l) => Locale(l.code))
              .toList(),
          home: _showSplash
              ? SplashScreen(
                  onFinish: () {
                    setState(() {
                      _showSplash = false;
                    });
                  },
                )
              : (settings.isOnboardingCompleted
                  ? MainNavigation(
                      settingsController: widget.settingsController,
                      jaapController: widget.jaapController,
                      historyController: widget.historyController,
                      storageService: widget.storageService,
                    )
                  : OnboardingScreen(
                      settingsController: widget.settingsController,
                      jaapController: widget.jaapController,
                      onComplete: () {
                        setState(() {});
                      },
                    )),
        );
      },
    );
  }
}

