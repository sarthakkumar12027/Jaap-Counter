import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jaap_counter/core/localization/app_localizations.dart';
import 'package:jaap_counter/core/services/storage_service.dart';
import 'package:jaap_counter/data/database/app_database.dart';
import 'package:jaap_counter/data/database/sp_to_drift_migrator.dart';
import 'package:jaap_counter/data/models/jaap_profile.dart';
import 'package:jaap_counter/data/models/jaap_session.dart';
import 'package:jaap_counter/data/models/sankalp_goal.dart';
import 'package:jaap_counter/data/models/user_settings.dart';
import 'package:jaap_counter/data/repositories/jaap_repository.dart';
import 'package:jaap_counter/state/history_controller.dart';
import 'package:jaap_counter/state/jaap_controller.dart';
import 'package:jaap_counter/state/meditation_controller.dart';
import 'package:jaap_counter/state/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multilingual Localization', () {
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

  group('Counter Increments (+1, +10, +27, +108)', () {
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
    });

    test('+1 Increment updates currentCount, lifetimeCount, and session count', () async {
      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 1);
      expect(repository.getSessions().first.count, 1);

      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 2);
      expect(jaapController.activeProfile!.totalLifetimeCount, 2);
      expect(repository.getSessions().first.count, 2);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('+10 Direct Addition updates counts accurately', () async {
      jaapController.addCountDirect(10);
      expect(jaapController.activeProfile!.currentCount, 10);
      expect(jaapController.activeProfile!.totalLifetimeCount, 10);
      expect(repository.getSessions().first.count, 10);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('+27 Direct Addition updates counts accurately', () async {
      jaapController.addCountDirect(27);
      expect(jaapController.activeProfile!.currentCount, 27);
      expect(jaapController.activeProfile!.totalLifetimeCount, 27);
      expect(repository.getSessions().first.count, 27);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('+108 Direct Addition completes 1 full Mala and updates lifetime & session', () async {
      jaapController.addCountDirect(108);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalMalasCompleted, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 108);
      expect(repository.getSessions().first.count, 108);
      expect(repository.getSessions().first.malaCompleted, 1);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });
  });

  group('Reversible Undo Engine', () {
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
    });

    test('Undo +1 restores exact previous profile and session count', () async {
      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(repository.getSessions().first.count, 1);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 0);
      expect(repository.getSessions().isEmpty, true);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('Undo +10 restores exact previous state', () async {
      jaapController.addCountDirect(10);
      expect(jaapController.activeProfile!.currentCount, 10);
      expect(repository.getSessions().first.count, 10);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 0);
      expect(repository.getSessions().isEmpty, true);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('Undo +27 restores exact previous state', () async {
      jaapController.addCountDirect(27);
      expect(jaapController.activeProfile!.currentCount, 27);
      expect(repository.getSessions().first.count, 27);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 0);
      expect(repository.getSessions().isEmpty, true);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });

    test('Undo +108 restores 0 count, 0 malas, and reverts session malas', () async {
      jaapController.addCountDirect(108);
      expect(jaapController.activeProfile!.totalMalasCompleted, 1);
      expect(repository.getSessions().first.malaCompleted, 1);

      jaapController.undo();
      expect(jaapController.activeProfile!.totalMalasCompleted, 0);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 0);
      expect(repository.getSessions().isEmpty, true);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });
  });

  group('Mala Completion & Auto-Start Next Mala', () {
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
    });

    test('Mala completion with auto-start enabled (107 -> 108 -> 0)', () async {
      final testProfile = JaapProfile(
        id: 'test_mala_profile',
        name: 'Test Profile',
        malaSize: 3,
        dailyGoal: 9,
        createdAt: DateTime.now(),
      );
      await jaapController.addProfile(testProfile);

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

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 2);
      expect(jaapController.activeProfile!.totalMalasCompleted, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 2);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });
  });

  group('Sankalp Synchronization & Reversal', () {
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
    });

    test('Chanting advances active Sankalp progress; Undo reverses Sankalp progress', () async {
      await jaapController.startNewSankalp(totalDays: 40, targetCount: 100);
      expect(jaapController.activeSankalp, isNotNull);
      expect(jaapController.activeSankalp!.currentCount, 0);
      expect(jaapController.activeSankalp!.isCompleted, false);

      jaapController.addCountDirect(50);
      expect(jaapController.activeSankalp!.currentCount, 50);
      expect(jaapController.activeSankalp!.isCompleted, false);

      jaapController.increment();
      expect(jaapController.activeSankalp!.currentCount, 51);

      jaapController.undo();
      expect(jaapController.activeSankalp!.currentCount, 50);

      jaapController.undo();
      expect(jaapController.activeSankalp!.currentCount, 0);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });
  });

  group('Multi-Profile Isolation & Safe Undo Scope', () {
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
    });

    test('Operations on Profile A do not alter Profile B, and switching clears undo scope', () async {
      final profileB = JaapProfile(
        id: 'profile_b',
        name: 'Om Namah Shivaya',
        createdAt: DateTime.now(),
      );
      await jaapController.addProfile(profileB);

      jaapController.increment();
      jaapController.increment();
      expect(jaapController.activeProfile!.id, 'profile_b');
      expect(jaapController.activeProfile!.currentCount, 2);

      jaapController.setActiveProfile('default_radhe');
      expect(jaapController.activeProfile!.id, 'default_radhe');
      expect(jaapController.activeProfile!.currentCount, 0);

      expect(jaapController.canUndo, false);

      final pB = jaapController.profiles.firstWhere((p) => p.id == 'profile_b');
      expect(pB.currentCount, 2);
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });
  });

  group('Rapid Tapping & Concurrency Safety', () {
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
    });

    test('50 rapid consecutive taps produce exactly 50 count without drops', () async {
      for (int i = 0; i < 50; i++) {
        jaapController.increment();
      }

      expect(jaapController.activeProfile!.currentCount, 50);
      expect(jaapController.activeProfile!.totalLifetimeCount, 50);
      expect(repository.getSessions().first.count, 50);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final dbProfiles = await db.getAllProfiles();
      expect(dbProfiles.first.currentCount, 50);
      expect(dbProfiles.first.totalLifetimeCount, 50);
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
    late AppDatabase db;
    late StorageService storage;
    late JaapRepository repository;
    late SettingsController settingsController;
    late JaapController jaapController;
    late HistoryController historyController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      db = AppDatabase.inMemory();
      storage = await StorageService.init(database: db, preferences: prefs);
      repository = JaapRepository(storage);
      settingsController = SettingsController(storage);
      jaapController = JaapController(repository, settingsController);
      historyController = HistoryController(repository, jaapController);
    });

    tearDown(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await db.close();
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

      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 50,
        malaSize: 108,
        date: yesterday,
      );

      expect(historyController.currentStreakDays, 0);

      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 108,
        malaSize: 108,
        date: yesterday,
      );

      expect(historyController.currentStreakDays, 1);
      expect(historyController.isTodayMalaCompleted, false);

      await historyController.addManualSession(
        profileId: 'default_radhe',
        profileName: 'Radhe Radhe',
        count: 108,
        malaSize: 108,
        date: today,
      );

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

      expect(historyController.currentStreakDays, 0);
    });

    test('Best streak and week streak status calculation', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (int i = 5; i >= 3; i--) {
        await historyController.addManualSession(
          profileId: 'default_radhe',
          profileName: 'Radhe Radhe',
          count: 108,
          malaSize: 108,
          date: today.subtract(Duration(days: i)),
        );
      }

      expect(historyController.bestStreakDays, 3);
      expect(historyController.currentStreakDays, 0);

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
    test('Export and Import JSON retains full user data in Drift SQLite', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.inMemory();
      final storage = await StorageService.init(database: db, preferences: prefs);

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

      await db.close();
    });
  });

  group('SharedPreferences to Drift SQLite Data Migration', () {
    test('Migrates existing legacy SharedPreferences data to Drift with zero loss', () async {
      final legacyProfile = JaapProfile(
        id: 'shiva_profile_1',
        name: 'Om Namah Shivaya',
        originalText: 'ॐ नमः शिवाय',
        transliteration: 'Om Namah Shivaya',
        category: 'Popular',
        malaSize: 108,
        dailyGoal: 216,
        accentColorHex: '0xFF5F7D6B',
        currentCount: 54,
        totalMalasCompleted: 10,
        totalLifetimeCount: 1134,
        createdAt: DateTime(2025, 1, 1),
        isActive: true,
      );

      final legacySession1 = JaapSession(
        id: 'session_101',
        jaapProfileId: 'shiva_profile_1',
        jaapProfileName: 'Om Namah Shivaya',
        date: DateTime(2025, 1, 1),
        count: 108,
        malaCompleted: 1,
        durationSeconds: 300,
        isManualEntry: false,
        createdAt: DateTime(2025, 1, 1, 10, 0),
      );

      final legacySession2 = JaapSession(
        id: 'session_102',
        jaapProfileId: 'shiva_profile_1',
        jaapProfileName: 'Om Namah Shivaya',
        date: DateTime(2025, 1, 2),
        count: 216,
        malaCompleted: 2,
        durationSeconds: 600,
        isManualEntry: false,
        createdAt: DateTime(2025, 1, 2, 11, 0),
      );

      final legacySankalp = SankalpGoal(
        id: 'sankalp_shiva',
        jaapProfileId: 'shiva_profile_1',
        title: 'Shiva 40-Day Sankalp',
        targetCount: 43200,
        currentCount: 324,
        totalDays: 40,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 2, 9),
        isCompleted: false,
      );

      final legacySettings = const UserSettings(
        localeCode: 'hi',
        accentIndex: 2,
        counterStyle: CounterStyle.mala,
        streakTracking: true,
        autoStartNextMala: true,
      );

      SharedPreferences.setMockInitialValues({
        'jaap_profiles': jsonEncode([legacyProfile.toJson()]),
        'jaap_sessions': jsonEncode([legacySession1.toJson(), legacySession2.toJson()]),
        'jaap_sankalps': jsonEncode([legacySankalp.toJson()]),
        'jaap_user_settings': jsonEncode(legacySettings.toJson()),
        'jaap_active_profile_id': 'shiva_profile_1',
      });

      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.inMemory();

      expect(prefs.getBool(SpToDriftMigrator.migrationFlagKey), isNull);

      final storage = await StorageService.init(database: db, preferences: prefs);

      expect(prefs.getBool(SpToDriftMigrator.migrationFlagKey), true);

      final profiles = storage.loadProfiles();
      expect(profiles.length, 1);
      expect(profiles.first.id, 'shiva_profile_1');
      expect(profiles.first.name, 'Om Namah Shivaya');
      expect(profiles.first.totalLifetimeCount, 1134);
      expect(profiles.first.currentCount, 54);

      final sessions = storage.loadSessions();
      expect(sessions.length, 2);
      expect(sessions.any((s) => s.id == 'session_101' && s.count == 108), true);
      expect(sessions.any((s) => s.id == 'session_102' && s.count == 216), true);

      final sankalps = storage.loadSankalps();
      expect(sankalps.length, 1);
      expect(sankalps.first.id, 'sankalp_shiva');
      expect(sankalps.first.targetCount, 43200);

      final settings = storage.loadSettings();
      expect(settings.localeCode, 'hi');
      expect(settings.accentIndex, 2);
      expect(settings.counterStyle, CounterStyle.mala);
      expect(storage.loadActiveProfileId(), 'shiva_profile_1');

      expect(prefs.getString('jaap_profiles'), isNotNull);
      expect(prefs.getString('jaap_sessions'), isNotNull);

      await db.close();
    });

    test('Migration is idempotent and does not overwrite updated database state', () async {
      SharedPreferences.setMockInitialValues({
        SpToDriftMigrator.migrationFlagKey: true,
        'jaap_profiles': jsonEncode([
          JaapProfile(
            id: 'legacy_p',
            name: 'Old Legacy',
            createdAt: DateTime.now(),
          ).toJson()
        ]),
      });

      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.inMemory();

      final newProfile = JaapProfile(
        id: 'new_drift_p',
        name: 'New Drift Profile',
        createdAt: DateTime.now(),
      );
      await db.upsertProfile(newProfile);

      await SpToDriftMigrator.migrateIfNeeded(prefs, db);

      final dbProfiles = await db.getAllProfiles();
      expect(dbProfiles.length, 1);
      expect(dbProfiles.first.id, 'new_drift_p');

      await db.close();
    });
  });
}
