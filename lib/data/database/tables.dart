import 'package:drift/drift.dart';

// --- 1. Profiles Table ---
class JaapProfilesTable extends Table {
  @override
  String get tableName => 'jaap_profiles';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get originalText => text().withDefault(const Constant(''))();
  TextColumn get transliteration => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant('Personal'))();
  IntColumn get malaSize => integer().withDefault(const Constant(108))();
  IntColumn get dailyGoal => integer().withDefault(const Constant(108))();
  TextColumn get accentColorHex => text().withDefault(const Constant('0xFF5F7D6B'))();
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  IntColumn get totalMalasCompleted => integer().withDefault(const Constant(0))();
  IntColumn get totalLifetimeCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- 2. Sessions Table ---
class JaapSessionsTable extends Table {
  @override
  String get tableName => 'jaap_sessions';

  TextColumn get id => text()();
  TextColumn get jaapProfileId => text().references(JaapProfilesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get jaapProfileName => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  IntColumn get malaCompleted => integer().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get isManualEntry => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- 3. Sankalp Goals Table ---
class SankalpGoalsTable extends Table {
  @override
  String get tableName => 'sankalp_goals';

  TextColumn get id => text()();
  TextColumn get jaapProfileId => text().references(JaapProfilesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withDefault(const Constant('40-Day Sankalp'))();
  IntColumn get targetCount => integer().withDefault(const Constant(43200))();
  IntColumn get currentCount => integer().withDefault(const Constant(0))();
  IntColumn get totalDays => integer().withDefault(const Constant(40))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- 4. User Settings Table (Single-row entity with ID 1) ---
class UserSettingsTable extends Table {
  @override
  String get tableName => 'user_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get localeCode => text().withDefault(const Constant('en'))();
  IntColumn get themeMode => integer().withDefault(const Constant(0))();
  IntColumn get accentIndex => integer().withDefault(const Constant(0))();
  IntColumn get hapticLevel => integer().withDefault(const Constant(1))();
  IntColumn get tapSound => integer().withDefault(const Constant(1))();
  IntColumn get completionSound => integer().withDefault(const Constant(2))();
  IntColumn get counterStyle => integer().withDefault(const Constant(0))();
  BoolColumn get keepScreenAwake => boolean().withDefault(const Constant(false))();
  BoolColumn get streakTracking => boolean().withDefault(const Constant(true))();
  BoolColumn get autoStartNextMala => boolean().withDefault(const Constant(true))();
  BoolColumn get isOnboardingCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get activeProfileId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
