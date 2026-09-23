class SankalpGoal {
  final String id;
  final String jaapProfileId;
  final String title;
  final int targetCount;
  final int currentCount;
  final int totalDays;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;

  const SankalpGoal({
    required this.id,
    required this.jaapProfileId,
    required this.title,
    required this.targetCount,
    this.currentCount = 0,
    this.totalDays = 40,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  int get daysRemaining {
    final diff = endDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  int get currentDay {
    final diff = DateTime.now().difference(startDate).inDays + 1;
    return diff.clamp(1, totalDays);
  }

  double get progressPercentage {
    if (targetCount <= 0) return 0.0;
    return (currentCount / targetCount).clamp(0.0, 1.0);
  }

  SankalpGoal copyWith({
    String? id,
    String? jaapProfileId,
    String? title,
    int? targetCount,
    int? currentCount,
    int? totalDays,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
  }) {
    return SankalpGoal(
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
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jaapProfileId': jaapProfileId,
      'title': title,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'totalDays': totalDays,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory SankalpGoal.fromJson(Map<String, dynamic> json) {
    return SankalpGoal(
      id: json['id'] as String,
      jaapProfileId: json['jaapProfileId'] as String,
      title: json['title'] as String? ?? '40-Day Sankalp',
      targetCount: json['targetCount'] as int? ?? 43200,
      currentCount: json['currentCount'] as int? ?? 0,
      totalDays: json['totalDays'] as int? ?? 40,
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] as String? ?? '') ?? DateTime.now().add(const Duration(days: 40)),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
