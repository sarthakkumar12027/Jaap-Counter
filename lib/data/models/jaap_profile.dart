class JaapProfile {
  final String id;
  final String name;
  final String originalText;
  final String transliteration;
  final String category;
  final int malaSize; // 27, 54, 108, or custom
  final int dailyGoal; // e.g., 108, 540, 1080 (0 for none)
  final String accentColorHex;
  final int currentCount;
  final int totalMalasCompleted;
  final int totalLifetimeCount;
  final DateTime createdAt;
  final bool isActive;

  const JaapProfile({
    required this.id,
    required this.name,
    this.originalText = '',
    this.transliteration = '',
    this.category = 'Personal',
    this.malaSize = 108,
    this.dailyGoal = 108,
    this.accentColorHex = '0xFF5F7D6B',
    this.currentCount = 0,
    this.totalMalasCompleted = 0,
    this.totalLifetimeCount = 0,
    required this.createdAt,
    this.isActive = true,
  });

  JaapProfile copyWith({
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
  }) {
    return JaapProfile(
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
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originalText': originalText,
      'transliteration': transliteration,
      'category': category,
      'malaSize': malaSize,
      'dailyGoal': dailyGoal,
      'accentColorHex': accentColorHex,
      'currentCount': currentCount,
      'totalMalasCompleted': totalMalasCompleted,
      'totalLifetimeCount': totalLifetimeCount,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory JaapProfile.fromJson(Map<String, dynamic> json) {
    return JaapProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      originalText: json['originalText'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      category: json['category'] as String? ?? 'Personal',
      malaSize: json['malaSize'] as int? ?? 108,
      dailyGoal: json['dailyGoal'] as int? ?? 108,
      accentColorHex: json['accentColorHex'] as String? ?? '0xFF5F7D6B',
      currentCount: json['currentCount'] as int? ?? 0,
      totalMalasCompleted: json['totalMalasCompleted'] as int? ?? 0,
      totalLifetimeCount: json['totalLifetimeCount'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
