import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/jaap_profile.dart';
import '../../data/models/jaap_session.dart';
import '../../data/models/sankalp_goal.dart';
import '../../data/models/user_settings.dart';

class StorageService {
  static const String _keySettings = 'jaap_user_settings';
  static const String _keyProfiles = 'jaap_profiles';
  static const String _keySessions = 'jaap_sessions';
  static const String _keySankalps = 'jaap_sankalps';
  static const String _keyActiveProfileId = 'jaap_active_profile_id';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Settings ---
  UserSettings loadSettings() {
    final raw = _prefs.getString(_keySettings);
    if (raw == null) return const UserSettings();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserSettings.fromJson(json);
    } catch (_) {
      return const UserSettings();
    }
  }

  Future<void> saveSettings(UserSettings settings) async {
    await _prefs.setString(_keySettings, jsonEncode(settings.toJson()));
  }

  // --- Profiles ---
  List<JaapProfile> loadProfiles() {
    final raw = _prefs.getString(_keyProfiles);
    if (raw == null) {
      // Default initial profile
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
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => JaapProfile.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProfiles(List<JaapProfile> profiles) async {
    final raw = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _prefs.setString(_keyProfiles, raw);
  }

  String? loadActiveProfileId() {
    return _prefs.getString(_keyActiveProfileId);
  }

  Future<void> saveActiveProfileId(String id) async {
    await _prefs.setString(_keyActiveProfileId, id);
  }

  // --- Sessions ---
  List<JaapSession> loadSessions() {
    final raw = _prefs.getString(_keySessions);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => JaapSession.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSessions(List<JaapSession> sessions) async {
    final raw = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _prefs.setString(_keySessions, raw);
  }

  // --- Sankalp Goals ---
  List<SankalpGoal> loadSankalps() {
    final raw = _prefs.getString(_keySankalps);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => SankalpGoal.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveSankalps(List<SankalpGoal> sankalps) async {
    final raw = jsonEncode(sankalps.map((s) => s.toJson()).toList());
    await _prefs.setString(_keySankalps, raw);
  }

  // --- Export / Import ---
  String exportAllData() {
    final exportMap = {
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': loadSettings().toJson(),
      'profiles': loadProfiles().map((p) => p.toJson()).toList(),
      'sessions': loadSessions().map((s) => s.toJson()).toList(),
      'sankalps': loadSankalps().map((s) => s.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(exportMap);
  }

  Future<bool> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      if (data.containsKey('settings')) {
        await saveSettings(UserSettings.fromJson(data['settings'] as Map<String, dynamic>));
      }
      if (data.containsKey('profiles')) {
        final rawList = data['profiles'] as List<dynamic>;
        final profiles = rawList.map((e) => JaapProfile.fromJson(e as Map<String, dynamic>)).toList();
        await saveProfiles(profiles);
      }
      if (data.containsKey('sessions')) {
        final rawList = data['sessions'] as List<dynamic>;
        final sessions = rawList.map((e) => JaapSession.fromJson(e as Map<String, dynamic>)).toList();
        await saveSessions(sessions);
      }
      if (data.containsKey('sankalps')) {
        final rawList = data['sankalps'] as List<dynamic>;
        final sankalps = rawList.map((e) => SankalpGoal.fromJson(e as Map<String, dynamic>)).toList();
        await saveSankalps(sankalps);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
