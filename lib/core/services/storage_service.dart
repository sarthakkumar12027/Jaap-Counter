import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/database/sp_to_drift_migrator.dart';
import '../../data/models/jaap_profile.dart';
import '../../data/models/jaap_session.dart';
import '../../data/models/sankalp_goal.dart';
import '../../data/models/user_settings.dart';

class StorageService {
  final AppDatabase _db;

  UserSettings _settings;
  List<JaapProfile> _profiles;
  String? _activeProfileId;
  List<JaapSession> _sessions;
  List<SankalpGoal> _sankalps;

  StorageService._({
    required AppDatabase db,
    required UserSettings settings,
    required List<JaapProfile> profiles,
    String? activeProfileId,
    required List<JaapSession> sessions,
    required List<SankalpGoal> sankalps,
  })  : _db = db,
        _settings = settings,
        _profiles = profiles,
        _activeProfileId = activeProfileId,
        _sessions = sessions,
        _sankalps = sankalps;

  /// Public constructor mainly for testing with pre-existing database and initial values
  StorageService(
    this._db, {
    UserSettings settings = const UserSettings(),
    List<JaapProfile>? profiles,
    String? activeProfileId,
    List<JaapSession>? sessions,
    List<SankalpGoal>? sankalps,
  })  : _settings = settings,
        _profiles = profiles ?? [],
        _activeProfileId = activeProfileId,
        _sessions = sessions ?? [],
        _sankalps = sankalps ?? [];

  /// Factory initializer that executes any pending migrations and populates fast in-memory caches.
  static Future<StorageService> init({AppDatabase? database, SharedPreferences? preferences}) async {
    final db = database ?? AppDatabase();
    final prefs = preferences ?? await SharedPreferences.getInstance();

    // Migrate existing SharedPreferences data or seed fresh install into Drift SQLite
    await SpToDriftMigrator.migrateIfNeeded(prefs, db);

    // Load fast in-memory state
    final settings = await db.getUserSettings();
    final profiles = await db.getAllProfiles();
    final activeId = await db.getActiveProfileId();
    final sessions = await db.getAllSessions();
    final sankalps = await db.getAllSankalps();

    return StorageService._(
      db: db,
      settings: settings,
      profiles: List<JaapProfile>.from(profiles),
      activeProfileId: activeId ?? (profiles.isNotEmpty ? profiles.first.id : 'default_radhe'),
      sessions: List<JaapSession>.from(sessions),
      sankalps: List<SankalpGoal>.from(sankalps),
    );
  }

  AppDatabase get db => _db;

  // ==========================================
  // SETTINGS
  // ==========================================

  UserSettings loadSettings() => _settings;

  Future<void> saveSettings(UserSettings settings) async {
    _settings = settings;
    try {
      await _db.saveUserSettings(settings, activeProfileId: _activeProfileId);
    } catch (e) {
      debugPrint('[StorageService] Error saving settings: $e');
    }
  }

  // ==========================================
  // PROFILES
  // ==========================================

  List<JaapProfile> loadProfiles() {
    if (_profiles.isEmpty) {
      return [
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
      ];
    }
    return _profiles;
  }

  Future<void> saveProfiles(List<JaapProfile> profiles) async {
    _profiles = List<JaapProfile>.from(profiles);
    try {
      final currentIds = profiles.map((p) => p.id).toSet();
      await _db.transaction(() async {
        if (currentIds.isNotEmpty) {
          await (_db.delete(_db.jaapProfilesTable)
                ..where((t) => t.id.isNotIn(currentIds)))
              .go();
        } else {
          await _db.clearProfiles();
        }
        await _db.upsertProfiles(profiles);
      });
    } catch (e) {
      debugPrint('[StorageService] Error saving profiles: $e');
    }
  }

  String? loadActiveProfileId() => _activeProfileId;

  Future<void> saveActiveProfileId(String id) async {
    _activeProfileId = id;
    try {
      await _db.saveActiveProfileId(id);
    } catch (e) {
      debugPrint('[StorageService] Error saving activeProfileId: $e');
    }
  }

  // ==========================================
  // SESSIONS
  // ==========================================

  List<JaapSession> loadSessions() => _sessions;

  Future<void> saveSessions(List<JaapSession> sessions) async {
    _sessions = List<JaapSession>.from(sessions);
    try {
      final currentIds = sessions.map((s) => s.id).toSet();
      await _db.transaction(() async {
        if (currentIds.isNotEmpty) {
          await (_db.delete(_db.jaapSessionsTable)
                ..where((t) => t.id.isNotIn(currentIds)))
              .go();
        } else {
          await _db.clearSessions();
        }
        await _db.upsertSessions(sessions);
      });
    } catch (e) {
      debugPrint('[StorageService] Error saving sessions: $e');
    }
  }

  // ==========================================
  // SANKALP GOALS
  // ==========================================

  List<SankalpGoal> loadSankalps() => _sankalps;

  Future<void> saveSankalps(List<SankalpGoal> sankalps) async {
    _sankalps = List<SankalpGoal>.from(sankalps);
    try {
      final currentIds = sankalps.map((s) => s.id).toSet();
      await _db.transaction(() async {
        if (currentIds.isNotEmpty) {
          await (_db.delete(_db.sankalpGoalsTable)
                ..where((t) => t.id.isNotIn(currentIds)))
              .go();
        } else {
          await _db.clearSankalps();
        }
        await _db.upsertSankalps(sankalps);
      });
    } catch (e) {
      debugPrint('[StorageService] Error saving sankalps: $e');
    }
  }

  // ==========================================
  // EXPORT / IMPORT BACKUP (100% JSON Backward Compatibility)
  // ==========================================

  String exportAllData() {
    final exportMap = {
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': _settings.toJson(),
      'profiles': _profiles.map((p) => p.toJson()).toList(),
      'sessions': _sessions.map((s) => s.toJson()).toList(),
      'sankalps': _sankalps.map((s) => s.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(exportMap);
  }

  Future<bool> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      UserSettings? newSettings;
      if (data.containsKey('settings')) {
        newSettings = UserSettings.fromJson(data['settings'] as Map<String, dynamic>);
      }

      List<JaapProfile>? newProfiles;
      if (data.containsKey('profiles')) {
        final rawList = data['profiles'] as List<dynamic>;
        newProfiles = rawList
            .map((e) => JaapProfile.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      List<JaapSession>? newSessions;
      if (data.containsKey('sessions')) {
        final rawList = data['sessions'] as List<dynamic>;
        newSessions = rawList
            .map((e) => JaapSession.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      List<SankalpGoal>? newSankalps;
      if (data.containsKey('sankalps')) {
        final rawList = data['sankalps'] as List<dynamic>;
        newSankalps = rawList
            .map((e) => SankalpGoal.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      await _db.transaction(() async {
        if (newProfiles != null) {
          final pIds = newProfiles.map((p) => p.id).toSet();
          if (pIds.isNotEmpty) {
            await (_db.delete(_db.jaapProfilesTable)..where((t) => t.id.isNotIn(pIds))).go();
          } else {
            await _db.clearProfiles();
          }
          await _db.upsertProfiles(newProfiles);
          _profiles = newProfiles;
        }

        if (newSessions != null) {
          final sIds = newSessions.map((s) => s.id).toSet();
          if (sIds.isNotEmpty) {
            await (_db.delete(_db.jaapSessionsTable)..where((t) => t.id.isNotIn(sIds))).go();
          } else {
            await _db.clearSessions();
          }
          await _db.upsertSessions(newSessions);
          _sessions = newSessions;
        }

        if (newSankalps != null) {
          final skIds = newSankalps.map((s) => s.id).toSet();
          if (skIds.isNotEmpty) {
            await (_db.delete(_db.sankalpGoalsTable)..where((t) => t.id.isNotIn(skIds))).go();
          } else {
            await _db.clearSankalps();
          }
          await _db.upsertSankalps(newSankalps);
          _sankalps = newSankalps;
        }

        if (newSettings != null) {
          _settings = newSettings;
          await _db.saveUserSettings(newSettings, activeProfileId: _activeProfileId);
        }
      });

      return true;
    } catch (e) {
      debugPrint('[StorageService] Error importing backup: $e');
      return false;
    }
  }

  Future<void> clearAll() async {
    _settings = const UserSettings();
    _profiles = [];
    _activeProfileId = null;
    _sessions = [];
    _sankalps = [];
    try {
      await _db.clearAllData();
    } catch (e) {
      debugPrint('[StorageService] Error clearing all data: $e');
    }
  }
}
