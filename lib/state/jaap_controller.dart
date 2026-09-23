import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/audio_service.dart';
import '../core/services/haptic_service.dart';
import '../data/models/jaap_profile.dart';
import '../data/models/jaap_session.dart';
import '../data/repositories/jaap_repository.dart';
import 'settings_controller.dart';

class JaapController extends ChangeNotifier {
  final JaapRepository _repository;
  final SettingsController _settingsController;
  final AudioService _audioService = AudioService();

  List<JaapProfile> _profiles = [];
  JaapProfile? _activeProfile;
  final List<int> _undoStack = []; // stores previous count states for instant undo

  bool _isMalaCompletedPulse = false;
  bool _isStreakIncreased = false;
  Timer? _completionPulseTimer;

  DateTime? _sessionStartTime;


  JaapController(this._repository, this._settingsController) {
    _loadInitialData();
  }

  List<JaapProfile> get profiles => _profiles;
  JaapProfile? get activeProfile => _activeProfile;
  bool get isMalaCompletedPulse => _isMalaCompletedPulse;
  bool get isStreakIncreased => _isStreakIncreased;
  bool get canUndo => _undoStack.isNotEmpty;

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

  // --- Sub-millisecond Counting Engine ---

  void increment() {
    if (_activeProfile == null) return;

    _sessionStartTime ??= DateTime.now();


    // Save previous count for instant undo
    _undoStack.add(_activeProfile!.currentCount);
    if (_undoStack.length > 50) _undoStack.removeAt(0);

    // Audio & Haptic triggers
    _audioService.playTapSound(_settingsController.tapSound);
    HapticService.triggerTap(_settingsController.hapticLevel);

    int newCount = _activeProfile!.currentCount + 1;
    int newMalas = _activeProfile!.totalMalasCompleted;
    int newLifetime = _activeProfile!.totalLifetimeCount + 1;
    bool malaFinished = false;

    if (newCount >= _activeProfile!.malaSize) {
      // Mala completed!
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
    notifyListeners();

    // Persist and record session
    _recordSessionTap(malaFinished: malaFinished);
  }

  void undo() {
    if (_activeProfile == null || _undoStack.isEmpty) return;

    final prevCount = _undoStack.removeLast();
    _audioService.playTapSound(_settingsController.tapSound);
    HapticService.triggerTap(_settingsController.hapticLevel);

    int newLifetime = _activeProfile!.totalLifetimeCount > 0
        ? _activeProfile!.totalLifetimeCount - 1
        : 0;

    _activeProfile = _activeProfile!.copyWith(
      currentCount: prevCount,
      totalLifetimeCount: newLifetime,
    );

    _updateProfileInList(_activeProfile!);
    notifyListeners();
    _saveProfilesToDisk();
  }

  void resetCurrentCount() {
    if (_activeProfile == null) return;
    _undoStack.clear();
    _activeProfile = _activeProfile!.copyWith(currentCount: 0);
    _updateProfileInList(_activeProfile!);
    notifyListeners();
    _saveProfilesToDisk();
  }

  void addCountDirect(int delta) {
    if (_activeProfile == null || delta <= 0) return;

    _undoStack.add(_activeProfile!.currentCount);
    int newCount = _activeProfile!.currentCount + delta;
    int completedMalasDelta = newCount ~/ _activeProfile!.malaSize;
    int remainingCount = newCount % _activeProfile!.malaSize;

    _activeProfile = _activeProfile!.copyWith(
      currentCount: remainingCount,
      totalMalasCompleted: _activeProfile!.totalMalasCompleted + completedMalasDelta,
      totalLifetimeCount: _activeProfile!.totalLifetimeCount + delta,
    );

    _updateProfileInList(_activeProfile!);
    notifyListeners();

    _recordManualDelta(delta, completedMalasDelta);
  }

  void _triggerMalaCompletion() {
    _isMalaCompletedPulse = true;
    _audioService.playCompletionSound(_settingsController.completionSound);
    HapticService.triggerCompletion(_settingsController.hapticLevel);

    // Check if user had already completed a mala today before this one
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

  void _recordSessionTap({required bool malaFinished}) {
    _saveProfilesToDisk();

    // Grouping session logs by today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sessions = _repository.getSessions();
    final todayIndex = sessions.indexWhere((s) =>
        s.jaapProfileId == _activeProfile!.id &&
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day &&
        !s.isManualEntry);

    if (todayIndex >= 0) {
      final existing = sessions[todayIndex];
      sessions[todayIndex] = existing.copyWith(
        count: existing.count + 1,
        malaCompleted: malaFinished ? existing.malaCompleted + 1 : existing.malaCompleted,
        durationSeconds: existing.durationSeconds + 1,
      );
    } else {
      sessions.insert(
        0,
        JaapSession(
          id: 'session_${DateTime.now().millisecondsSinceEpoch}',
          jaapProfileId: _activeProfile!.id,
          jaapProfileName: _activeProfile!.name,
          date: today,
          count: 1,
          malaCompleted: malaFinished ? 1 : 0,
          durationSeconds: 1,
          isManualEntry: false,
          createdAt: DateTime.now(),
        ),
      );
    }

    _repository.saveSessions(sessions);
  }

  void _recordManualDelta(int deltaCount, int deltaMalas) {
    _saveProfilesToDisk();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sessions = _repository.getSessions();
    sessions.insert(
      0,
      JaapSession(
        id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
        jaapProfileId: _activeProfile!.id,
        jaapProfileName: _activeProfile!.name,
        date: today,
        count: deltaCount,
        malaCompleted: deltaMalas,
        durationSeconds: 0,
        isManualEntry: true,
        createdAt: DateTime.now(),
      ),
    );

    _repository.saveSessions(sessions);
  }

  // --- Profile Management ---

  void setActiveProfile(String profileId) {
    final found = _profiles.firstWhere((p) => p.id == profileId, orElse: () => _profiles.first);
    _activeProfile = found;
    _undoStack.clear();
    _repository.saveActiveProfileId(profileId);
    notifyListeners();
  }

  Future<void> addProfile(JaapProfile profile) async {
    _profiles.add(profile);
    _activeProfile = profile;
    _undoStack.clear();
    notifyListeners();
    await _saveProfilesToDisk();
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
      await _saveProfilesToDisk();
    }
  }

  Future<void> deleteProfile(String profileId) async {
    if (_profiles.length <= 1) return; // Keep at least one profile
    _profiles.removeWhere((p) => p.id == profileId);
    if (_activeProfile?.id == profileId) {
      _activeProfile = _profiles.first;
      _undoStack.clear();
      await _repository.saveActiveProfileId(_activeProfile!.id);
    }
    notifyListeners();
    await _saveProfilesToDisk();
  }

  void _updateProfileInList(JaapProfile profile) {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _profiles[index] = profile;
    }
  }

  Future<void> _saveProfilesToDisk() async {
    await _repository.saveProfiles(_profiles);
  }

  // --- Daily Goal Analytics for Active Profile ---
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
