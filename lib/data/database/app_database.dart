import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart' show ThemeMode;

import '../../core/services/audio_service.dart';
import '../../core/services/haptic_service.dart';
import '../models/jaap_profile.dart';
import '../models/jaap_session.dart';
import '../models/sankalp_goal.dart';
import '../models/user_settings.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  JaapProfilesTable,
  JaapSessionsTable,
  SankalpGoalsTable,
  UserSettingsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  factory AppDatabase.inMemory() {
    return AppDatabase(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_sessions_date ON jaap_sessions(date);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_sessions_profile_date ON jaap_sessions(jaap_profile_id, date);',
        );
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  // --- Profiles ---

  Future<List<JaapProfile>> getAllProfiles() async {
    final query = select(jaapProfilesTable)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]);
    final rows = await query.get();
    return rows.map(_rowToProfile).toList();
  }

  Future<JaapProfile?> getProfileById(String id) async {
    final row = await (select(jaapProfilesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _rowToProfile(row) : null;
  }

  Future<void> upsertProfile(JaapProfile profile) async {
    await into(jaapProfilesTable).insertOnConflictUpdate(_profileToCompanion(profile));
  }

  Future<void> upsertProfiles(List<JaapProfile> profiles) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        jaapProfilesTable,
        profiles.map(_profileToCompanion).toList(),
      );
    });
  }

  Future<void> deleteProfile(String id) async {
    await (delete(jaapProfilesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearProfiles() async {
    await delete(jaapProfilesTable).go();
  }

  // --- Sessions ---

  Future<List<JaapSession>> getAllSessions() async {
    final query = select(jaapSessionsTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_rowToSession).toList();
  }

  Future<List<JaapSession>> getSessionsForProfile(String profileId) async {
    final query = select(jaapSessionsTable)
      ..where((t) => t.jaapProfileId.equals(profileId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_rowToSession).toList();
  }

  Future<void> upsertSession(JaapSession session) async {
    await into(jaapSessionsTable).insertOnConflictUpdate(_sessionToCompanion(session));
  }

  Future<void> upsertSessions(List<JaapSession> sessions) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        jaapSessionsTable,
        sessions.map(_sessionToCompanion).toList(),
      );
    });
  }

  Future<void> deleteSession(String id) async {
    await (delete(jaapSessionsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearSessions() async {
    await delete(jaapSessionsTable).go();
  }

  // --- Sankalps ---

  Future<List<SankalpGoal>> getAllSankalps() async {
    final query = select(sankalpGoalsTable)
      ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)]);
    final rows = await query.get();
    return rows.map(_rowToSankalp).toList();
  }

  Future<void> upsertSankalp(SankalpGoal sankalp) async {
    await into(sankalpGoalsTable).insertOnConflictUpdate(_sankalpToCompanion(sankalp));
  }

  Future<void> upsertSankalps(List<SankalpGoal> sankalps) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        sankalpGoalsTable,
        sankalps.map(_sankalpToCompanion).toList(),
      );
    });
  }

  Future<void> deleteSankalp(String id) async {
    await (delete(sankalpGoalsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearSankalps() async {
    await delete(sankalpGoalsTable).go();
  }

  // --- Settings ---

  Future<UserSettings> getUserSettings() async {
    final row = await (select(userSettingsTable)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) {
      return const UserSettings();
    }
    return _rowToUserSettings(row);
  }

  Future<String?> getActiveProfileId() async {
    final row = await (select(userSettingsTable)..where((t) => t.id.equals(1))).getSingleOrNull();
    return row?.activeProfileId;
  }

  Future<void> saveUserSettings(UserSettings settings, {String? activeProfileId}) async {
    final existingRow = await (select(userSettingsTable)..where((t) => t.id.equals(1))).getSingleOrNull();
    final effectiveActiveId = activeProfileId ?? existingRow?.activeProfileId;

    final companion = UserSettingsTableCompanion(
      id: const Value(1),
      localeCode: Value(settings.localeCode),
      themeMode: Value(settings.themeMode.index),
      accentIndex: Value(settings.accentIndex),
      hapticLevel: Value(settings.hapticLevel.index),
      tapSound: Value(settings.tapSound.index),
      completionSound: Value(settings.completionSound.index),
      counterStyle: Value(settings.counterStyle.index),
      keepScreenAwake: Value(settings.keepScreenAwake),
      streakTracking: Value(settings.streakTracking),
      autoStartNextMala: Value(settings.autoStartNextMala),
      isOnboardingCompleted: Value(settings.isOnboardingCompleted),
      activeProfileId: Value(effectiveActiveId),
    );

    await into(userSettingsTable).insertOnConflictUpdate(companion);
  }

  Future<void> saveActiveProfileId(String? profileId) async {
    final existingRow = await (select(userSettingsTable)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (existingRow == null) {
      const defaultSettings = UserSettings();
      await saveUserSettings(defaultSettings, activeProfileId: profileId);
    } else {
      await (update(userSettingsTable)..where((t) => t.id.equals(1))).write(
        UserSettingsTableCompanion(activeProfileId: Value(profileId)),
      );
    }
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(jaapSessionsTable).go();
      await delete(sankalpGoalsTable).go();
      await delete(jaapProfilesTable).go();
      await delete(userSettingsTable).go();
    });
  }

  // --- Converters ---

  static JaapProfile _rowToProfile(JaapProfilesTableData row) {
    return JaapProfile(
      id: row.id,
      name: row.name,
      originalText: row.originalText,
      transliteration: row.transliteration,
      category: row.category,
      malaSize: row.malaSize,
      dailyGoal: row.dailyGoal,
      accentColorHex: row.accentColorHex,
      currentCount: row.currentCount,
      totalMalasCompleted: row.totalMalasCompleted,
      totalLifetimeCount: row.totalLifetimeCount,
      createdAt: row.createdAt,
      isActive: row.isActive,
    );
  }

  static JaapProfilesTableCompanion _profileToCompanion(JaapProfile p) {
    return JaapProfilesTableCompanion(
      id: Value(p.id),
      name: Value(p.name),
      originalText: Value(p.originalText),
      transliteration: Value(p.transliteration),
      category: Value(p.category),
      malaSize: Value(p.malaSize),
      dailyGoal: Value(p.dailyGoal),
      accentColorHex: Value(p.accentColorHex),
      currentCount: Value(p.currentCount),
      totalMalasCompleted: Value(p.totalMalasCompleted),
      totalLifetimeCount: Value(p.totalLifetimeCount),
      createdAt: Value(p.createdAt),
      isActive: Value(p.isActive),
    );
  }

  static JaapSession _rowToSession(JaapSessionsTableData row) {
    return JaapSession(
      id: row.id,
      jaapProfileId: row.jaapProfileId,
      jaapProfileName: row.jaapProfileName,
      date: row.date,
      count: row.count,
      malaCompleted: row.malaCompleted,
      durationSeconds: row.durationSeconds,
      isManualEntry: row.isManualEntry,
      createdAt: row.createdAt,
    );
  }

  static JaapSessionsTableCompanion _sessionToCompanion(JaapSession s) {
    return JaapSessionsTableCompanion(
      id: Value(s.id),
      jaapProfileId: Value(s.jaapProfileId),
      jaapProfileName: Value(s.jaapProfileName),
      date: Value(s.date),
      count: Value(s.count),
      malaCompleted: Value(s.malaCompleted),
      durationSeconds: Value(s.durationSeconds),
      isManualEntry: Value(s.isManualEntry),
      createdAt: Value(s.createdAt),
    );
  }

  static SankalpGoal _rowToSankalp(SankalpGoalsTableData row) {
    return SankalpGoal(
      id: row.id,
      jaapProfileId: row.jaapProfileId,
      title: row.title,
      targetCount: row.targetCount,
      currentCount: row.currentCount,
      totalDays: row.totalDays,
      startDate: row.startDate,
      endDate: row.endDate,
      isCompleted: row.isCompleted,
    );
  }

  static SankalpGoalsTableCompanion _sankalpToCompanion(SankalpGoal s) {
    return SankalpGoalsTableCompanion(
      id: Value(s.id),
      jaapProfileId: Value(s.jaapProfileId),
      title: Value(s.title),
      targetCount: Value(s.targetCount),
      currentCount: Value(s.currentCount),
      totalDays: Value(s.totalDays),
      startDate: Value(s.startDate),
      endDate: Value(s.endDate),
      isCompleted: Value(s.isCompleted),
    );
  }

  static UserSettings _rowToUserSettings(UserSettingsTableData row) {
    return UserSettings(
      localeCode: row.localeCode,
      themeMode: ThemeMode.values[(row.themeMode).clamp(0, ThemeMode.values.length - 1)],
      accentIndex: row.accentIndex,
      hapticLevel: HapticLevel.values[(row.hapticLevel).clamp(0, HapticLevel.values.length - 1)],
      tapSound: TapSoundType.values[(row.tapSound).clamp(0, TapSoundType.values.length - 1)],
      completionSound: CompletionSoundType.values[(row.completionSound).clamp(0, CompletionSoundType.values.length - 1)],
      counterStyle: CounterStyle.values[(row.counterStyle).clamp(0, CounterStyle.values.length - 1)],
      keepScreenAwake: row.keepScreenAwake,
      streakTracking: row.streakTracking,
      autoStartNextMala: row.autoStartNextMala,
      isOnboardingCompleted: row.isOnboardingCompleted,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'jaap_counter.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
