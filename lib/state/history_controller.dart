import 'package:flutter/material.dart';
import '../data/models/jaap_session.dart';
import '../data/repositories/jaap_repository.dart';
import 'jaap_controller.dart';

class HistoryController extends ChangeNotifier {
  final JaapRepository _repository;
  final JaapController _jaapController;

  String? _selectedProfileFilter; // null = all

  HistoryController(this._repository, this._jaapController) {
    _jaapController.addListener(_onJaapUpdated);
  }

  void _onJaapUpdated() {
    notifyListeners();
  }

  String? get selectedProfileFilter => _selectedProfileFilter;

  void setProfileFilter(String? profileId) {
    _selectedProfileFilter = profileId;
    notifyListeners();
  }

  List<JaapSession> get filteredSessions {
    final all = _repository.getSessions();
    if (_selectedProfileFilter == null) return all;
    return all.where((s) => s.jaapProfileId == _selectedProfileFilter).toList();
  }

  // --- Aggregated Stats ---

  int get todayTotalJaaps {
    final now = DateTime.now();
    return filteredSessions
        .where((s) =>
            s.date.year == now.year &&
            s.date.month == now.month &&
            s.date.day == now.day)
        .fold(0, (sum, s) => sum + s.count);
  }

  int get todayTotalMalas {
    final now = DateTime.now();
    return filteredSessions
        .where((s) =>
            s.date.year == now.year &&
            s.date.month == now.month &&
            s.date.day == now.day)
        .fold(0, (sum, s) => sum + s.malaCompleted);
  }

  int get weekTotalJaaps {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonday = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return filteredSessions
        .where((s) => s.date.isAfter(startOfMonday.subtract(const Duration(seconds: 1))))
        .fold(0, (sum, s) => sum + s.count);
  }

  int get weekTotalMalas {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonday = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return filteredSessions
        .where((s) => s.date.isAfter(startOfMonday.subtract(const Duration(seconds: 1))))
        .fold(0, (sum, s) => sum + s.malaCompleted);
  }

  int get allTimeTotalJaaps {
    return filteredSessions.fold(0, (sum, s) => sum + s.count);
  }

  int get allTimeTotalMalas {
    return filteredSessions.fold(0, (sum, s) => sum + s.malaCompleted);
  }

  int get practiceDaysThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonday = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    final days = <String>{};
    for (final s in filteredSessions) {
      if (s.date.isAfter(startOfMonday.subtract(const Duration(seconds: 1)))) {
        days.add('${s.date.year}-${s.date.month}-${s.date.day}');
      }
    }
    return days.length;
  }

  // --- Streak Calculation (Mala-based, resets at 12:00 AM Midnight) ---
  int get currentStreakDays {
    final sessions = _repository.getSessions();
    if (sessions.isEmpty) return 0;

    final daysWithMala = <DateTime>{};
    for (final s in sessions) {
      if (s.malaCompleted > 0) {
        daysWithMala.add(DateTime(s.date.year, s.date.month, s.date.day));
      }
    }

    if (daysWithMala.isEmpty) return 0;

    final sortedDays = daysWithMala.toList()..sort((a, b) => b.compareTo(a));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // If no mala completed today or yesterday, streak has reset to 0
    if (!sortedDays.contains(today) && !sortedDays.contains(yesterday)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDay = sortedDays.contains(today) ? today : yesterday;

    while (sortedDays.contains(checkDay)) {
      streak++;
      checkDay = checkDay.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Longest all-time streak in days
  int get bestStreakDays {
    final sessions = _repository.getSessions();
    if (sessions.isEmpty) return 0;

    final daysWithMala = <DateTime>{};
    for (final s in sessions) {
      if (s.malaCompleted > 0) {
        daysWithMala.add(DateTime(s.date.year, s.date.month, s.date.day));
      }
    }

    if (daysWithMala.isEmpty) return 0;

    final sortedDays = daysWithMala.toList()..sort((a, b) => a.compareTo(b));
    int maxStreak = 0;
    int currentRun = 0;
    DateTime? prevDay;

    for (final day in sortedDays) {
      if (prevDay == null) {
        currentRun = 1;
      } else {
        final diff = day.difference(prevDay).inDays;
        if (diff == 1) {
          currentRun++;
        } else if (diff > 1) {
          currentRun = 1;
        }
      }
      if (currentRun > maxStreak) {
        maxStreak = currentRun;
      }
      prevDay = day;
    }

    return maxStreak;
  }

  /// Whether at least 1 mala was completed on today's calendar date
  bool get isTodayMalaCompleted {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _repository.getSessions().any(
      (s) =>
          s.malaCompleted > 0 &&
          s.date.year == today.year &&
          s.date.month == today.month &&
          s.date.day == today.day,
    );
  }

  /// 7-day week streak status (Mon to Sun)
  List<StreakDayStatus> get currentWeekStreakStatus {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: now.weekday - 1));
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final sessions = _repository.getSessions();
    final daysWithMala = <DateTime>{};
    for (final s in sessions) {
      if (s.malaCompleted > 0) {
        daysWithMala.add(DateTime(s.date.year, s.date.month, s.date.day));
      }
    }

    final List<StreakDayStatus> result = [];
    for (int i = 0; i < 7; i++) {
      final dayDate = monday.add(Duration(days: i));
      final isCompleted = daysWithMala.contains(dayDate);
      final isToday = dayDate.isAtSameMomentAs(today);
      final isFuture = dayDate.isAfter(today);

      result.add(StreakDayStatus(
        label: daysOfWeek[i],
        date: dayDate,
        isCompleted: isCompleted,
        isToday: isToday,
        isFuture: isFuture,
      ));
    }
    return result;
  }

  // --- 7-Day Weekly Chart Data ---
  List<DayCount> get weeklyBarData {
    final now = DateTime.now();
    final List<DayCount> result = [];
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final monday = now.subtract(Duration(days: now.weekday - 1));

    for (int i = 0; i < 7; i++) {
      final dayDate = DateTime(monday.year, monday.month, monday.day).add(Duration(days: i));
      final dayCount = filteredSessions
          .where((s) =>
              s.date.year == dayDate.year &&
              s.date.month == dayDate.month &&
              s.date.day == dayDate.day)
          .fold(0, (sum, s) => sum + s.count);

      result.add(DayCount(
        dayLabel: daysOfWeek[i],
        count: dayCount,
        isToday: dayDate.year == now.year && dayDate.month == now.month && dayDate.day == now.day,
      ));
    }

    return result;
  }

  // --- Grouped Logs by Date ---
  Map<DateTime, List<JaapSession>> get groupedSessionsByDate {
    final map = <DateTime, List<JaapSession>>{};
    for (final s in filteredSessions) {
      final dateKey = DateTime(s.date.year, s.date.month, s.date.day);
      map.putIfAbsent(dateKey, () => []).add(s);
    }
    return map;
  }

  // --- Manual Session Addition ---
  Future<void> addManualSession({
    required String profileId,
    required String profileName,
    required int count,
    required int malaSize,
    required DateTime date,
  }) async {
    final malas = count ~/ (malaSize > 0 ? malaSize : 108);
    final sessions = _repository.getSessions();

    final newSession = JaapSession(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      jaapProfileId: profileId,
      jaapProfileName: profileName,
      date: DateTime(date.year, date.month, date.day),
      count: count,
      malaCompleted: malas,
      durationSeconds: 0,
      isManualEntry: true,
      createdAt: DateTime.now(),
    );

    sessions.insert(0, newSession);
    await _repository.saveSessions(sessions);

    // Update active profile lifetime count if same profile
    final profiles = _repository.getProfiles();
    final idx = profiles.indexWhere((p) => p.id == profileId);
    if (idx >= 0) {
      final p = profiles[idx];
      profiles[idx] = p.copyWith(
        totalLifetimeCount: p.totalLifetimeCount + count,
        totalMalasCompleted: p.totalMalasCompleted + malas,
      );
      await _repository.saveProfiles(profiles);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _jaapController.removeListener(_onJaapUpdated);
    super.dispose();
  }
}

class DayCount {
  final String dayLabel;
  final int count;
  final bool isToday;

  const DayCount({
    required this.dayLabel,
    required this.count,
    required this.isToday,
  });
}

class StreakDayStatus {
  final String label;
  final DateTime date;
  final bool isCompleted;
  final bool isToday;
  final bool isFuture;

  const StreakDayStatus({
    required this.label,
    required this.date,
    required this.isCompleted,
    required this.isToday,
    required this.isFuture,
  });
}

