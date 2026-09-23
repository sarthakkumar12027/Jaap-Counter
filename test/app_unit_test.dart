import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaap_counter/core/localization/app_localizations.dart';
import 'package:jaap_counter/core/services/storage_service.dart';
import 'package:jaap_counter/data/models/jaap_profile.dart';
import 'package:jaap_counter/data/models/user_settings.dart';
import 'package:jaap_counter/data/repositories/jaap_repository.dart';
import 'package:jaap_counter/state/history_controller.dart';
import 'package:jaap_counter/state/jaap_controller.dart';
import 'package:jaap_counter/state/meditation_controller.dart';
import 'package:jaap_counter/state/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multilingual Localization Tests', () {
    test('Supports all 11 PRD languages with key translations', () {
      expect(AppLocalizations.supportedLanguages.length, 11);

      final codes = ['en', 'hi', 'bn', 'pa', 'gu', 'mr', 'ta', 'te', 'kn', 'ml', 'or'];
      for (final code in codes) {
        final loc = AppLocalizations(Locale(code));
        expect(loc.translate('appName').isNotEmpty, true, reason: 'Failed for language $code');
        expect(loc.translate('navJaap').isNotEmpty, true, reason: 'Failed for language $code');
        expect(loc.translate('navHistory').isNotEmpty, true, reason: 'Failed for language $code');
        expect(loc.translate('navMore').isNotEmpty, true, reason: 'Failed for language $code');
        expect(loc.translate('tapToCount').isNotEmpty, true, reason: 'Failed for language $code');
        expect(loc.translate('malaComplete').isNotEmpty, true, reason: 'Failed for language $code');
      }
    });
  });

  group('Jaap Controller Counting & Mala Engine', () {
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    test('Initial active profile is loaded with 0 count', () {
      expect(jaapController.activeProfile, isNotNull);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.malaSize, 108);
    });

    test('Tap increments count instantaneously', () {
      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 1);

      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 2);
      expect(jaapController.activeProfile!.totalLifetimeCount, 2);
    });

    test('Undo reverts count to previous state', () {
      jaapController.increment();
      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 2);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 1);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 0);
    });

    test('Completing Mala size resets count to 0 and increments Malas completed', () async {
      final testProfile = JaapProfile(
        id: 'test_mala_3',
        name: 'Om Shanti',
        malaSize: 3,
        dailyGoal: 9,
        createdAt: DateTime.now(),
      );

      await jaapController.addProfile(testProfile);
      expect(jaapController.activeProfile!.id, 'test_mala_3');

      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(jaapController.activeProfile!.totalMalasCompleted, 0);

      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 2);

      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalMalasCompleted, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 3);
      expect(jaapController.isMalaCompletedPulse, true);
    });

    test('Direct count addition works accurately', () {
      jaapController.addCountDirect(108);
      expect(jaapController.activeProfile!.totalMalasCompleted, 1);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 108);
    });
  });

  group('Meditation Controller Tests', () {
    test('Duration changes and custom duration configuration', () {
      final controller = MeditationController();
      expect(controller.selectedMinutes, 10);
      expect(controller.secondsRemaining, 600);
      expect(controller.formattedTimeRemaining, '10:00');

      controller.setDuration(45);
      expect(controller.selectedMinutes, 45);
      expect(controller.secondsRemaining, 2700);
      expect(controller.formattedTimeRemaining, '45:00');

      controller.dispose();
    });

    test('Mute toggle state management', () {
      final controller = MeditationController();
      expect(controller.isMuted, false);

      controller.toggleMute();
      expect(controller.isMuted, true);

      controller.toggleMute();
      expect(controller.isMuted, false);

      controller.dispose();
    });

    test('Start and stop meditation updates running state and resets remaining seconds', () {
      final controller = MeditationController();
      controller.setDuration(15);
      expect(controller.isRunning, false);

      controller.startMeditation();
      expect(controller.isRunning, true);

      controller.stopMeditation();
      expect(controller.isRunning, false);
      expect(controller.secondsRemaining, 900);

      controller.dispose();
    });
  });

  group('History Controller Analytics & Streaks', () {
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;
    late HistoryController historyController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
      historyController = HistoryController(repository, jaapController);
    });

    test('Manual session entry updates aggregated history and weekly data', () async {
      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 540,
        malaSize: 108,
        date: DateTime.now(),
      );

      expect(historyController.todayTotalJaaps, 540);
      expect(historyController.todayTotalMalas, 5);
      expect(historyController.allTimeTotalJaaps, 540);
      expect(historyController.currentStreakDays, 1);
      expect(historyController.isTodayMalaCompleted, true);
    });

    test('Streak requires at least 1 completed Mala per day', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      // Partial count (50 chants < 108) with 0 malas completed yesterday
      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 50,
        malaSize: 108,
        date: yesterday,
      );

      // Streak is 0 because no full mala was completed
      expect(historyController.currentStreakDays, 0);

      // Add full mala for yesterday
      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 108,
        malaSize: 108,
        date: yesterday,
      );

      // Active streak preserved from yesterday
      expect(historyController.currentStreakDays, 1);
      expect(historyController.isTodayMalaCompleted, false);

      // Complete 1 mala today
      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 108,
        malaSize: 108,
        date: today,
      );

      // Streak increases to 2
      expect(historyController.currentStreakDays, 2);
      expect(historyController.isTodayMalaCompleted, true);
    });

    test('Streak resets to 0 after midnight if yesterday had no completed mala', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final threeDaysAgo = today.subtract(const Duration(days: 3));

      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 108,
        malaSize: 108,
        date: threeDaysAgo,
      );

      // Because yesterday and today have no malas, streak is broken
      expect(historyController.currentStreakDays, 0);
    });

    test('Best streak and week streak status calculation', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // 3 consecutive days in the past
      for (int i = 5; i >= 3; i--) {
        await historyController.addManualSession(
          profileId: 'default_radhe',
          profileName: 'Radhe Radhe',
          count: 108,
          malaSize: 108,
          date: today.subtract(Duration(days: i)),
        );
      }

      // Best streak was 3 days
      expect(historyController.bestStreakDays, 3);
      expect(historyController.currentStreakDays, 0); // Broken since 2 days ago was skipped

      final weekStatus = historyController.currentWeekStreakStatus;
      expect(weekStatus.length, 7);
    });

    test('Weekly bar data contains 7 days and accurately marks today', () {
      final barData = historyController.weeklyBarData;
      expect(barData.length, 7);
      expect(barData.any((d) => d.isToday), true);
    });
  });

  group('Storage & Backup Restore Integrity', () {
    test('Export and Import JSON retains full user data', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = StorageService(prefs);

      final settings = const UserSettings(
        localeCode: 'hi',
        accentIndex: 3,
        counterStyle: CounterStyle.mala,
      );
      await storage.saveSettings(settings);

      final exportedJson = storage.exportAllData();
      expect(exportedJson.contains('"localeCode": "hi"'), true);
      expect(exportedJson.contains('"counterStyle": 1'), true);

      await storage.clearAll();
      expect(storage.loadSettings().localeCode, 'en');

      final success = await storage.importData(exportedJson);
      expect(success, true);
      expect(storage.loadSettings().localeCode, 'hi');
      expect(storage.loadSettings().counterStyle, CounterStyle.mala);
    });
  });
}
