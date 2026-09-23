import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/audio_service.dart';

class MeditationController extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  int _selectedMinutes = 10;
  int _secondsRemaining = 600;
  bool _isRunning = false;
  bool _isMuted = false;
  Timer? _timer;

  int get selectedMinutes => _selectedMinutes;
  int get secondsRemaining => _secondsRemaining;
  bool get isRunning => _isRunning;
  bool get isMuted => _isMuted;

  double get progressPercentage {
    final total = _selectedMinutes * 60;
    if (total <= 0) return 0.0;
    return (1.0 - (_secondsRemaining / total)).clamp(0.0, 1.0);
  }

  String get formattedTimeRemaining {
    final mins = _secondsRemaining ~/ 60;
    final secs = _secondsRemaining % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void setDuration(int minutes) {
    if (_isRunning || minutes <= 0) return;
    _selectedMinutes = minutes;
    _secondsRemaining = minutes * 60;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _audioService.setMeditationMuted(_isMuted);
    notifyListeners();
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    _audioService.setMeditationMuted(_isMuted);
    notifyListeners();
  }

  void startMeditation() {
    if (_isRunning) return;
    _isRunning = true;
    _audioService.startMeditationSound(isMuted: _isMuted);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        stopMeditation(isCompleted: true);
      }
    });
    notifyListeners();
  }

  void stopMeditation({bool isCompleted = false}) {
    _timer?.cancel();
    _audioService.stopMeditationSound();
    _isRunning = false;
    _secondsRemaining = _selectedMinutes * 60;
    if (isCompleted && !_isMuted) {
      _audioService.playMeditationBell();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.stopMeditationSound();
    super.dispose();
  }
}
