import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/services/audio_service.dart';
import '../core/services/haptic_service.dart';
import '../core/services/storage_service.dart';
import '../data/models/user_settings.dart';

class SettingsController extends ChangeNotifier {
  final StorageService _storage;
  late UserSettings _settings;

  SettingsController(this._storage) {
    _settings = _storage.loadSettings();
  }

  UserSettings get settings => _settings;
  Locale get currentLocale => Locale(_settings.localeCode);
  ThemeMode get themeMode => _settings.themeMode;
  MutedAccent get currentAccent => AppColors.getAccent(_settings.accentIndex);
  CounterStyle get counterStyle => _settings.counterStyle;
  HapticLevel get hapticLevel => _settings.hapticLevel;
  TapSoundType get tapSound => _settings.tapSound;
  CompletionSoundType get completionSound => _settings.completionSound;
  bool get keepScreenAwake => _settings.keepScreenAwake;
  bool get streakTracking => _settings.streakTracking;
  bool get autoStartNextMala => _settings.autoStartNextMala;
  bool get isOnboardingCompleted => _settings.isOnboardingCompleted;

  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> setLocale(String code) async {
    await updateSettings(_settings.copyWith(localeCode: code));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await updateSettings(_settings.copyWith(themeMode: mode));
  }

  Future<void> setAccentIndex(int index) async {
    await updateSettings(_settings.copyWith(accentIndex: index));
  }

  Future<void> setCounterStyle(CounterStyle style) async {
    await updateSettings(_settings.copyWith(counterStyle: style));
  }

  Future<void> setHapticLevel(HapticLevel level) async {
    await updateSettings(_settings.copyWith(hapticLevel: level));
  }

  Future<void> setTapSound(TapSoundType sound) async {
    await updateSettings(_settings.copyWith(tapSound: sound));
  }

  Future<void> setCompletionSound(CompletionSoundType sound) async {
    await updateSettings(_settings.copyWith(completionSound: sound));
  }

  Future<void> setKeepScreenAwake(bool value) async {
    await updateSettings(_settings.copyWith(keepScreenAwake: value));
  }

  Future<void> setStreakTracking(bool value) async {
    await updateSettings(_settings.copyWith(streakTracking: value));
  }

  Future<void> setAutoStartNextMala(bool value) async {
    await updateSettings(_settings.copyWith(autoStartNextMala: value));
  }

  Future<void> completeOnboarding() async {
    await updateSettings(_settings.copyWith(isOnboardingCompleted: true));
  }
}
