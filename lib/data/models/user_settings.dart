import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptic_service.dart';

enum CounterStyle { minimal, mala }

class UserSettings {
  final String localeCode;
  final ThemeMode themeMode;
  final int accentIndex;
  final HapticLevel hapticLevel;
  final TapSoundType tapSound;
  final CompletionSoundType completionSound;
  final CounterStyle counterStyle;
  final bool keepScreenAwake;
  final bool streakTracking;
  final bool autoStartNextMala;
  final bool isOnboardingCompleted;

  const UserSettings({
    this.localeCode = 'en',
    this.themeMode = ThemeMode.system,
    this.accentIndex = 0,
    this.hapticLevel = HapticLevel.light,
    this.tapSound = TapSoundType.soft,
    this.completionSound = CompletionSoundType.softBell,
    this.counterStyle = CounterStyle.minimal,
    this.keepScreenAwake = false,
    this.streakTracking = true,
    this.autoStartNextMala = true,
    this.isOnboardingCompleted = false,
  });

  UserSettings copyWith({
    String? localeCode,
    ThemeMode? themeMode,
    int? accentIndex,
    HapticLevel? hapticLevel,
    TapSoundType? tapSound,
    CompletionSoundType? completionSound,
    CounterStyle? counterStyle,
    bool? keepScreenAwake,
    bool? streakTracking,
    bool? autoStartNextMala,
    bool? isOnboardingCompleted,
  }) {
    return UserSettings(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localeCode': localeCode,
      'themeMode': themeMode.index,
      'accentIndex': accentIndex,
      'hapticLevel': hapticLevel.index,
      'tapSound': tapSound.index,
      'completionSound': completionSound.index,
      'counterStyle': counterStyle.index,
      'keepScreenAwake': keepScreenAwake,
      'streakTracking': streakTracking,
      'autoStartNextMala': autoStartNextMala,
      'isOnboardingCompleted': isOnboardingCompleted,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      localeCode: json['localeCode'] as String? ?? 'en',
      themeMode: ThemeMode.values[(json['themeMode'] as int? ?? 0).clamp(0, ThemeMode.values.length - 1)],
      accentIndex: json['accentIndex'] as int? ?? 0,
      hapticLevel: HapticLevel.values[(json['hapticLevel'] as int? ?? 1).clamp(0, HapticLevel.values.length - 1)],
      tapSound: TapSoundType.values[(json['tapSound'] as int? ?? 1).clamp(0, TapSoundType.values.length - 1)],
      completionSound: CompletionSoundType.values[(json['completionSound'] as int? ?? 2).clamp(0, CompletionSoundType.values.length - 1)],
      counterStyle: CounterStyle.values[(json['counterStyle'] as int? ?? 0).clamp(0, CounterStyle.values.length - 1)],
      keepScreenAwake: json['keepScreenAwake'] as bool? ?? false,
      streakTracking: json['streakTracking'] as bool? ?? true,
      autoStartNextMala: json['autoStartNextMala'] as bool? ?? true,
      isOnboardingCompleted: json['isOnboardingCompleted'] as bool? ?? false,
    );
  }
}
