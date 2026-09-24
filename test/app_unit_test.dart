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

  group('Direct Drift Database Operations & Relational Foreign Keys', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.inMemory();
    });

    tearDown(() async {
      await db.close();
    });

    test('Profile CRUD and Foreign Key Cascade to Sessions and Sankalps', () async {
      final profile = JaapProfile(
        id: 'p_test_cascade',
        name: 'Cascade Test Profile',
        createdAt: DateTime.now(),
      );
      await db.upsertProfile(profile);

      final session = JaapSession(
        id: 's_test_cascade',
        jaapProfileId: 'p_test_cascade',
        jaapProfileName: 'Cascade Test Profile',
        date: DateTime(2025, 1, 1),
        count: 108,
        malaCompleted: 1,
        createdAt: DateTime.now(),
      );
      await db.upsertSession(session);

      final sankalp = SankalpGoal(
        id: 'sk_test_cascade',
        jaapProfileId: 'p_test_cascade',
        title: 'Cascade Goal',
        targetCount: 1000,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 2, 1),
      );
      await db.upsertSankalp(sankalp);

      expect((await db.getAllProfiles()).length, 1);
      expect((await db.getAllSessions()).length, 1);
      expect((await db.getAllSankalps()).length, 1);

      // Delete profile -> Sessions & Sankalps cascade delete
      await db.deleteProfile('p_test_cascade');

      expect((await db.getAllProfiles()).length, 0);
      expect((await db.getAllSessions()).length, 0);
      expect((await db.getAllSankalps()).length, 0);
    });
  });

  group('Jaap Controller Counting & Snapshot-based Undo Engine', () {
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

    test('Initial active profile is loaded with 0 count', () {
      expect(jaapController.activeProfile, isNotNull);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.malaSize, 108);
    });

    test('Tap increments count and session record instantaneously', () async {
      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 1);
      expect(repository.getSessions().first.count, 1);

      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 2);
      expect(jaapController.activeProfile!.totalLifetimeCount, 2);
      expect(repository.getSessions().first.count, 2);

      await Future<void>.delayed(const Duration(milliseconds: 20));
    });

    test('Snapshot undo accurately rolls back profile count and session state', () async {
      jaapController.increment();
      jaapController.increment();
      expect(jaapController.activeProfile!.currentCount, 2);
      expect(repository.getSessions().first.count, 2);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 1);
      expect(jaapController.activeProfile!.totalLifetimeCount, 1);
      expect(repository.getSessions().first.count, 1);

      jaapController.undo();
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 0);

      await Future<void>.delayed(const Duration(milliseconds: 20));
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

      await Future<void>.delayed(const Duration(milliseconds: 20));
    });

    test('Direct count addition works accurately and undo restores previous state', () async {
      jaapController.addCountDirect(108);
      expect(jaapController.activeProfile!.totalMalasCompleted, 1);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 108);

      jaapController.undo();
      expect(jaapController.activeProfile!.totalMalasCompleted, 0);
      expect(jaapController.activeProfile!.currentCount, 0);
      expect(jaapController.activeProfile!.totalLifetimeCount, 0);

      await Future<void>.delayed(const Duration(milliseconds: 20));
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

  group('History Controller Analytics & Streaks with Drift SQLite', () {
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

  group('Storage & Backup Restore Integrity with Drift SQLite', () {
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

  group('SharedPreferences to Drift SQLite Data Migration Suite', () {
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

      // Ensure not migrated before
      expect(prefs.getBool(SpToDriftMigrator.migrationFlagKey), isNull);

      // Perform migration via StorageService.init
      final storage = await StorageService.init(database: db, preferences: prefs);

      // Verify migration flag is set
      expect(prefs.getBool(SpToDriftMigrator.migrationFlagKey), true);

      // Verify profiles in Drift
      final profiles = storage.loadProfiles();
      expect(profiles.length, 1);
      expect(profiles.first.id, 'shiva_profile_1');
      expect(profiles.first.name, 'Om Namah Shivaya');
      expect(profiles.first.totalLifetimeCount, 1134);
      expect(profiles.first.currentCount, 54);

      // Verify sessions in Drift
      final sessions = storage.loadSessions();
      expect(sessions.length, 2);
      expect(sessions.any((s) => s.id == 'session_101' && s.count == 108), true);
      expect(sessions.any((s) => s.id == 'session_102' && s.count == 216), true);

      // Verify sankalps in Drift
      final sankalps = storage.loadSankalps();
      expect(sankalps.length, 1);
      expect(sankalps.first.id, 'sankalp_shiva');
      expect(sankalps.first.targetCount, 43200);

      // Verify settings & active profile in Drift
      final settings = storage.loadSettings();
      expect(settings.localeCode, 'hi');
      expect(settings.accentIndex, 2);
      expect(settings.counterStyle, CounterStyle.mala);
      expect(storage.loadActiveProfileId(), 'shiva_profile_1');

      // Verify original SharedPreferences keys are safely preserved
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

      // Seed newer profile into db
      final newProfile = JaapProfile(
        id: 'new_drift_p',
        name: 'New Drift Profile',
        createdAt: DateTime.now(),
      );
      await db.upsertProfile(newProfile);

      // Calling migration should be a no-op because flag is true
      await SpToDriftMigrator.migrateIfNeeded(prefs, db);

      final dbProfiles = await db.getAllProfiles();
      expect(dbProfiles.length, 1);
      expect(dbProfiles.first.id, 'new_drift_p');

      await db.close();
    });
  });
}
