// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $JaapProfilesTableTable extends JaapProfilesTable
    with TableInfo<$JaapProfilesTableTable, JaapProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JaapProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalTextMeta = const VerificationMeta(
    'originalText',
  );
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
    'original_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Personal'),
  );
  static const VerificationMeta _malaSizeMeta = const VerificationMeta(
    'malaSize',
  );
  @override
  late final GeneratedColumn<int> malaSize = GeneratedColumn<int>(
    'mala_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(108),
  );
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(108),
  );
  static const VerificationMeta _accentColorHexMeta = const VerificationMeta(
    'accentColorHex',
  );
  @override
  late final GeneratedColumn<String> accentColorHex = GeneratedColumn<String>(
    'accent_color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0xFF5F7D6B'),
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMalasCompletedMeta =
      const VerificationMeta('totalMalasCompleted');
  @override
  late final GeneratedColumn<int> totalMalasCompleted = GeneratedColumn<int>(
    'total_malas_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalLifetimeCountMeta =
      const VerificationMeta('totalLifetimeCount');
  @override
  late final GeneratedColumn<int> totalLifetimeCount = GeneratedColumn<int>(
    'total_lifetime_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    originalText,
    transliteration,
    category,
    malaSize,
    dailyGoal,
    accentColorHex,
    currentCount,
    totalMalasCompleted,
    totalLifetimeCount,
    createdAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jaap_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<JaapProfilesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('original_text')) {
      context.handle(
        _originalTextMeta,
        originalText.isAcceptableOrUnknown(
          data['original_text']!,
          _originalTextMeta,
        ),
      );
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('mala_size')) {
      context.handle(
        _malaSizeMeta,
        malaSize.isAcceptableOrUnknown(data['mala_size']!, _malaSizeMeta),
      );
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('accent_color_hex')) {
      context.handle(
        _accentColorHexMeta,
        accentColorHex.isAcceptableOrUnknown(
          data['accent_color_hex']!,
          _accentColorHexMeta,
        ),
      );
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('total_malas_completed')) {
      context.handle(
        _totalMalasCompletedMeta,
        totalMalasCompleted.isAcceptableOrUnknown(
          data['total_malas_completed']!,
          _totalMalasCompletedMeta,
        ),
      );
    }
    if (data.containsKey('total_lifetime_count')) {
      context.handle(
        _totalLifetimeCountMeta,
        totalLifetimeCount.isAcceptableOrUnknown(
          data['total_lifetime_count']!,
          _totalLifetimeCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JaapProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JaapProfilesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      originalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_text'],
      )!,
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      malaSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mala_size'],
      )!,
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal'],
      )!,
      accentColorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_color_hex'],
      )!,
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      totalMalasCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_malas_completed'],
      )!,
      totalLifetimeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_lifetime_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $JaapProfilesTableTable createAlias(String alias) {
    return $JaapProfilesTableTable(attachedDatabase, alias);
  }
}

class JaapProfilesTableData extends DataClass
    implements Insertable<JaapProfilesTableData> {
  final String id;
  final String name;
  final String originalText;
  final String transliteration;
  final String category;
  final int malaSize;
  final int dailyGoal;
  final String accentColorHex;
  final int currentCount;
  final int totalMalasCompleted;
  final int totalLifetimeCount;
  final DateTime createdAt;
  final bool isActive;
  const JaapProfilesTableData({
    required this.id,
    required this.name,
    required this.originalText,
    required this.transliteration,
    required this.category,
    required this.malaSize,
    required this.dailyGoal,
    required this.accentColorHex,
    required this.currentCount,
    required this.totalMalasCompleted,
    required this.totalLifetimeCount,
    required this.createdAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['original_text'] = Variable<String>(originalText);
    map['transliteration'] = Variable<String>(transliteration);
    map['category'] = Variable<String>(category);
    map['mala_size'] = Variable<int>(malaSize);
    map['daily_goal'] = Variable<int>(dailyGoal);
    map['accent_color_hex'] = Variable<String>(accentColorHex);
    map['current_count'] = Variable<int>(currentCount);
    map['total_malas_completed'] = Variable<int>(totalMalasCompleted);
    map['total_lifetime_count'] = Variable<int>(totalLifetimeCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  JaapProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return JaapProfilesTableCompanion(
      id: Value(id),
      name: Value(name),
      originalText: Value(originalText),
      transliteration: Value(transliteration),
      category: Value(category),
      malaSize: Value(malaSize),
      dailyGoal: Value(dailyGoal),
      accentColorHex: Value(accentColorHex),
      currentCount: Value(currentCount),
      totalMalasCompleted: Value(totalMalasCompleted),
      totalLifetimeCount: Value(totalLifetimeCount),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory JaapProfilesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JaapProfilesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      originalText: serializer.fromJson<String>(json['originalText']),
      transliteration: serializer.fromJson<String>(json['transliteration']),
      category: serializer.fromJson<String>(json['category']),
      malaSize: serializer.fromJson<int>(json['malaSize']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      accentColorHex: serializer.fromJson<String>(json['accentColorHex']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      totalMalasCompleted: serializer.fromJson<int>(
        json['totalMalasCompleted'],
      ),
      totalLifetimeCount: serializer.fromJson<int>(json['totalLifetimeCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'originalText': serializer.toJson<String>(originalText),
      'transliteration': serializer.toJson<String>(transliteration),
      'category': serializer.toJson<String>(category),
      'malaSize': serializer.toJson<int>(malaSize),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'accentColorHex': serializer.toJson<String>(accentColorHex),
      'currentCount': serializer.toJson<int>(currentCount),
      'totalMalasCompleted': serializer.toJson<int>(totalMalasCompleted),
      'totalLifetimeCount': serializer.toJson<int>(totalLifetimeCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  JaapProfilesTableData copyWith({
    String? id,
    String? name,
    String? originalText,
    String? transliteration,
    String? category,
    int? malaSize,
    int? dailyGoal,
    String? accentColorHex,
    int? currentCount,
    int? totalMalasCompleted,
    int? totalLifetimeCount,
    DateTime? createdAt,
    bool? isActive,
  }) => JaapProfilesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    originalText: originalText ?? this.originalText,
    transliteration: transliteration ?? this.transliteration,
    category: category ?? this.category,
    malaSize: malaSize ?? this.malaSize,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    accentColorHex: accentColorHex ?? this.accentColorHex,
    currentCount: currentCount ?? this.currentCount,
    totalMalasCompleted: totalMalasCompleted ?? this.totalMalasCompleted,
    totalLifetimeCount: totalLifetimeCount ?? this.totalLifetimeCount,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );
  JaapProfilesTableData copyWithCompanion(JaapProfilesTableCompanion data) {
    return JaapProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      category: data.category.present ? data.category.value : this.category,
      malaSize: data.malaSize.present ? data.malaSize.value : this.malaSize,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      accentColorHex: data.accentColorHex.present
          ? data.accentColorHex.value
          : this.accentColorHex,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      totalMalasCompleted: data.totalMalasCompleted.present
          ? data.totalMalasCompleted.value
          : this.totalMalasCompleted,
      totalLifetimeCount: data.totalLifetimeCount.present
          ? data.totalLifetimeCount.value
          : this.totalLifetimeCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JaapProfilesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('originalText: $originalText, ')
          ..write('transliteration: $transliteration, ')
          ..write('category: $category, ')
          ..write('malaSize: $malaSize, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('accentColorHex: $accentColorHex, ')
          ..write('currentCount: $currentCount, ')
          ..write('totalMalasCompleted: $totalMalasCompleted, ')
          ..write('totalLifetimeCount: $totalLifetimeCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    originalText,
    transliteration,
    category,
    malaSize,
    dailyGoal,
    accentColorHex,
    currentCount,
    totalMalasCompleted,
    totalLifetimeCount,
    createdAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JaapProfilesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.originalText == this.originalText &&
          other.transliteration == this.transliteration &&
          other.category == this.category &&
          other.malaSize == this.malaSize &&
          other.dailyGoal == this.dailyGoal &&
          other.accentColorHex == this.accentColorHex &&
          other.currentCount == this.currentCount &&
          other.totalMalasCompleted == this.totalMalasCompleted &&
          other.totalLifetimeCount == this.totalLifetimeCount &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class JaapProfilesTableCompanion
    extends UpdateCompanion<JaapProfilesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> originalText;
  final Value<String> transliteration;
  final Value<String> category;
  final Value<int> malaSize;
  final Value<int> dailyGoal;
  final Value<String> accentColorHex;
  final Value<int> currentCount;
  final Value<int> totalMalasCompleted;
  final Value<int> totalLifetimeCount;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const JaapProfilesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.originalText = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.category = const Value.absent(),
    this.malaSize = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.accentColorHex = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.totalMalasCompleted = const Value.absent(),
    this.totalLifetimeCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JaapProfilesTableCompanion.insert({
    required String id,
    required String name,
    this.originalText = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.category = const Value.absent(),
    this.malaSize = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.accentColorHex = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.totalMalasCompleted = const Value.absent(),
    this.totalLifetimeCount = const Value.absent(),
    required DateTime createdAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<JaapProfilesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? originalText,
    Expression<String>? transliteration,
    Expression<String>? category,
    Expression<int>? malaSize,
    Expression<int>? dailyGoal,
    Expression<String>? accentColorHex,
    Expression<int>? currentCount,
    Expression<int>? totalMalasCompleted,
    Expression<int>? totalLifetimeCount,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (originalText != null) 'original_text': originalText,
      if (transliteration != null) 'transliteration': transliteration,
      if (category != null) 'category': category,
      if (malaSize != null) 'mala_size': malaSize,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (accentColorHex != null) 'accent_color_hex': accentColorHex,
      if (currentCount != null) 'current_count': currentCount,
      if (totalMalasCompleted != null)
        'total_malas_completed': totalMalasCompleted,
      if (totalLifetimeCount != null)
        'total_lifetime_count': totalLifetimeCount,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JaapProfilesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? originalText,
    Value<String>? transliteration,
    Value<String>? category,
    Value<int>? malaSize,
    Value<int>? dailyGoal,
    Value<String>? accentColorHex,
    Value<int>? currentCount,
    Value<int>? totalMalasCompleted,
    Value<int>? totalLifetimeCount,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return JaapProfilesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      originalText: originalText ?? this.originalText,
      transliteration: transliteration ?? this.transliteration,
      category: category ?? this.category,
      malaSize: malaSize ?? this.malaSize,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      currentCount: currentCount ?? this.currentCount,
      totalMalasCompleted: totalMalasCompleted ?? this.totalMalasCompleted,
      totalLifetimeCount: totalLifetimeCount ?? this.totalLifetimeCount,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (malaSize.present) {
      map['mala_size'] = Variable<int>(malaSize.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (accentColorHex.present) {
      map['accent_color_hex'] = Variable<String>(accentColorHex.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (totalMalasCompleted.present) {
      map['total_malas_completed'] = Variable<int>(totalMalasCompleted.value);
    }
    if (totalLifetimeCount.present) {
      map['total_lifetime_count'] = Variable<int>(totalLifetimeCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JaapProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('originalText: $originalText, ')
          ..write('transliteration: $transliteration, ')
          ..write('category: $category, ')
          ..write('malaSize: $malaSize, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('accentColorHex: $accentColorHex, ')
          ..write('currentCount: $currentCount, ')
          ..write('totalMalasCompleted: $totalMalasCompleted, ')
          ..write('totalLifetimeCount: $totalLifetimeCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JaapSessionsTableTable extends JaapSessionsTable
    with TableInfo<$JaapSessionsTableTable, JaapSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JaapSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jaapProfileIdMeta = const VerificationMeta(
    'jaapProfileId',
  );
  @override
  late final GeneratedColumn<String> jaapProfileId = GeneratedColumn<String>(
    'jaap_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jaap_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _jaapProfileNameMeta = const VerificationMeta(
    'jaapProfileName',
  );
  @override
  late final GeneratedColumn<String> jaapProfileName = GeneratedColumn<String>(
    'jaap_profile_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _malaCompletedMeta = const VerificationMeta(
    'malaCompleted',
  );
  @override
  late final GeneratedColumn<int> malaCompleted = GeneratedColumn<int>(
    'mala_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isManualEntryMeta = const VerificationMeta(
    'isManualEntry',
  );
  @override
  late final GeneratedColumn<bool> isManualEntry = GeneratedColumn<bool>(
    'is_manual_entry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual_entry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jaapProfileId,
    jaapProfileName,
    date,
    count,
    malaCompleted,
    durationSeconds,
    isManualEntry,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jaap_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<JaapSessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('jaap_profile_id')) {
      context.handle(
        _jaapProfileIdMeta,
        jaapProfileId.isAcceptableOrUnknown(
          data['jaap_profile_id']!,
          _jaapProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jaapProfileIdMeta);
    }
    if (data.containsKey('jaap_profile_name')) {
      context.handle(
        _jaapProfileNameMeta,
        jaapProfileName.isAcceptableOrUnknown(
          data['jaap_profile_name']!,
          _jaapProfileNameMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('mala_completed')) {
      context.handle(
        _malaCompletedMeta,
        malaCompleted.isAcceptableOrUnknown(
          data['mala_completed']!,
          _malaCompletedMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_manual_entry')) {
      context.handle(
        _isManualEntryMeta,
        isManualEntry.isAcceptableOrUnknown(
          data['is_manual_entry']!,
          _isManualEntryMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JaapSessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JaapSessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jaapProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jaap_profile_id'],
      )!,
      jaapProfileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jaap_profile_name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      malaCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mala_completed'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      isManualEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual_entry'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $JaapSessionsTableTable createAlias(String alias) {
    return $JaapSessionsTableTable(attachedDatabase, alias);
  }
}

class JaapSessionsTableData extends DataClass
    implements Insertable<JaapSessionsTableData> {
  final String id;
  final String jaapProfileId;
  final String jaapProfileName;
  final DateTime date;
  final int count;
  final int malaCompleted;
  final int durationSeconds;
  final bool isManualEntry;
  final DateTime createdAt;
  const JaapSessionsTableData({
    required this.id,
    required this.jaapProfileId,
    required this.jaapProfileName,
    required this.date,
    required this.count,
    required this.malaCompleted,
    required this.durationSeconds,
    required this.isManualEntry,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['jaap_profile_id'] = Variable<String>(jaapProfileId);
    map['jaap_profile_name'] = Variable<String>(jaapProfileName);
    map['date'] = Variable<DateTime>(date);
    map['count'] = Variable<int>(count);
    map['mala_completed'] = Variable<int>(malaCompleted);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['is_manual_entry'] = Variable<bool>(isManualEntry);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JaapSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return JaapSessionsTableCompanion(
      id: Value(id),
      jaapProfileId: Value(jaapProfileId),
      jaapProfileName: Value(jaapProfileName),
      date: Value(date),
      count: Value(count),
      malaCompleted: Value(malaCompleted),
      durationSeconds: Value(durationSeconds),
      isManualEntry: Value(isManualEntry),
      createdAt: Value(createdAt),
    );
  }

  factory JaapSessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JaapSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      jaapProfileId: serializer.fromJson<String>(json['jaapProfileId']),
      jaapProfileName: serializer.fromJson<String>(json['jaapProfileName']),
      date: serializer.fromJson<DateTime>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      malaCompleted: serializer.fromJson<int>(json['malaCompleted']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      isManualEntry: serializer.fromJson<bool>(json['isManualEntry']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jaapProfileId': serializer.toJson<String>(jaapProfileId),
      'jaapProfileName': serializer.toJson<String>(jaapProfileName),
      'date': serializer.toJson<DateTime>(date),
      'count': serializer.toJson<int>(count),
      'malaCompleted': serializer.toJson<int>(malaCompleted),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'isManualEntry': serializer.toJson<bool>(isManualEntry),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JaapSessionsTableData copyWith({
    String? id,
    String? jaapProfileId,
    String? jaapProfileName,
    DateTime? date,
    int? count,
    int? malaCompleted,
    int? durationSeconds,
    bool? isManualEntry,
    DateTime? createdAt,
  }) => JaapSessionsTableData(
    id: id ?? this.id,
    jaapProfileId: jaapProfileId ?? this.jaapProfileId,
    jaapProfileName: jaapProfileName ?? this.jaapProfileName,
    date: date ?? this.date,
    count: count ?? this.count,
    malaCompleted: malaCompleted ?? this.malaCompleted,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    isManualEntry: isManualEntry ?? this.isManualEntry,
    createdAt: createdAt ?? this.createdAt,
  );
  JaapSessionsTableData copyWithCompanion(JaapSessionsTableCompanion data) {
    return JaapSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      jaapProfileId: data.jaapProfileId.present
          ? data.jaapProfileId.value
          : this.jaapProfileId,
      jaapProfileName: data.jaapProfileName.present
          ? data.jaapProfileName.value
          : this.jaapProfileName,
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      malaCompleted: data.malaCompleted.present
          ? data.malaCompleted.value
          : this.malaCompleted,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      isManualEntry: data.isManualEntry.present
          ? data.isManualEntry.value
          : this.isManualEntry,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JaapSessionsTableData(')
          ..write('id: $id, ')
          ..write('jaapProfileId: $jaapProfileId, ')
          ..write('jaapProfileName: $jaapProfileName, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('malaCompleted: $malaCompleted, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('isManualEntry: $isManualEntry, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jaapProfileId,
    jaapProfileName,
    date,
    count,
    malaCompleted,
    durationSeconds,
    isManualEntry,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JaapSessionsTableData &&
          other.id == this.id &&
          other.jaapProfileId == this.jaapProfileId &&
          other.jaapProfileName == this.jaapProfileName &&
          other.date == this.date &&
          other.count == this.count &&
          other.malaCompleted == this.malaCompleted &&
          other.durationSeconds == this.durationSeconds &&
          other.isManualEntry == this.isManualEntry &&
          other.createdAt == this.createdAt);
}

class JaapSessionsTableCompanion
    extends UpdateCompanion<JaapSessionsTableData> {
  final Value<String> id;
  final Value<String> jaapProfileId;
  final Value<String> jaapProfileName;
  final Value<DateTime> date;
  final Value<int> count;
  final Value<int> malaCompleted;
  final Value<int> durationSeconds;
  final Value<bool> isManualEntry;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const JaapSessionsTableCompanion({
    this.id = const Value.absent(),
    this.jaapProfileId = const Value.absent(),
    this.jaapProfileName = const Value.absent(),
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.malaCompleted = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.isManualEntry = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JaapSessionsTableCompanion.insert({
    required String id,
    required String jaapProfileId,
    this.jaapProfileName = const Value.absent(),
    required DateTime date,
    this.count = const Value.absent(),
    this.malaCompleted = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.isManualEntry = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jaapProfileId = Value(jaapProfileId),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<JaapSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? jaapProfileId,
    Expression<String>? jaapProfileName,
    Expression<DateTime>? date,
    Expression<int>? count,
    Expression<int>? malaCompleted,
    Expression<int>? durationSeconds,
    Expression<bool>? isManualEntry,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jaapProfileId != null) 'jaap_profile_id': jaapProfileId,
      if (jaapProfileName != null) 'jaap_profile_name': jaapProfileName,
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (malaCompleted != null) 'mala_completed': malaCompleted,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (isManualEntry != null) 'is_manual_entry': isManualEntry,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JaapSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jaapProfileId,
    Value<String>? jaapProfileName,
    Value<DateTime>? date,
    Value<int>? count,
    Value<int>? malaCompleted,
    Value<int>? durationSeconds,
    Value<bool>? isManualEntry,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return JaapSessionsTableCompanion(
      id: id ?? this.id,
      jaapProfileId: jaapProfileId ?? this.jaapProfileId,
      jaapProfileName: jaapProfileName ?? this.jaapProfileName,
      date: date ?? this.date,
      count: count ?? this.count,
      malaCompleted: malaCompleted ?? this.malaCompleted,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jaapProfileId.present) {
      map['jaap_profile_id'] = Variable<String>(jaapProfileId.value);
    }
    if (jaapProfileName.present) {
      map['jaap_profile_name'] = Variable<String>(jaapProfileName.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (malaCompleted.present) {
      map['mala_completed'] = Variable<int>(malaCompleted.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (isManualEntry.present) {
      map['is_manual_entry'] = Variable<bool>(isManualEntry.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JaapSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('jaapProfileId: $jaapProfileId, ')
          ..write('jaapProfileName: $jaapProfileName, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('malaCompleted: $malaCompleted, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('isManualEntry: $isManualEntry, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SankalpGoalsTableTable extends SankalpGoalsTable
    with TableInfo<$SankalpGoalsTableTable, SankalpGoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SankalpGoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jaapProfileIdMeta = const VerificationMeta(
    'jaapProfileId',
  );
  @override
  late final GeneratedColumn<String> jaapProfileId = GeneratedColumn<String>(
    'jaap_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES jaap_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('40-Day Sankalp'),
  );
  static const VerificationMeta _targetCountMeta = const VerificationMeta(
    'targetCount',
  );
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
    'target_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(43200),
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDaysMeta = const VerificationMeta(
    'totalDays',
  );
  @override
  late final GeneratedColumn<int> totalDays = GeneratedColumn<int>(
    'total_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(40),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jaapProfileId,
    title,
    targetCount,
    currentCount,
    totalDays,
    startDate,
    endDate,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sankalp_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SankalpGoalsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('jaap_profile_id')) {
      context.handle(
        _jaapProfileIdMeta,
        jaapProfileId.isAcceptableOrUnknown(
          data['jaap_profile_id']!,
          _jaapProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jaapProfileIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('target_count')) {
      context.handle(
        _targetCountMeta,
        targetCount.isAcceptableOrUnknown(
          data['target_count']!,
          _targetCountMeta,
        ),
      );
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('total_days')) {
      context.handle(
        _totalDaysMeta,
        totalDays.isAcceptableOrUnknown(data['total_days']!, _totalDaysMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SankalpGoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SankalpGoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jaapProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jaap_profile_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_count'],
      )!,
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      totalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_days'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $SankalpGoalsTableTable createAlias(String alias) {
    return $SankalpGoalsTableTable(attachedDatabase, alias);
  }
}

class SankalpGoalsTableData extends DataClass
    implements Insertable<SankalpGoalsTableData> {
  final String id;
  final String jaapProfileId;
  final String title;
  final int targetCount;
  final int currentCount;
  final int totalDays;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  const SankalpGoalsTableData({
    required this.id,
    required this.jaapProfileId,
    required this.title,
    required this.targetCount,
    required this.currentCount,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['jaap_profile_id'] = Variable<String>(jaapProfileId);
    map['title'] = Variable<String>(title);
    map['target_count'] = Variable<int>(targetCount);
    map['current_count'] = Variable<int>(currentCount);
    map['total_days'] = Variable<int>(totalDays);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  SankalpGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return SankalpGoalsTableCompanion(
      id: Value(id),
      jaapProfileId: Value(jaapProfileId),
      title: Value(title),
      targetCount: Value(targetCount),
      currentCount: Value(currentCount),
      totalDays: Value(totalDays),
      startDate: Value(startDate),
      endDate: Value(endDate),
      isCompleted: Value(isCompleted),
    );
  }

  factory SankalpGoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SankalpGoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      jaapProfileId: serializer.fromJson<String>(json['jaapProfileId']),
      title: serializer.fromJson<String>(json['title']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      totalDays: serializer.fromJson<int>(json['totalDays']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jaapProfileId': serializer.toJson<String>(jaapProfileId),
      'title': serializer.toJson<String>(title),
      'targetCount': serializer.toJson<int>(targetCount),
      'currentCount': serializer.toJson<int>(currentCount),
      'totalDays': serializer.toJson<int>(totalDays),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  SankalpGoalsTableData copyWith({
    String? id,
    String? jaapProfileId,
    String? title,
    int? targetCount,
    int? currentCount,
    int? totalDays,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
  }) => SankalpGoalsTableData(
    id: id ?? this.id,
    jaapProfileId: jaapProfileId ?? this.jaapProfileId,
    title: title ?? this.title,
    targetCount: targetCount ?? this.targetCount,
    currentCount: currentCount ?? this.currentCount,
    totalDays: totalDays ?? this.totalDays,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  SankalpGoalsTableData copyWithCompanion(SankalpGoalsTableCompanion data) {
    return SankalpGoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      jaapProfileId: data.jaapProfileId.present
          ? data.jaapProfileId.value
          : this.jaapProfileId,
      title: data.title.present ? data.title.value : this.title,
      targetCount: data.targetCount.present
          ? data.targetCount.value
          : this.targetCount,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      totalDays: data.totalDays.present ? data.totalDays.value : this.totalDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SankalpGoalsTableData(')
          ..write('id: $id, ')
          ..write('jaapProfileId: $jaapProfileId, ')
          ..write('title: $title, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('totalDays: $totalDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jaapProfileId,
    title,
    targetCount,
    currentCount,
    totalDays,
    startDate,
    endDate,
    isCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SankalpGoalsTableData &&
          other.id == this.id &&
          other.jaapProfileId == this.jaapProfileId &&
          other.title == this.title &&
          other.targetCount == this.targetCount &&
          other.currentCount == this.currentCount &&
          other.totalDays == this.totalDays &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isCompleted == this.isCompleted);
}

class SankalpGoalsTableCompanion
    extends UpdateCompanion<SankalpGoalsTableData> {
  final Value<String> id;
  final Value<String> jaapProfileId;
  final Value<String> title;
  final Value<int> targetCount;
  final Value<int> currentCount;
  final Value<int> totalDays;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const SankalpGoalsTableCompanion({
    this.id = const Value.absent(),
    this.jaapProfileId = const Value.absent(),
    this.title = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.totalDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SankalpGoalsTableCompanion.insert({
    required String id,
    required String jaapProfileId,
    this.title = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.totalDays = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jaapProfileId = Value(jaapProfileId),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<SankalpGoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? jaapProfileId,
    Expression<String>? title,
    Expression<int>? targetCount,
    Expression<int>? currentCount,
    Expression<int>? totalDays,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jaapProfileId != null) 'jaap_profile_id': jaapProfileId,
      if (title != null) 'title': title,
      if (targetCount != null) 'target_count': targetCount,
      if (currentCount != null) 'current_count': currentCount,
      if (totalDays != null) 'total_days': totalDays,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SankalpGoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? jaapProfileId,
    Value<String>? title,
    Value<int>? targetCount,
    Value<int>? currentCount,
    Value<int>? totalDays,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return SankalpGoalsTableCompanion(
      id: id ?? this.id,
      jaapProfileId: jaapProfileId ?? this.jaapProfileId,
      title: title ?? this.title,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      totalDays: totalDays ?? this.totalDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jaapProfileId.present) {
      map['jaap_profile_id'] = Variable<String>(jaapProfileId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (totalDays.present) {
      map['total_days'] = Variable<int>(totalDays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SankalpGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('jaapProfileId: $jaapProfileId, ')
          ..write('title: $title, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('totalDays: $totalDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _localeCodeMeta = const VerificationMeta(
    'localeCode',
  );
  @override
  late final GeneratedColumn<String> localeCode = GeneratedColumn<String>(
    'locale_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<int> themeMode = GeneratedColumn<int>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accentIndexMeta = const VerificationMeta(
    'accentIndex',
  );
  @override
  late final GeneratedColumn<int> accentIndex = GeneratedColumn<int>(
    'accent_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hapticLevelMeta = const VerificationMeta(
    'hapticLevel',
  );
  @override
  late final GeneratedColumn<int> hapticLevel = GeneratedColumn<int>(
    'haptic_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _tapSoundMeta = const VerificationMeta(
    'tapSound',
  );
  @override
  late final GeneratedColumn<int> tapSound = GeneratedColumn<int>(
    'tap_sound',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _completionSoundMeta = const VerificationMeta(
    'completionSound',
  );
  @override
  late final GeneratedColumn<int> completionSound = GeneratedColumn<int>(
    'completion_sound',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _counterStyleMeta = const VerificationMeta(
    'counterStyle',
  );
  @override
  late final GeneratedColumn<int> counterStyle = GeneratedColumn<int>(
    'counter_style',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _keepScreenAwakeMeta = const VerificationMeta(
    'keepScreenAwake',
  );
  @override
  late final GeneratedColumn<bool> keepScreenAwake = GeneratedColumn<bool>(
    'keep_screen_awake',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("keep_screen_awake" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _streakTrackingMeta = const VerificationMeta(
    'streakTracking',
  );
  @override
  late final GeneratedColumn<bool> streakTracking = GeneratedColumn<bool>(
    'streak_tracking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("streak_tracking" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoStartNextMalaMeta = const VerificationMeta(
    'autoStartNextMala',
  );
  @override
  late final GeneratedColumn<bool> autoStartNextMala = GeneratedColumn<bool>(
    'auto_start_next_mala',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_next_mala" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isOnboardingCompletedMeta =
      const VerificationMeta('isOnboardingCompleted');
  @override
  late final GeneratedColumn<bool> isOnboardingCompleted =
      GeneratedColumn<bool>(
        'is_onboarding_completed',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_onboarding_completed" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _activeProfileIdMeta = const VerificationMeta(
    'activeProfileId',
  );
  @override
  late final GeneratedColumn<String> activeProfileId = GeneratedColumn<String>(
    'active_profile_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localeCode,
    themeMode,
    accentIndex,
    hapticLevel,
    tapSound,
    completionSound,
    counterStyle,
    keepScreenAwake,
    streakTracking,
    autoStartNextMala,
    isOnboardingCompleted,
    activeProfileId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('locale_code')) {
      context.handle(
        _localeCodeMeta,
        localeCode.isAcceptableOrUnknown(data['locale_code']!, _localeCodeMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('accent_index')) {
      context.handle(
        _accentIndexMeta,
        accentIndex.isAcceptableOrUnknown(
          data['accent_index']!,
          _accentIndexMeta,
        ),
      );
    }
    if (data.containsKey('haptic_level')) {
      context.handle(
        _hapticLevelMeta,
        hapticLevel.isAcceptableOrUnknown(
          data['haptic_level']!,
          _hapticLevelMeta,
        ),
      );
    }
    if (data.containsKey('tap_sound')) {
      context.handle(
        _tapSoundMeta,
        tapSound.isAcceptableOrUnknown(data['tap_sound']!, _tapSoundMeta),
      );
    }
    if (data.containsKey('completion_sound')) {
      context.handle(
        _completionSoundMeta,
        completionSound.isAcceptableOrUnknown(
          data['completion_sound']!,
          _completionSoundMeta,
        ),
      );
    }
    if (data.containsKey('counter_style')) {
      context.handle(
        _counterStyleMeta,
        counterStyle.isAcceptableOrUnknown(
          data['counter_style']!,
          _counterStyleMeta,
        ),
      );
    }
    if (data.containsKey('keep_screen_awake')) {
      context.handle(
        _keepScreenAwakeMeta,
        keepScreenAwake.isAcceptableOrUnknown(
          data['keep_screen_awake']!,
          _keepScreenAwakeMeta,
        ),
      );
    }
    if (data.containsKey('streak_tracking')) {
      context.handle(
        _streakTrackingMeta,
        streakTracking.isAcceptableOrUnknown(
          data['streak_tracking']!,
          _streakTrackingMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_next_mala')) {
      context.handle(
        _autoStartNextMalaMeta,
        autoStartNextMala.isAcceptableOrUnknown(
          data['auto_start_next_mala']!,
          _autoStartNextMalaMeta,
        ),
      );
    }
    if (data.containsKey('is_onboarding_completed')) {
      context.handle(
        _isOnboardingCompletedMeta,
        isOnboardingCompleted.isAcceptableOrUnknown(
          data['is_onboarding_completed']!,
          _isOnboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('active_profile_id')) {
      context.handle(
        _activeProfileIdMeta,
        activeProfileId.isAcceptableOrUnknown(
          data['active_profile_id']!,
          _activeProfileIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      localeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_code'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_mode'],
      )!,
      accentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent_index'],
      )!,
      hapticLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}haptic_level'],
      )!,
      tapSound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tap_sound'],
      )!,
      completionSound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completion_sound'],
      )!,
      counterStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counter_style'],
      )!,
      keepScreenAwake: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}keep_screen_awake'],
      )!,
      streakTracking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}streak_tracking'],
      )!,
      autoStartNextMala: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_next_mala'],
      )!,
      isOnboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_onboarding_completed'],
      )!,
      activeProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_profile_id'],
      ),
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsTableData extends DataClass
    implements Insertable<UserSettingsTableData> {
  final int id;
  final String localeCode;
  final int themeMode;
  final int accentIndex;
  final int hapticLevel;
  final int tapSound;
  final int completionSound;
  final int counterStyle;
  final bool keepScreenAwake;
  final bool streakTracking;
  final bool autoStartNextMala;
  final bool isOnboardingCompleted;
  final String? activeProfileId;
  const UserSettingsTableData({
    required this.id,
    required this.localeCode,
    required this.themeMode,
    required this.accentIndex,
    required this.hapticLevel,
    required this.tapSound,
    required this.completionSound,
    required this.counterStyle,
    required this.keepScreenAwake,
    required this.streakTracking,
    required this.autoStartNextMala,
    required this.isOnboardingCompleted,
    this.activeProfileId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['locale_code'] = Variable<String>(localeCode);
    map['theme_mode'] = Variable<int>(themeMode);
    map['accent_index'] = Variable<int>(accentIndex);
    map['haptic_level'] = Variable<int>(hapticLevel);
    map['tap_sound'] = Variable<int>(tapSound);
    map['completion_sound'] = Variable<int>(completionSound);
    map['counter_style'] = Variable<int>(counterStyle);
    map['keep_screen_awake'] = Variable<bool>(keepScreenAwake);
    map['streak_tracking'] = Variable<bool>(streakTracking);
    map['auto_start_next_mala'] = Variable<bool>(autoStartNextMala);
    map['is_onboarding_completed'] = Variable<bool>(isOnboardingCompleted);
    if (!nullToAbsent || activeProfileId != null) {
      map['active_profile_id'] = Variable<String>(activeProfileId);
    }
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      localeCode: Value(localeCode),
      themeMode: Value(themeMode),
      accentIndex: Value(accentIndex),
      hapticLevel: Value(hapticLevel),
      tapSound: Value(tapSound),
      completionSound: Value(completionSound),
      counterStyle: Value(counterStyle),
      keepScreenAwake: Value(keepScreenAwake),
      streakTracking: Value(streakTracking),
      autoStartNextMala: Value(autoStartNextMala),
      isOnboardingCompleted: Value(isOnboardingCompleted),
      activeProfileId: activeProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeProfileId),
    );
  }

  factory UserSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      localeCode: serializer.fromJson<String>(json['localeCode']),
      themeMode: serializer.fromJson<int>(json['themeMode']),
      accentIndex: serializer.fromJson<int>(json['accentIndex']),
      hapticLevel: serializer.fromJson<int>(json['hapticLevel']),
      tapSound: serializer.fromJson<int>(json['tapSound']),
      completionSound: serializer.fromJson<int>(json['completionSound']),
      counterStyle: serializer.fromJson<int>(json['counterStyle']),
      keepScreenAwake: serializer.fromJson<bool>(json['keepScreenAwake']),
      streakTracking: serializer.fromJson<bool>(json['streakTracking']),
      autoStartNextMala: serializer.fromJson<bool>(json['autoStartNextMala']),
      isOnboardingCompleted: serializer.fromJson<bool>(
        json['isOnboardingCompleted'],
      ),
      activeProfileId: serializer.fromJson<String?>(json['activeProfileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localeCode': serializer.toJson<String>(localeCode),
      'themeMode': serializer.toJson<int>(themeMode),
      'accentIndex': serializer.toJson<int>(accentIndex),
      'hapticLevel': serializer.toJson<int>(hapticLevel),
      'tapSound': serializer.toJson<int>(tapSound),
      'completionSound': serializer.toJson<int>(completionSound),
      'counterStyle': serializer.toJson<int>(counterStyle),
      'keepScreenAwake': serializer.toJson<bool>(keepScreenAwake),
      'streakTracking': serializer.toJson<bool>(streakTracking),
      'autoStartNextMala': serializer.toJson<bool>(autoStartNextMala),
      'isOnboardingCompleted': serializer.toJson<bool>(isOnboardingCompleted),
      'activeProfileId': serializer.toJson<String?>(activeProfileId),
    };
  }

  UserSettingsTableData copyWith({
    int? id,
    String? localeCode,
    int? themeMode,
    int? accentIndex,
    int? hapticLevel,
    int? tapSound,
    int? completionSound,
    int? counterStyle,
    bool? keepScreenAwake,
    bool? streakTracking,
    bool? autoStartNextMala,
    bool? isOnboardingCompleted,
    Value<String?> activeProfileId = const Value.absent(),
  }) => UserSettingsTableData(
    id: id ?? this.id,
    localeCode: localeCode ?? this.localeCode,
    themeMode: themeMode ?? this.themeMode,
    accentIndex: accentIndex ?? this.accentIndex,
    hapticLevel: hapticLevel ?? this.hapticLevel,
    tapSound: tapSound ?? this.tapSound,
    completionSound: completionSound ?? this.completionSound,
    counterStyle: counterStyle ?? this.counterStyle,
    keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
    streakTracking: streakTracking ?? this.streakTracking,
    autoStartNextMala: autoStartNextMala ?? this.autoStartNextMala,
    isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
    activeProfileId: activeProfileId.present
        ? activeProfileId.value
        : this.activeProfileId,
  );
  UserSettingsTableData copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      localeCode: data.localeCode.present
          ? data.localeCode.value
          : this.localeCode,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accentIndex: data.accentIndex.present
          ? data.accentIndex.value
          : this.accentIndex,
      hapticLevel: data.hapticLevel.present
          ? data.hapticLevel.value
          : this.hapticLevel,
      tapSound: data.tapSound.present ? data.tapSound.value : this.tapSound,
      completionSound: data.completionSound.present
          ? data.completionSound.value
          : this.completionSound,
      counterStyle: data.counterStyle.present
          ? data.counterStyle.value
          : this.counterStyle,
      keepScreenAwake: data.keepScreenAwake.present
          ? data.keepScreenAwake.value
          : this.keepScreenAwake,
      streakTracking: data.streakTracking.present
          ? data.streakTracking.value
          : this.streakTracking,
      autoStartNextMala: data.autoStartNextMala.present
          ? data.autoStartNextMala.value
          : this.autoStartNextMala,
      isOnboardingCompleted: data.isOnboardingCompleted.present
          ? data.isOnboardingCompleted.value
          : this.isOnboardingCompleted,
      activeProfileId: data.activeProfileId.present
          ? data.activeProfileId.value
          : this.activeProfileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableData(')
          ..write('id: $id, ')
          ..write('localeCode: $localeCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentIndex: $accentIndex, ')
          ..write('hapticLevel: $hapticLevel, ')
          ..write('tapSound: $tapSound, ')
          ..write('completionSound: $completionSound, ')
          ..write('counterStyle: $counterStyle, ')
          ..write('keepScreenAwake: $keepScreenAwake, ')
          ..write('streakTracking: $streakTracking, ')
          ..write('autoStartNextMala: $autoStartNextMala, ')
          ..write('isOnboardingCompleted: $isOnboardingCompleted, ')
          ..write('activeProfileId: $activeProfileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localeCode,
    themeMode,
    accentIndex,
    hapticLevel,
    tapSound,
    completionSound,
    counterStyle,
    keepScreenAwake,
    streakTracking,
    autoStartNextMala,
    isOnboardingCompleted,
    activeProfileId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsTableData &&
          other.id == this.id &&
          other.localeCode == this.localeCode &&
          other.themeMode == this.themeMode &&
          other.accentIndex == this.accentIndex &&
          other.hapticLevel == this.hapticLevel &&
          other.tapSound == this.tapSound &&
          other.completionSound == this.completionSound &&
          other.counterStyle == this.counterStyle &&
          other.keepScreenAwake == this.keepScreenAwake &&
          other.streakTracking == this.streakTracking &&
          other.autoStartNextMala == this.autoStartNextMala &&
          other.isOnboardingCompleted == this.isOnboardingCompleted &&
          other.activeProfileId == this.activeProfileId);
}

class UserSettingsTableCompanion
    extends UpdateCompanion<UserSettingsTableData> {
  final Value<int> id;
  final Value<String> localeCode;
  final Value<int> themeMode;
  final Value<int> accentIndex;
  final Value<int> hapticLevel;
  final Value<int> tapSound;
  final Value<int> completionSound;
  final Value<int> counterStyle;
  final Value<bool> keepScreenAwake;
  final Value<bool> streakTracking;
  final Value<bool> autoStartNextMala;
  final Value<bool> isOnboardingCompleted;
  final Value<String?> activeProfileId;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.localeCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentIndex = const Value.absent(),
    this.hapticLevel = const Value.absent(),
    this.tapSound = const Value.absent(),
    this.completionSound = const Value.absent(),
    this.counterStyle = const Value.absent(),
    this.keepScreenAwake = const Value.absent(),
    this.streakTracking = const Value.absent(),
    this.autoStartNextMala = const Value.absent(),
    this.isOnboardingCompleted = const Value.absent(),
    this.activeProfileId = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.localeCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentIndex = const Value.absent(),
    this.hapticLevel = const Value.absent(),
    this.tapSound = const Value.absent(),
    this.completionSound = const Value.absent(),
    this.counterStyle = const Value.absent(),
    this.keepScreenAwake = const Value.absent(),
    this.streakTracking = const Value.absent(),
    this.autoStartNextMala = const Value.absent(),
    this.isOnboardingCompleted = const Value.absent(),
    this.activeProfileId = const Value.absent(),
  });
  static Insertable<UserSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? localeCode,
    Expression<int>? themeMode,
    Expression<int>? accentIndex,
    Expression<int>? hapticLevel,
    Expression<int>? tapSound,
    Expression<int>? completionSound,
    Expression<int>? counterStyle,
    Expression<bool>? keepScreenAwake,
    Expression<bool>? streakTracking,
    Expression<bool>? autoStartNextMala,
    Expression<bool>? isOnboardingCompleted,
    Expression<String>? activeProfileId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localeCode != null) 'locale_code': localeCode,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accentIndex != null) 'accent_index': accentIndex,
      if (hapticLevel != null) 'haptic_level': hapticLevel,
      if (tapSound != null) 'tap_sound': tapSound,
      if (completionSound != null) 'completion_sound': completionSound,
      if (counterStyle != null) 'counter_style': counterStyle,
      if (keepScreenAwake != null) 'keep_screen_awake': keepScreenAwake,
      if (streakTracking != null) 'streak_tracking': streakTracking,
      if (autoStartNextMala != null) 'auto_start_next_mala': autoStartNextMala,
      if (isOnboardingCompleted != null)
        'is_onboarding_completed': isOnboardingCompleted,
      if (activeProfileId != null) 'active_profile_id': activeProfileId,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? localeCode,
    Value<int>? themeMode,
    Value<int>? accentIndex,
    Value<int>? hapticLevel,
    Value<int>? tapSound,
    Value<int>? completionSound,
    Value<int>? counterStyle,
    Value<bool>? keepScreenAwake,
    Value<bool>? streakTracking,
    Value<bool>? autoStartNextMala,
    Value<bool>? isOnboardingCompleted,
    Value<String?>? activeProfileId,
  }) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      localeCode: localeCode ?? this.localeCode,
      themeMode: themeMode ?? this.themeMode,
      accentIndex: accentIndex ?? this.accentIndex,
      hapticLevel: hapticLevel ?? this.hapticLevel,
      tapSound: tapSound ?? this.tapSound,
      completionSound: completionSound ?? this.completionSound,
      counterStyle: counterStyle ?? this.counterStyle,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      streakTracking: streakTracking ?? this.streakTracking,
      autoStartNextMala: autoStartNextMala ?? this.autoStartNextMala,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      activeProfileId: activeProfileId ?? this.activeProfileId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(localeCode.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(themeMode.value);
    }
    if (accentIndex.present) {
      map['accent_index'] = Variable<int>(accentIndex.value);
    }
    if (hapticLevel.present) {
      map['haptic_level'] = Variable<int>(hapticLevel.value);
    }
    if (tapSound.present) {
      map['tap_sound'] = Variable<int>(tapSound.value);
    }
    if (completionSound.present) {
      map['completion_sound'] = Variable<int>(completionSound.value);
    }
    if (counterStyle.present) {
      map['counter_style'] = Variable<int>(counterStyle.value);
    }
    if (keepScreenAwake.present) {
      map['keep_screen_awake'] = Variable<bool>(keepScreenAwake.value);
    }
    if (streakTracking.present) {
      map['streak_tracking'] = Variable<bool>(streakTracking.value);
    }
    if (autoStartNextMala.present) {
      map['auto_start_next_mala'] = Variable<bool>(autoStartNextMala.value);
    }
    if (isOnboardingCompleted.present) {
      map['is_onboarding_completed'] = Variable<bool>(
        isOnboardingCompleted.value,
      );
    }
    if (activeProfileId.present) {
      map['active_profile_id'] = Variable<String>(activeProfileId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('localeCode: $localeCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentIndex: $accentIndex, ')
          ..write('hapticLevel: $hapticLevel, ')
          ..write('tapSound: $tapSound, ')
          ..write('completionSound: $completionSound, ')
          ..write('counterStyle: $counterStyle, ')
          ..write('keepScreenAwake: $keepScreenAwake, ')
          ..write('streakTracking: $streakTracking, ')
          ..write('autoStartNextMala: $autoStartNextMala, ')
          ..write('isOnboardingCompleted: $isOnboardingCompleted, ')
          ..write('activeProfileId: $activeProfileId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JaapProfilesTableTable jaapProfilesTable =
      $JaapProfilesTableTable(this);
  late final $JaapSessionsTableTable jaapSessionsTable =
      $JaapSessionsTableTable(this);
  late final $SankalpGoalsTableTable sankalpGoalsTable =
      $SankalpGoalsTableTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    jaapProfilesTable,
    jaapSessionsTable,
    sankalpGoalsTable,
    userSettingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'jaap_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('jaap_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'jaap_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sankalp_goals', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$JaapProfilesTableTableCreateCompanionBuilder =
    JaapProfilesTableCompanion Function({
      required String id,
      required String name,
      Value<String> originalText,
      Value<String> transliteration,
      Value<String> category,
      Value<int> malaSize,
      Value<int> dailyGoal,
      Value<String> accentColorHex,
      Value<int> currentCount,
      Value<int> totalMalasCompleted,
      Value<int> totalLifetimeCount,
      required DateTime createdAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$JaapProfilesTableTableUpdateCompanionBuilder =
    JaapProfilesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> originalText,
      Value<String> transliteration,
      Value<String> category,
      Value<int> malaSize,
      Value<int> dailyGoal,
      Value<String> accentColorHex,
      Value<int> currentCount,
      Value<int> totalMalasCompleted,
      Value<int> totalLifetimeCount,
      Value<DateTime> createdAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$JaapProfilesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $JaapProfilesTableTable,
          JaapProfilesTableData
        > {
  $$JaapProfilesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $JaapSessionsTableTable,
    List<JaapSessionsTableData>
  >
  _jaapSessionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.jaapSessionsTable,
        aliasName: $_aliasNameGenerator(
          db.jaapProfilesTable.id,
          db.jaapSessionsTable.jaapProfileId,
        ),
      );

  $$JaapSessionsTableTableProcessedTableManager get jaapSessionsTableRefs {
    final manager = $$JaapSessionsTableTableTableManager(
      $_db,
      $_db.jaapSessionsTable,
    ).filter((f) => f.jaapProfileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _jaapSessionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $SankalpGoalsTableTable,
    List<SankalpGoalsTableData>
  >
  _sankalpGoalsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sankalpGoalsTable,
        aliasName: $_aliasNameGenerator(
          db.jaapProfilesTable.id,
          db.sankalpGoalsTable.jaapProfileId,
        ),
      );

  $$SankalpGoalsTableTableProcessedTableManager get sankalpGoalsTableRefs {
    final manager = $$SankalpGoalsTableTableTableManager(
      $_db,
      $_db.sankalpGoalsTable,
    ).filter((f) => f.jaapProfileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sankalpGoalsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JaapProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $JaapProfilesTableTable> {
  $$JaapProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get malaSize => $composableBuilder(
    column: $table.malaSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentColorHex => $composableBuilder(
    column: $table.accentColorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMalasCompleted => $composableBuilder(
    column: $table.totalMalasCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalLifetimeCount => $composableBuilder(
    column: $table.totalLifetimeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> jaapSessionsTableRefs(
    Expression<bool> Function($$JaapSessionsTableTableFilterComposer f) f,
  ) {
    final $$JaapSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jaapSessionsTable,
      getReferencedColumn: (t) => t.jaapProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JaapSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.jaapSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sankalpGoalsTableRefs(
    Expression<bool> Function($$SankalpGoalsTableTableFilterComposer f) f,
  ) {
    final $$SankalpGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sankalpGoalsTable,
      getReferencedColumn: (t) => t.jaapProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SankalpGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.sankalpGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JaapProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JaapProfilesTableTable> {
  $$JaapProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get malaSize => $composableBuilder(
    column: $table.malaSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentColorHex => $composableBuilder(
    column: $table.accentColorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMalasCompleted => $composableBuilder(
    column: $table.totalMalasCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLifetimeCount => $composableBuilder(
    column: $table.totalLifetimeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JaapProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JaapProfilesTableTable> {
  $$JaapProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get malaSize =>
      $composableBuilder(column: $table.malaSize, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<String> get accentColorHex => $composableBuilder(
    column: $table.accentColorHex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMalasCompleted => $composableBuilder(
    column: $table.totalMalasCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalLifetimeCount => $composableBuilder(
    column: $table.totalLifetimeCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> jaapSessionsTableRefs<T extends Object>(
    Expression<T> Function($$JaapSessionsTableTableAnnotationComposer a) f,
  ) {
    final $$JaapSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.jaapSessionsTable,
          getReferencedColumn: (t) => t.jaapProfileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JaapSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.jaapSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sankalpGoalsTableRefs<T extends Object>(
    Expression<T> Function($$SankalpGoalsTableTableAnnotationComposer a) f,
  ) {
    final $$SankalpGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.sankalpGoalsTable,
          getReferencedColumn: (t) => t.jaapProfileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SankalpGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.sankalpGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$JaapProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JaapProfilesTableTable,
          JaapProfilesTableData,
          $$JaapProfilesTableTableFilterComposer,
          $$JaapProfilesTableTableOrderingComposer,
          $$JaapProfilesTableTableAnnotationComposer,
          $$JaapProfilesTableTableCreateCompanionBuilder,
          $$JaapProfilesTableTableUpdateCompanionBuilder,
          (JaapProfilesTableData, $$JaapProfilesTableTableReferences),
          JaapProfilesTableData,
          PrefetchHooks Function({
            bool jaapSessionsTableRefs,
            bool sankalpGoalsTableRefs,
          })
        > {
  $$JaapProfilesTableTableTableManager(
    _$AppDatabase db,
    $JaapProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JaapProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JaapProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JaapProfilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> originalText = const Value.absent(),
                Value<String> transliteration = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> malaSize = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<String> accentColorHex = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> totalMalasCompleted = const Value.absent(),
                Value<int> totalLifetimeCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JaapProfilesTableCompanion(
                id: id,
                name: name,
                originalText: originalText,
                transliteration: transliteration,
                category: category,
                malaSize: malaSize,
                dailyGoal: dailyGoal,
                accentColorHex: accentColorHex,
                currentCount: currentCount,
                totalMalasCompleted: totalMalasCompleted,
                totalLifetimeCount: totalLifetimeCount,
                createdAt: createdAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> originalText = const Value.absent(),
                Value<String> transliteration = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> malaSize = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<String> accentColorHex = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> totalMalasCompleted = const Value.absent(),
                Value<int> totalLifetimeCount = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JaapProfilesTableCompanion.insert(
                id: id,
                name: name,
                originalText: originalText,
                transliteration: transliteration,
                category: category,
                malaSize: malaSize,
                dailyGoal: dailyGoal,
                accentColorHex: accentColorHex,
                currentCount: currentCount,
                totalMalasCompleted: totalMalasCompleted,
                totalLifetimeCount: totalLifetimeCount,
                createdAt: createdAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JaapProfilesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({jaapSessionsTableRefs = false, sankalpGoalsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (jaapSessionsTableRefs) db.jaapSessionsTable,
                    if (sankalpGoalsTableRefs) db.sankalpGoalsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (jaapSessionsTableRefs)
                        await $_getPrefetchedData<
                          JaapProfilesTableData,
                          $JaapProfilesTableTable,
                          JaapSessionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JaapProfilesTableTableReferences
                              ._jaapSessionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JaapProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).jaapSessionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jaapProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sankalpGoalsTableRefs)
                        await $_getPrefetchedData<
                          JaapProfilesTableData,
                          $JaapProfilesTableTable,
                          SankalpGoalsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$JaapProfilesTableTableReferences
                              ._sankalpGoalsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JaapProfilesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).sankalpGoalsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.jaapProfileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$JaapProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JaapProfilesTableTable,
      JaapProfilesTableData,
      $$JaapProfilesTableTableFilterComposer,
      $$JaapProfilesTableTableOrderingComposer,
      $$JaapProfilesTableTableAnnotationComposer,
      $$JaapProfilesTableTableCreateCompanionBuilder,
      $$JaapProfilesTableTableUpdateCompanionBuilder,
      (JaapProfilesTableData, $$JaapProfilesTableTableReferences),
      JaapProfilesTableData,
      PrefetchHooks Function({
        bool jaapSessionsTableRefs,
        bool sankalpGoalsTableRefs,
      })
    >;
typedef $$JaapSessionsTableTableCreateCompanionBuilder =
    JaapSessionsTableCompanion Function({
      required String id,
      required String jaapProfileId,
      Value<String> jaapProfileName,
      required DateTime date,
      Value<int> count,
      Value<int> malaCompleted,
      Value<int> durationSeconds,
      Value<bool> isManualEntry,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$JaapSessionsTableTableUpdateCompanionBuilder =
    JaapSessionsTableCompanion Function({
      Value<String> id,
      Value<String> jaapProfileId,
      Value<String> jaapProfileName,
      Value<DateTime> date,
      Value<int> count,
      Value<int> malaCompleted,
      Value<int> durationSeconds,
      Value<bool> isManualEntry,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$JaapSessionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $JaapSessionsTableTable,
          JaapSessionsTableData
        > {
  $$JaapSessionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JaapProfilesTableTable _jaapProfileIdTable(_$AppDatabase db) =>
      db.jaapProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.jaapSessionsTable.jaapProfileId,
          db.jaapProfilesTable.id,
        ),
      );

  $$JaapProfilesTableTableProcessedTableManager get jaapProfileId {
    final $_column = $_itemColumn<String>('jaap_profile_id')!;

    final manager = $$JaapProfilesTableTableTableManager(
      $_db,
      $_db.jaapProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jaapProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JaapSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $JaapSessionsTableTable> {
  $$JaapSessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jaapProfileName => $composableBuilder(
    column: $table.jaapProfileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get malaCompleted => $composableBuilder(
    column: $table.malaCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JaapProfilesTableTableFilterComposer get jaapProfileId {
    final $$JaapProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jaapProfileId,
      referencedTable: $db.jaapProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JaapProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.jaapProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JaapSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JaapSessionsTableTable> {
  $$JaapSessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jaapProfileName => $composableBuilder(
    column: $table.jaapProfileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get malaCompleted => $composableBuilder(
    column: $table.malaCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JaapProfilesTableTableOrderingComposer get jaapProfileId {
    final $$JaapProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jaapProfileId,
      referencedTable: $db.jaapProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JaapProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.jaapProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JaapSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JaapSessionsTableTable> {
  $$JaapSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jaapProfileName => $composableBuilder(
    column: $table.jaapProfileName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get malaCompleted => $composableBuilder(
    column: $table.malaCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$JaapProfilesTableTableAnnotationComposer get jaapProfileId {
    final $$JaapProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.jaapProfileId,
          referencedTable: $db.jaapProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JaapProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.jaapProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$JaapSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JaapSessionsTableTable,
          JaapSessionsTableData,
          $$JaapSessionsTableTableFilterComposer,
          $$JaapSessionsTableTableOrderingComposer,
          $$JaapSessionsTableTableAnnotationComposer,
          $$JaapSessionsTableTableCreateCompanionBuilder,
          $$JaapSessionsTableTableUpdateCompanionBuilder,
          (JaapSessionsTableData, $$JaapSessionsTableTableReferences),
          JaapSessionsTableData,
          PrefetchHooks Function({bool jaapProfileId})
        > {
  $$JaapSessionsTableTableTableManager(
    _$AppDatabase db,
    $JaapSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JaapSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JaapSessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JaapSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jaapProfileId = const Value.absent(),
                Value<String> jaapProfileName = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> malaCompleted = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<bool> isManualEntry = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JaapSessionsTableCompanion(
                id: id,
                jaapProfileId: jaapProfileId,
                jaapProfileName: jaapProfileName,
                date: date,
                count: count,
                malaCompleted: malaCompleted,
                durationSeconds: durationSeconds,
                isManualEntry: isManualEntry,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jaapProfileId,
                Value<String> jaapProfileName = const Value.absent(),
                required DateTime date,
                Value<int> count = const Value.absent(),
                Value<int> malaCompleted = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<bool> isManualEntry = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => JaapSessionsTableCompanion.insert(
                id: id,
                jaapProfileId: jaapProfileId,
                jaapProfileName: jaapProfileName,
                date: date,
                count: count,
                malaCompleted: malaCompleted,
                durationSeconds: durationSeconds,
                isManualEntry: isManualEntry,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JaapSessionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jaapProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jaapProfileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jaapProfileId,
                                referencedTable:
                                    $$JaapSessionsTableTableReferences
                                        ._jaapProfileIdTable(db),
                                referencedColumn:
                                    $$JaapSessionsTableTableReferences
                                        ._jaapProfileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JaapSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JaapSessionsTableTable,
      JaapSessionsTableData,
      $$JaapSessionsTableTableFilterComposer,
      $$JaapSessionsTableTableOrderingComposer,
      $$JaapSessionsTableTableAnnotationComposer,
      $$JaapSessionsTableTableCreateCompanionBuilder,
      $$JaapSessionsTableTableUpdateCompanionBuilder,
      (JaapSessionsTableData, $$JaapSessionsTableTableReferences),
      JaapSessionsTableData,
      PrefetchHooks Function({bool jaapProfileId})
    >;
typedef $$SankalpGoalsTableTableCreateCompanionBuilder =
    SankalpGoalsTableCompanion Function({
      required String id,
      required String jaapProfileId,
      Value<String> title,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<int> totalDays,
      required DateTime startDate,
      required DateTime endDate,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$SankalpGoalsTableTableUpdateCompanionBuilder =
    SankalpGoalsTableCompanion Function({
      Value<String> id,
      Value<String> jaapProfileId,
      Value<String> title,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<int> totalDays,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

final class $$SankalpGoalsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SankalpGoalsTableTable,
          SankalpGoalsTableData
        > {
  $$SankalpGoalsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JaapProfilesTableTable _jaapProfileIdTable(_$AppDatabase db) =>
      db.jaapProfilesTable.createAlias(
        $_aliasNameGenerator(
          db.sankalpGoalsTable.jaapProfileId,
          db.jaapProfilesTable.id,
        ),
      );

  $$JaapProfilesTableTableProcessedTableManager get jaapProfileId {
    final $_column = $_itemColumn<String>('jaap_profile_id')!;

    final manager = $$JaapProfilesTableTableTableManager(
      $_db,
      $_db.jaapProfilesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jaapProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SankalpGoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SankalpGoalsTableTable> {
  $$SankalpGoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  $$JaapProfilesTableTableFilterComposer get jaapProfileId {
    final $$JaapProfilesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jaapProfileId,
      referencedTable: $db.jaapProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JaapProfilesTableTableFilterComposer(
            $db: $db,
            $table: $db.jaapProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SankalpGoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SankalpGoalsTableTable> {
  $$SankalpGoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$JaapProfilesTableTableOrderingComposer get jaapProfileId {
    final $$JaapProfilesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.jaapProfileId,
      referencedTable: $db.jaapProfilesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JaapProfilesTableTableOrderingComposer(
            $db: $db,
            $table: $db.jaapProfilesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SankalpGoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SankalpGoalsTableTable> {
  $$SankalpGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDays =>
      $composableBuilder(column: $table.totalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  $$JaapProfilesTableTableAnnotationComposer get jaapProfileId {
    final $$JaapProfilesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.jaapProfileId,
          referencedTable: $db.jaapProfilesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JaapProfilesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.jaapProfilesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SankalpGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SankalpGoalsTableTable,
          SankalpGoalsTableData,
          $$SankalpGoalsTableTableFilterComposer,
          $$SankalpGoalsTableTableOrderingComposer,
          $$SankalpGoalsTableTableAnnotationComposer,
          $$SankalpGoalsTableTableCreateCompanionBuilder,
          $$SankalpGoalsTableTableUpdateCompanionBuilder,
          (SankalpGoalsTableData, $$SankalpGoalsTableTableReferences),
          SankalpGoalsTableData,
          PrefetchHooks Function({bool jaapProfileId})
        > {
  $$SankalpGoalsTableTableTableManager(
    _$AppDatabase db,
    $SankalpGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SankalpGoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SankalpGoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SankalpGoalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> jaapProfileId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SankalpGoalsTableCompanion(
                id: id,
                jaapProfileId: jaapProfileId,
                title: title,
                targetCount: targetCount,
                currentCount: currentCount,
                totalDays: totalDays,
                startDate: startDate,
                endDate: endDate,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String jaapProfileId,
                Value<String> title = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SankalpGoalsTableCompanion.insert(
                id: id,
                jaapProfileId: jaapProfileId,
                title: title,
                targetCount: targetCount,
                currentCount: currentCount,
                totalDays: totalDays,
                startDate: startDate,
                endDate: endDate,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SankalpGoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({jaapProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (jaapProfileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.jaapProfileId,
                                referencedTable:
                                    $$SankalpGoalsTableTableReferences
                                        ._jaapProfileIdTable(db),
                                referencedColumn:
                                    $$SankalpGoalsTableTableReferences
                                        ._jaapProfileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SankalpGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SankalpGoalsTableTable,
      SankalpGoalsTableData,
      $$SankalpGoalsTableTableFilterComposer,
      $$SankalpGoalsTableTableOrderingComposer,
      $$SankalpGoalsTableTableAnnotationComposer,
      $$SankalpGoalsTableTableCreateCompanionBuilder,
      $$SankalpGoalsTableTableUpdateCompanionBuilder,
      (SankalpGoalsTableData, $$SankalpGoalsTableTableReferences),
      SankalpGoalsTableData,
      PrefetchHooks Function({bool jaapProfileId})
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<String> localeCode,
      Value<int> themeMode,
      Value<int> accentIndex,
      Value<int> hapticLevel,
      Value<int> tapSound,
      Value<int> completionSound,
      Value<int> counterStyle,
      Value<bool> keepScreenAwake,
      Value<bool> streakTracking,
      Value<bool> autoStartNextMala,
      Value<bool> isOnboardingCompleted,
      Value<String?> activeProfileId,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<String> localeCode,
      Value<int> themeMode,
      Value<int> accentIndex,
      Value<int> hapticLevel,
      Value<int> tapSound,
      Value<int> completionSound,
      Value<int> counterStyle,
      Value<bool> keepScreenAwake,
      Value<bool> streakTracking,
      Value<bool> autoStartNextMala,
      Value<bool> isOnboardingCompleted,
      Value<String?> activeProfileId,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accentIndex => $composableBuilder(
    column: $table.accentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hapticLevel => $composableBuilder(
    column: $table.hapticLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tapSound => $composableBuilder(
    column: $table.tapSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completionSound => $composableBuilder(
    column: $table.completionSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get counterStyle => $composableBuilder(
    column: $table.counterStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get keepScreenAwake => $composableBuilder(
    column: $table.keepScreenAwake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get streakTracking => $composableBuilder(
    column: $table.streakTracking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartNextMala => $composableBuilder(
    column: $table.autoStartNextMala,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnboardingCompleted => $composableBuilder(
    column: $table.isOnboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeProfileId => $composableBuilder(
    column: $table.activeProfileId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accentIndex => $composableBuilder(
    column: $table.accentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hapticLevel => $composableBuilder(
    column: $table.hapticLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tapSound => $composableBuilder(
    column: $table.tapSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completionSound => $composableBuilder(
    column: $table.completionSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get counterStyle => $composableBuilder(
    column: $table.counterStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get keepScreenAwake => $composableBuilder(
    column: $table.keepScreenAwake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get streakTracking => $composableBuilder(
    column: $table.streakTracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartNextMala => $composableBuilder(
    column: $table.autoStartNextMala,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnboardingCompleted => $composableBuilder(
    column: $table.isOnboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeProfileId => $composableBuilder(
    column: $table.activeProfileId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get accentIndex => $composableBuilder(
    column: $table.accentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hapticLevel => $composableBuilder(
    column: $table.hapticLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tapSound =>
      $composableBuilder(column: $table.tapSound, builder: (column) => column);

  GeneratedColumn<int> get completionSound => $composableBuilder(
    column: $table.completionSound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get counterStyle => $composableBuilder(
    column: $table.counterStyle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get keepScreenAwake => $composableBuilder(
    column: $table.keepScreenAwake,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get streakTracking => $composableBuilder(
    column: $table.streakTracking,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartNextMala => $composableBuilder(
    column: $table.autoStartNextMala,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnboardingCompleted => $composableBuilder(
    column: $table.isOnboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeProfileId => $composableBuilder(
    column: $table.activeProfileId,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsTableData,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsTableData
            >,
          ),
          UserSettingsTableData,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localeCode = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
                Value<int> accentIndex = const Value.absent(),
                Value<int> hapticLevel = const Value.absent(),
                Value<int> tapSound = const Value.absent(),
                Value<int> completionSound = const Value.absent(),
                Value<int> counterStyle = const Value.absent(),
                Value<bool> keepScreenAwake = const Value.absent(),
                Value<bool> streakTracking = const Value.absent(),
                Value<bool> autoStartNextMala = const Value.absent(),
                Value<bool> isOnboardingCompleted = const Value.absent(),
                Value<String?> activeProfileId = const Value.absent(),
              }) => UserSettingsTableCompanion(
                id: id,
                localeCode: localeCode,
                themeMode: themeMode,
                accentIndex: accentIndex,
                hapticLevel: hapticLevel,
                tapSound: tapSound,
                completionSound: completionSound,
                counterStyle: counterStyle,
                keepScreenAwake: keepScreenAwake,
                streakTracking: streakTracking,
                autoStartNextMala: autoStartNextMala,
                isOnboardingCompleted: isOnboardingCompleted,
                activeProfileId: activeProfileId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localeCode = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
                Value<int> accentIndex = const Value.absent(),
                Value<int> hapticLevel = const Value.absent(),
                Value<int> tapSound = const Value.absent(),
                Value<int> completionSound = const Value.absent(),
                Value<int> counterStyle = const Value.absent(),
                Value<bool> keepScreenAwake = const Value.absent(),
                Value<bool> streakTracking = const Value.absent(),
                Value<bool> autoStartNextMala = const Value.absent(),
                Value<bool> isOnboardingCompleted = const Value.absent(),
                Value<String?> activeProfileId = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                id: id,
                localeCode: localeCode,
                themeMode: themeMode,
                accentIndex: accentIndex,
                hapticLevel: hapticLevel,
                tapSound: tapSound,
                completionSound: completionSound,
                counterStyle: counterStyle,
                keepScreenAwake: keepScreenAwake,
                streakTracking: streakTracking,
                autoStartNextMala: autoStartNextMala,
                isOnboardingCompleted: isOnboardingCompleted,
                activeProfileId: activeProfileId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsTableData,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsTableData
        >,
      ),
      UserSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JaapProfilesTableTableTableManager get jaapProfilesTable =>
      $$JaapProfilesTableTableTableManager(_db, _db.jaapProfilesTable);
  $$JaapSessionsTableTableTableManager get jaapSessionsTable =>
      $$JaapSessionsTableTableTableManager(_db, _db.jaapSessionsTable);
  $$SankalpGoalsTableTableTableManager get sankalpGoalsTable =>
      $$SankalpGoalsTableTableTableManager(_db, _db.sankalpGoalsTable);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
}
