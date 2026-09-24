import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/jaap_profile.dart';
import '../models/jaap_session.dart';
import '../models/sankalp_goal.dart';
import '../models/user_settings.dart';
import 'app_database.dart';

class SpToDriftMigrator {
  static const String migrationFlagKey = 'sp_migrated_to_drift_v1';

  static const String _keySettings = 'jaap_user_settings';
  static const String _keyProfiles = 'jaap_profiles';
  static const String _keySessions = 'jaap_sessions';
  static const String _keySankalps = 'jaap_sankalps';
  static const String _keyActiveProfileId = 'jaap_active_profile_id';

  static Future<void> migrateIfNeeded(SharedPreferences prefs, AppDatabase db) async {
    final alreadyMigrated = prefs.getBool(migrationFlagKey) ?? false;
    if (alreadyMigrated) {
      return;
    }

    final rawSettings = prefs.getString(_keySettings);
    final rawProfiles = prefs.getString(_keyProfiles);
    final rawSessions = prefs.getString(_keySessions);
    final rawSankalps = prefs.getString(_keySankalps);
    final activeProfileId = prefs.getString(_keyActiveProfileId);

    final hasLegacyData = rawSettings != null ||
        rawProfiles != null ||
        rawSessions != null ||
        rawSankalps != null ||
        activeProfileId != null;

    if (!hasLegacyData) {
      final defaultProfile = JaapProfile(
        id: 'default_radhe',
        name: 'Radhe Radhe',
        originalText: 'राधे राधे',
        transliteration: 'Radhe Radhe',
        category: 'Popular',
        malaSize: 108,
        dailyGoal: 108,
        accentColorHex: '0xFF5F7D6B',
        createdAt: DateTime.now(),
        isActive: true,
      );

      await db.transaction(() async {
        await db.upsertProfile(defaultProfile);
        await db.saveUserSettings(
          const UserSettings(),
          activeProfileId: defaultProfile.id,
        );
      });

      await prefs.setBool(migrationFlagKey, true);
      return;
    }

    UserSettings settings = const UserSettings();
    if (rawSettings != null) {
      try {
        final map = jsonDecode(rawSettings) as Map<String, dynamic>;
        settings = UserSettings.fromJson(map);
      } catch (_) {}
    }

    List<JaapProfile> profiles = [];
    if (rawProfiles != null) {
      try {
        final list = jsonDecode(rawProfiles) as List<dynamic>;
        profiles = list
            .map((item) => JaapProfile.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    if (profiles.isEmpty) {
      profiles.add(
        JaapProfile(
          id: 'default_radhe',
          name: 'Radhe Radhe',
          originalText: 'राधे राधे',
          transliteration: 'Radhe Radhe',
          category: 'Popular',
          malaSize: 108,
          dailyGoal: 108,
          accentColorHex: '0xFF5F7D6B',
          createdAt: DateTime.now(),
          isActive: true,
        ),
      );
    }

    List<JaapSession> sessions = [];
    if (rawSessions != null) {
      try {
        final list = jsonDecode(rawSessions) as List<dynamic>;
        sessions = list
            .map((item) => JaapSession.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    List<SankalpGoal> sankalps = [];
    if (rawSankalps != null) {
      try {
        final list = jsonDecode(rawSankalps) as List<dynamic>;
        sankalps = list
            .map((item) => SankalpGoal.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    final effectiveActiveId = activeProfileId ??
        (profiles.isNotEmpty ? profiles.first.id : 'default_radhe');

    await db.transaction(() async {
      await db.upsertProfiles(profiles);
      if (sessions.isNotEmpty) {
        await db.upsertSessions(sessions);
      }
      if (sankalps.isNotEmpty) {
        await db.upsertSankalps(sankalps);
      }
      await db.saveUserSettings(settings, activeProfileId: effectiveActiveId);
    });

    final migratedProfiles = await db.getAllProfiles();
    final migratedSessions = await db.getAllSessions();
    if (migratedProfiles.length < profiles.length ||
        migratedSessions.length < sessions.length) {
      throw StateError('Migration verification failed.');
    }

    await prefs.setBool(migrationFlagKey, true);
  }
}
