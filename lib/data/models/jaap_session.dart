class JaapSession {
  final String id;
  final String jaapProfileId;
  final String jaapProfileName;
  final DateTime date;
  final int count;
  final int malaCompleted;
  final int durationSeconds;
  final bool isManualEntry;
  final DateTime createdAt;

  const JaapSession({
    required this.id,
    required this.jaapProfileId,
    required this.jaapProfileName,
    required this.date,
    required this.count,
    required this.malaCompleted,
    this.durationSeconds = 0,
    this.isManualEntry = false,
    required this.createdAt,
  });

  JaapSession copyWith({
    String? id,
    String? jaapProfileId,
    String? jaapProfileName,
    DateTime? date,
    int? count,
    int? malaCompleted,
    int? durationSeconds,
    bool? isManualEntry,
    DateTime? createdAt,
  }) {
    return JaapSession(
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
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jaapProfileId': jaapProfileId,
      'jaapProfileName': jaapProfileName,
      'date': date.toIso8601String(),
      'count': count,
      'malaCompleted': malaCompleted,
      'durationSeconds': durationSeconds,
      'isManualEntry': isManualEntry,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JaapSession.fromJson(Map<String, dynamic> json) {
    return JaapSession(
      id: json['id'] as String,
      jaapProfileId: json['jaapProfileId'] as String,
      jaapProfileName: json['jaapProfileName'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      count: json['count'] as int? ?? 0,
      malaCompleted: json['malaCompleted'] as int? ?? 0,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      isManualEntry: json['isManualEntry'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
