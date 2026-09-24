import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/audio_service.dart';
import '../core/services/haptic_service.dart';
import '../data/models/jaap_profile.dart';
import '../data/models/jaap_session.dart';
import '../data/models/sankalp_goal.dart';
import '../data/repositories/jaap_repository.dart';
import 'settings_controller.dart';

enum CounterOperationType { increment, directAdd, reset }

class CounterOperation {
  final String operationId;
  final String profileId;
  final DateTime timestamp;
  final CounterOperationType type;
  final int deltaCount;
  final int deltaMalas;

  final JaapProfile previousProfile;
  final JaapSession? previousTodaySession;
  final SankalpGoal? previousActiveSankalp;
  final int elapsedSecondsAdded;

  const CounterOperation({
    required this.operationId,
    required this.profileId,
    required this.timestamp,
    required this.type,
    required this.deltaCount,
    required this.deltaMalas,
    required this.previousProfile,
    this.previousTodaySession,
    this.previousActiveSankalp,
    this.elapsedSecondsAdded = 0,
  });
}

class JaapController extends ChangeNotifier {
  final JaapRepository _repository;
  final SettingsController _settingsController;
  final AudioService _audioService = AudioService();

  List<JaapProfile> _profiles = [];
  JaapProfile? _activeProfile;
  final List<CounterOperation> _undoStack = [];

  bool _isMalaCompletedPulse = false;
  bool _isStreakIncreased = false;
  Timer? _completionPulseTimer;

  DateTime? _lastTapTime;
  static const int _inactivityThresholdSeconds = 180;

  JaapController(this._repository, this._settingsController) {
    _loadInitialData();
  }

  JaapRepository get repository => _repository;
  List<JaapProfile> get profiles => _profiles;
  JaapProfile? get activeProfile => _activeProfile;
  bool get isMalaCompletedPulse => _isMalaCompletedPulse;
  bool get isStreakIncreased => _isStreakIncreased;
  bool get canUndo =>
      _undoStack.isNotEmpty && _undoStack.last.profileId == _activeProfile?.id;

  SankalpGoal? get activeSankalp =>
      _activeProfile != null ? _repository.getActiveSankalpForProfile(_activeProfile!.id) : null;

  void _loadInitialData() {
    _profiles = _repository.getProfiles();
    final activeId = _repository.getActiveProfileId();
    if (_profiles.isNotEmpty) {
      _activeProfile = _profiles.firstWhere(
        (p) => p.id == activeId,
        orElse: () => _profiles.first,
      );
    }
    notifyListeners();
  }

  int _calculateElapsedSeconds() {
    final now = DateTime.now();
    int elapsed = 0;
    if (_lastTapTime != null) {
      final diff = now.difference(_lastTapTime!).inSeconds;
      if (diff > 0 && diff <= _inactivityThresholdSeconds) {
        elapsed = diff;
      } else {
        elapsed = 1;
      }
    } else {
      elapsed = 1;
    }
    _lastTapTime = now;
    return elapsed;
  }

  void increment() {
    if (_activeProfile == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final elapsedSec = _calculateElapsedSeconds();

    final prevProfile = _activeProfile!;
    final prevSessions = _repository.getSessions();
    final todayIndex = prevSessions.indexWhere((s) =>
        s.jaapProfileId == _activeProfile!.id &&
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day &&
        !s.isManualEntry);
    final prevTodaySession = todayIndex >= 0 ? prevSessions[todayIndex] : null;
    final prevActiveSankalp =
        _repository.getActiveSankalpForProfile(_activeProfile!.id);

    _audioService.playTapSound(_settingsController.tapSound);
    HapticService.triggerTap(_settingsController.hapticLevel);

    int newCount = _activeProfile!.currentCount + 1;
    int newMalas = _activeProfile!.totalMalasCompleted;
    int newLifetime = _activeProfile!.totalLifetimeCount + 1;
    bool malaFinished = false;

    if (newCount >= _activeProfile!.malaSize) {
      malaFinished = true;
      newMalas += 1;
      _triggerMalaCompletion();

      if (_settingsController.autoStartNextMala) {
        newCount = 0;
      }
    }

    _activeProfile = _activeProfile!.copyWith(
      currentCount: newCount,
      totalMalasCompleted: newMalas,
      totalLifetimeCount: newLifetime,
    );
    _updateProfileInList(_activeProfile!);

    final updatedSessions = List<JaapSession>.from(prevSessions);
    if (todayIndex >= 0) {
      final existing = updatedSessions[todayIndex];
      updatedSessions[todayIndex] = existing.copyWith(
        count: existing.count + 1,
        malaCompleted: malaFinished ? existing.malaCompleted + 1 : existing.malaCompleted,
        durationSeconds: existing.durationSeconds + elapsedSec,
      );
    } else {
      updatedSessions.insert(
        0,
        JaapSession(
          id: 'session_${now.millisecondsSinceEpoch}',
          jaapProfileId: _activeProfile!.id,
          jaapProfileName: _activeProfile!.name,
          date: today,
          count: 1,
          malaCompleted: malaFinished ? 1 : 0,
          durationSeconds: elapsedSec,
          isManualEntry: false,
          createdAt: now,
        ),
      );
    }

    List<SankalpGoal>? updatedSankalps;
    if (prevActiveSankalp != null) {
      final allSankalps = List<SankalpGoal>.from(_repository.getSankalps());
      final sIdx = allSankalps.indexWhere((s) => s.id == prevActiveSankalp.id);
      if (sIdx >= 0) {
        final newSankalpCount = prevActiveSankalp.currentCount + 1;
        final isDone = newSankalpCount >= prevActiveSankalp.targetCount;
        allSankalps[sIdx] = prevActiveSankalp.copyWith(
          currentCount: newSankalpCount,
          isCompleted: isDone,
        );
        updatedSankalps = allSankalps;
      }
    }

    _pushUndoOperation(
      CounterOperation(
        operationId: 'op_${now.millisecondsSinceEpoch}',
        profileId: _activeProfile!.id,
        timestamp: now,
        type: CounterOperationType.increment,
        deltaCount: 1,
        deltaMalas: malaFinished ? 1 : 0,
        previousProfile: prevProfile,
        previousTodaySession: prevTodaySession,
        previousActiveSankalp: prevActiveSankalp,
        elapsedSecondsAdded: elapsedSec,
      ),
    );

    notifyListeners();

    _repository.saveCounterStateAtomic(
      profiles: _profiles,
      sessions: updatedSessions,
      sankalps: updatedSankalps,
    );
  }

  void undo() {
    if (_activeProfile == null || _undoStack.isEmpty) return;

    final op = _undoStack.removeLast();
    if (op.profileId != _activeProfile!.id) return;

    _audioService.playTapSound(_settingsController.tapSound);
    HapticService.triggerTap(_settingsController.hapticLevel);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _activeProfile = op.previousProfile;
    _updateProfileInList(_activeProfile!);

    final sessions = List<JaapSession>.from(_repository.getSessions());
    final todayIndex = sessions.indexWhere((s) =>
        s.jaapProfileId == _activeProfile!.id &&
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day &&
        !s.isManualEntry);

    if (op.previousTodaySession != null) {
      if (todayIndex >= 0) {
        sessions[todayIndex] = op.previousTodaySession!;
      } else {
        sessions.insert(0, op.previousTodaySession!);
      }
    } else {
      if (todayIndex >= 0) {
        sessions.removeAt(todayIndex);
      }
    }

    List<SankalpGoal>? sankalps;
    if (op.previousActiveSankalp != null) {
      final allSankalps = List<SankalpGoal>.from(_repository.getSankalps());
      final sIdx = allSankalps.indexWhere((s) => s.id == op.previousActiveSankalp!.id);
      if (sIdx >= 0) {
        allSankalps[sIdx] = op.previousActiveSankalp!;
        sankalps = allSankalps;
      }
    }

    notifyListeners();

    _repository.saveCounterStateAtomic(
      profiles: _profiles,
      sessions: sessions,
      sankalps: sankalps,
    );
  }

  void resetCurrentCount() {
    if (_activeProfile == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final prevProfile = _activeProfile!;
    final prevSessions = _repository.getSessions();
    final todayIndex = prevSessions.indexWhere((s) =>
        s.jaapProfileId == _activeProfile!.id &&
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day &&
        !s.isManualEntry);
    final prevTodaySession = todayIndex >= 0 ? prevSessions[todayIndex] : null;
    final prevActiveSankalp =
        _repository.getActiveSankalpForProfile(_activeProfile!.id);

    _activeProfile = _activeProfile!.copyWith(currentCount: 0);
    _updateProfileInList(_activeProfile!);

    _pushUndoOperation(
      CounterOperation(
        operationId: 'reset_${now.millisecondsSinceEpoch}',
        profileId: _activeProfile!.id,
        timestamp: now,
        type: CounterOperationType.reset,
        deltaCount: -prevProfile.currentCount,
        deltaMalas: 0,
        previousProfile: prevProfile,
        previousTodaySession: prevTodaySession,
        previousActiveSankalp: prevActiveSankalp,
        elapsedSecondsAdded: 0,
      ),
    );

    notifyListeners();

    _repository.saveProfiles(_profiles);
  }

  void addCountDirect(int delta) {
    if (_activeProfile == null || delta <= 0) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final prevProfile = _activeProfile!;
    final prevSessions = _repository.getSessions();
    final todayIndex = prevSessions.indexWhere((s) =>
        s.jaapProfileId == _activeProfile!.id &&
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day &&
        !s.isManualEntry);
    final prevTodaySession = todayIndex >= 0 ? prevSessions[todayIndex] : null;
    final prevActiveSankalp =
        _repository.getActiveSankalpForProfile(_activeProfile!.id);

    int newCount = _activeProfile!.currentCount + delta;
    int completedMalasDelta = newCount ~/ _activeProfile!.malaSize;
    int remainingCount = newCount % _activeProfile!.malaSize;

    _activeProfile = _activeProfile!.copyWith(
      currentCount: remainingCount,
      totalMalasCompleted: _activeProfile!.totalMalasCompleted + completedMalasDelta,
      totalLifetimeCount: _activeProfile!.totalLifetimeCount + delta,
    );
    _updateProfileInList(_activeProfile!);

    if (completedMalasDelta > 0) {
      _triggerMalaCompletion();
    }

    final updatedSessions = List<JaapSession>.from(prevSessions);
    if (todayIndex >= 0) {
      final existing = updatedSessions[todayIndex];
      updatedSessions[todayIndex] = existing.copyWith(
        count: existing.count + delta,
        malaCompleted: existing.malaCompleted + completedMalasDelta,
      );
    } else {
      updatedSessions.insert(
        0,
        JaapSession(
          id: 'session_${now.millisecondsSinceEpoch}',
          jaapProfileId: _activeProfile!.id,
          jaapProfileName: _activeProfile!.name,
          date: today,
          count: delta,
          malaCompleted: completedMalasDelta,
          durationSeconds: 0,
          isManualEntry: false,
          createdAt: now,
        ),
      );
    }

    List<SankalpGoal>? updatedSankalps;
    if (prevActiveSankalp != null) {
      final allSankalps = List<SankalpGoal>.from(_repository.getSankalps());
      final sIdx = allSankalps.indexWhere((s) => s.id == prevActiveSankalp.id);
      if (sIdx >= 0) {
        final newSankalpCount = prevActiveSankalp.currentCount + delta;
        final isDone = newSankalpCount >= prevActiveSankalp.targetCount;
        allSankalps[sIdx] = prevActiveSankalp.copyWith(
          currentCount: newSankalpCount,
          isCompleted: isDone,
        );
        updatedSankalps = allSankalps;
      }
    }

    _pushUndoOperation(
      CounterOperation(
        operationId: 'direct_${now.millisecondsSinceEpoch}',
        profileId: _activeProfile!.id,
        timestamp: now,
        type: CounterOperationType.directAdd,
        deltaCount: delta,
        deltaMalas: completedMalasDelta,
        previousProfile: prevProfile,
        previousTodaySession: prevTodaySession,
        previousActiveSankalp: prevActiveSankalp,
        elapsedSecondsAdded: 0,
      ),
    );

    notifyListeners();

    _repository.saveCounterStateAtomic(
      profiles: _profiles,
      sessions: updatedSessions,
      sankalps: updatedSankalps,
    );
  }

  Future<void> startNewSankalp({
    required int totalDays,
    required int targetCount,
  }) async {
    if (_activeProfile == null) return;
    final now = DateTime.now();
    final newSankalp = SankalpGoal(
      id: 'sankalp_${now.millisecondsSinceEpoch}',
      jaapProfileId: _activeProfile!.id,
      title: '$totalDays-Day Sankalp (${_activeProfile!.name})',
      targetCount: targetCount,
      currentCount: 0,
      totalDays: totalDays,
      startDate: now,
      endDate: now.add(Duration(days: totalDays)),
      isCompleted: false,
    );

    final allSankalps = List<SankalpGoal>.from(_repository.getSankalps());
    for (int i = 0; i < allSankalps.length; i++) {
      if (allSankalps[i].jaapProfileId == _activeProfile!.id && !allSankalps[i].isCompleted) {
        allSankalps[i] = allSankalps[i].copyWith(isCompleted: true);
      }
    }
    allSankalps.insert(0, newSankalp);
    await _repository.saveSankalps(allSankalps);
    notifyListeners();
  }

  void _pushUndoOperation(CounterOperation op) {
    _undoStack.add(op);
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
  }

  void _triggerMalaCompletion() {
    _isMalaCompletedPulse = true;
    _audioService.playCompletionSound(_settingsController.completionSound);
    HapticService.triggerCompletion(_settingsController.hapticLevel);

    final now = DateTime.now();
    final hadMalaToday = _repository.getSessions().any((s) =>
        s.malaCompleted > 0 &&
        s.date.year == now.year &&
        s.date.month == now.month &&
        s.date.day == now.day);

    _isStreakIncreased = !hadMalaToday;

    _completionPulseTimer?.cancel();
    _completionPulseTimer = Timer(const Duration(milliseconds: 1400), () {
      _isMalaCompletedPulse = false;
      _isStreakIncreased = false;
      notifyListeners();
    });
  }

  void setActiveProfile(String profileId) {
    final found = _profiles.firstWhere((p) => p.id == profileId, orElse: () => _profiles.first);
    _activeProfile = found;
    _undoStack.clear();
    _lastTapTime = null;
    _repository.saveActiveProfileId(profileId);
    notifyListeners();
  }

  Future<void> addProfile(JaapProfile profile) async {
    _profiles.add(profile);
    _activeProfile = profile;
    _undoStack.clear();
    _lastTapTime = null;
    notifyListeners();
    await _repository.saveProfiles(_profiles);
    await _repository.saveActiveProfileId(profile.id);
  }

  Future<void> updateProfile(JaapProfile profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _profiles[index] = profile;
      if (_activeProfile?.id == profile.id) {
        _activeProfile = profile;
      }
      notifyListeners();
      await _repository.saveProfiles(_profiles);
    }
  }

  Future<void> deleteProfile(String profileId) async {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.id == profileId);
    if (_activeProfile?.id == profileId) {
      _activeProfile = _profiles.first;
      _undoStack.clear();
      _lastTapTime = null;
      await _repository.saveActiveProfileId(_activeProfile!.id);
    }
    notifyListeners();
    await _repository.saveProfiles(_profiles);
  }

  void _updateProfileInList(JaapProfile profile) {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _profiles[index] = profile;
    }
  }

  int getTodayCountForActiveProfile() {
    if (_activeProfile == null) return 0;
    final now = DateTime.now();
    final sessions = _repository.getSessions();
    return sessions
        .where((s) =>
            s.jaapProfileId == _activeProfile!.id &&
            s.date.year == now.year &&
            s.date.month == now.month &&
            s.date.day == now.day)
        .fold(0, (sum, s) => sum + s.count);
  }

  @override
  void dispose() {
    _completionPulseTimer?.cancel();
    super.dispose();
  }
}
