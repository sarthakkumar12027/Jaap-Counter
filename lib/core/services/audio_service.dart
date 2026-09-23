import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../constants/sound_assets.dart';

enum TapSoundType { off, soft, wood, bead }
enum CompletionSoundType { none, bell, softBell, templeBell }

/// Offline Audio Engine
/// Checks for custom audio files in `assets/audio/` (configured in `SoundAssets`).
/// If an asset file is not present, seamlessly generates pristine procedural
/// micro-waveforms (PCM 16-bit Mono WAV) in memory with 0ms latency.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioPlayer? _tapPlayer;
  AudioPlayer? _completionPlayer;
  AudioPlayer? _meditationPlayer;
  bool _isAudioAvailable = true;

  final Map<String, Uint8List> _wavCache = {};
  final Set<String> _existingAssetPaths = {};

  AudioService._internal() {
    _initPrecachedSounds();
  }

  AudioPlayer? _getTapPlayer() {
    if (!_isAudioAvailable) return null;
    try {
      _tapPlayer ??= AudioPlayer();
      return _tapPlayer;
    } catch (_) {
      _isAudioAvailable = false;
      return null;
    }
  }

  AudioPlayer? _getCompletionPlayer() {
    if (!_isAudioAvailable) return null;
    try {
      _completionPlayer ??= AudioPlayer();
      return _completionPlayer;
    } catch (_) {
      _isAudioAvailable = false;
      return null;
    }
  }

  AudioPlayer? _getMeditationPlayer() {
    if (!_isAudioAvailable) return null;
    try {
      _meditationPlayer ??= AudioPlayer();
      return _meditationPlayer;
    } catch (_) {
      _isAudioAvailable = false;
      return null;
    }
  }

  void _initPrecachedSounds() {
    try {
      _wavCache['soft_tap'] = _generateTapWav(frequency: 440, decayDurationMs: 35, attackMs: 2);
      _wavCache['wood_tap'] = _generateWoodClickWav();
      _wavCache['bead_tap'] = _generateBeadSnapWav();
      _wavCache['soft_bell'] = _generateChimeWav(fundamentalFreq: 528, durationMs: 1200);
      _wavCache['temple_bell'] = _generateTempleBellWav(durationMs: 2200);
      _wavCache['meditation_bell'] = _generateChimeWav(fundamentalFreq: 432, durationMs: 2500);
      _wavCache['meditation_loop'] = _generateLoopingMeditationBellWav(durationMs: 4000);
    } catch (e) {
      debugPrint('Audio initialization error: $e');
    }
  }

  /// Helper to play an audio source (checks asset first, then falls back to memory bytes)
  Future<void> _playWithFallback({
    required AudioPlayer? player,
    required String assetPath,
    required String fallbackCacheKey,
    required double volume,
  }) async {
    if (player == null) return;

    // Check if asset can be loaded
    final normalizedPath = assetPath.startsWith('assets/') ? assetPath.substring(7) : assetPath;

    try {
      if (_existingAssetPaths.contains(assetPath)) {
        await player.stop();
        await player.play(AssetSource(normalizedPath), volume: volume);
        return;
      }

      // Check asset bundle
      try {
        await rootBundle.load(assetPath);
        _existingAssetPaths.add(assetPath);
        await player.stop();
        await player.play(AssetSource(normalizedPath), volume: volume);
        return;
      } catch (_) {
        // Asset not found on device, fallback to procedural audio
      }
    } catch (_) {
      // Fallback
    }

    // Play procedural waveform
    final soundBytes = _wavCache[fallbackCacheKey];
    if (soundBytes != null) {
      try {
        await player.stop();
        await player.play(BytesSource(soundBytes), volume: volume);
      } catch (_) {}
    }
  }

  Future<void> playTapSound(TapSoundType type) async {
    if (type == TapSoundType.off || !_isAudioAvailable) return;

    String assetPath;
    String fallbackKey;

    switch (type) {
      case TapSoundType.soft:
        assetPath = SoundAssets.tapSoft;
        fallbackKey = 'soft_tap';
        break;
      case TapSoundType.wood:
        assetPath = SoundAssets.tapWood;
        fallbackKey = 'wood_tap';
        break;
      case TapSoundType.bead:
        assetPath = SoundAssets.tapBead;
        fallbackKey = 'bead_tap';
        break;
      case TapSoundType.off:
        return;
    }

    final player = _getTapPlayer();
    await _playWithFallback(
      player: player,
      assetPath: assetPath,
      fallbackCacheKey: fallbackKey,
      volume: 0.4,
    );
  }

  Future<void> playCompletionSound(CompletionSoundType type) async {
    if (type == CompletionSoundType.none || !_isAudioAvailable) return;

    String assetPath;
    String fallbackKey;

    switch (type) {
      case CompletionSoundType.bell:
      case CompletionSoundType.softBell:
        assetPath = SoundAssets.bellSoft;
        fallbackKey = 'soft_bell';
        break;
      case CompletionSoundType.templeBell:
        assetPath = SoundAssets.bellTemple;
        fallbackKey = 'temple_bell';
        break;
      case CompletionSoundType.none:
        return;
    }

    final player = _getCompletionPlayer();
    await _playWithFallback(
      player: player,
      assetPath: assetPath,
      fallbackCacheKey: fallbackKey,
      volume: 0.7,
    );
  }

  Future<void> playMeditationBell() async {
    if (!_isAudioAvailable) return;
    final player = _getCompletionPlayer();
    await _playWithFallback(
      player: player,
      assetPath: SoundAssets.meditationBell,
      fallbackCacheKey: 'meditation_bell',
      volume: 0.8,
    );
  }

  /// Plays any sound from the sound catalog by id (useful for testing or sound previews)
  Future<void> playPreviewSound(String soundId) async {
    switch (soundId) {
      case 'tap_soft':
        await playTapSound(TapSoundType.soft);
        break;
      case 'tap_wood':
        await playTapSound(TapSoundType.wood);
        break;
      case 'tap_bead':
        await playTapSound(TapSoundType.bead);
        break;
      case 'bell_soft':
        await playCompletionSound(CompletionSoundType.softBell);
        break;
      case 'bell_temple':
        await playCompletionSound(CompletionSoundType.templeBell);
        break;
      case 'meditation_bell':
        await playMeditationBell();
        break;
      case 'meditation_ambient':
        await startMeditationSound();
        Future.delayed(const Duration(seconds: 3), () => stopMeditationSound());
        break;
    }
  }

  Future<void> startMeditationSound({bool isMuted = false}) async {
    if (!_isAudioAvailable) return;
    try {
      final soundBytes = _wavCache['meditation_loop'] ?? _wavCache['meditation_bell'];
      final player = _getMeditationPlayer();
      if (player != null && soundBytes != null) {
        await player.stop();
        await player.setReleaseMode(ReleaseMode.loop);
        await player.setVolume(isMuted ? 0.0 : 0.65);
        await player.play(BytesSource(soundBytes));
      }
    } catch (_) {
      // Graceful fallback
    }
  }

  Future<void> stopMeditationSound() async {
    if (!_isAudioAvailable) return;
    try {
      final player = _getMeditationPlayer();
      if (player != null) {
        await player.stop();
      }
    } catch (_) {
      // Graceful fallback
    }
  }

  Future<void> setMeditationMuted(bool isMuted) async {
    if (!_isAudioAvailable) return;
    try {
      final player = _getMeditationPlayer();
      if (player != null) {
        await player.setVolume(isMuted ? 0.0 : 0.65);
      }
    } catch (_) {
      // Graceful fallback
    }
  }

  // --- WAV Synthesis Algorithms ---

  static Uint8List _generateTapWav({
    required double frequency,
    required int decayDurationMs,
    required int attackMs,
  }) {
    const int sampleRate = 22050;
    final int totalSamples = (sampleRate * (decayDurationMs / 1000.0)).round();
    final int attackSamples = (sampleRate * (attackMs / 1000.0)).round();
    final List<int> pcmData = [];

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      double envelope = 1.0;
      if (i < attackSamples) {
        envelope = i / attackSamples;
      } else {
        envelope = exp(-5.0 * (i - attackSamples) / (totalSamples - attackSamples));
      }

      final double sample = sin(2 * pi * frequency * t) * envelope * 0.5;
      final int intSample = (sample * 32767).round().clamp(-32768, 32767);
      pcmData.add(intSample);
    }

    return _encodeWav(pcmData, sampleRate: sampleRate);
  }

  static Uint8List _generateWoodClickWav() {
    const int sampleRate = 22050;
    const int totalSamples = 800;
    final List<int> pcmData = [];

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double env = exp(-12.0 * (i / totalSamples));
      final double wave = (sin(2 * pi * 820 * t) * 0.7 + sin(2 * pi * 1450 * t) * 0.3);
      final double sample = wave * env * 0.6;
      final int intSample = (sample * 32767).round().clamp(-32768, 32767);
      pcmData.add(intSample);
    }

    return _encodeWav(pcmData, sampleRate: sampleRate);
  }

  static Uint8List _generateBeadSnapWav() {
    const int sampleRate = 22050;
    const int totalSamples = 600;
    final List<int> pcmData = [];
    final Random rand = Random(42);

    for (int i = 0; i < totalSamples; i++) {
      final double env = exp(-15.0 * (i / totalSamples));
      final double noise = (rand.nextDouble() * 2.0 - 1.0) * 0.3;
      final double t = i / sampleRate;
      final double tone = sin(2 * pi * 1100 * t) * 0.7;
      final double sample = (tone + noise) * env * 0.5;
      final int intSample = (sample * 32767).round().clamp(-32768, 32767);
      pcmData.add(intSample);
    }

    return _encodeWav(pcmData, sampleRate: sampleRate);
  }

  static Uint8List _generateChimeWav({
    required double fundamentalFreq,
    required int durationMs,
  }) {
    const int sampleRate = 44100;
    final int totalSamples = (sampleRate * (durationMs / 1000.0)).round();
    final List<int> pcmData = [];

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double env1 = exp(-3.0 * t);
      final double env2 = exp(-4.5 * t);
      final double env3 = exp(-6.0 * t);

      final double s1 = sin(2 * pi * fundamentalFreq * t) * env1 * 0.6;
      final double s2 = sin(2 * pi * (fundamentalFreq * 2.76) * t) * env2 * 0.25;
      final double s3 = sin(2 * pi * (fundamentalFreq * 5.4) * t) * env3 * 0.15;

      final double sample = (s1 + s2 + s3) * 0.7;
      final int intSample = (sample * 32767).round().clamp(-32768, 32767);
      pcmData.add(intSample);
    }

    return _encodeWav(pcmData, sampleRate: sampleRate);
  }

  static Uint8List _generateTempleBellWav({required int durationMs}) {
    const int sampleRate = 44100;
    final int totalSamples = (sampleRate * (durationMs / 1000.0)).round();
    final List<int> pcmData = [];
    const double baseFreq = 260.0;

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double env1 = exp(-2.0 * t);
      final double env2 = exp(-3.2 * t);
      final double env3 = exp(-4.0 * t);
      final double env4 = exp(-1.5 * t);

      final double s1 = sin(2 * pi * baseFreq * t) * env1 * 0.5;
      final double s2 = sin(2 * pi * (baseFreq * 2.0) * t) * env2 * 0.25;
      final double s3 = sin(2 * pi * (baseFreq * 3.01) * t) * env3 * 0.15;
      final double s4 = sin(2 * pi * (baseFreq * 0.5) * t) * env4 * 0.1;

      final double sample = (s1 + s2 + s3 + s4) * 0.75;
      final int intSample = (sample * 32767).round().clamp(-32768, 32767);
      pcmData.add(intSample);
    }

    return _encodeWav(pcmData, sampleRate: sampleRate);
  }

  static Uint8List _generateLoopingMeditationBellWav({required int durationMs}) {
    const int sampleRate = 22050;
    final int totalSamples = (sampleRate * (durationMs / 1000.0)).round();
    final List<int> pcmData = [];
    const double fundamentalFreq = 432.0; // Sacred 432 Hz healing vibration

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double totalT = durationMs / 1000.0;
      // Gentle cyclical breathing envelope for seamless looping
      final double cycleEnv = 0.6 + 0.4 * sin(2 * pi * (t / totalT));
      // Soft edge smoothing for click-free looping
      double edgeFade = 1.0;
      final double fadeSamples = sampleRate * 0.05; // 50ms fade
      if (i < fadeSamples) {
        edgeFade = i / fadeSamples;
      } else if (i > totalSamples - fadeSamples) {
        edgeFade = (totalSamples - i) / fadeSamples;
      }

      final double s1 = sin(2 * pi * fundamentalFreq * t) * 0.45;
      final double s2 = sin(2 * pi * (fundamentalFreq * 0.5) * t) * 0.3; // Sub octave warm drone (216 Hz)
      final double s3 = sin(2 * pi * (fundamentalFreq * 2.005) * t) * 0.15; // Shimmer overtone
      final double s4 = sin(2 * pi * (fundamentalFreq * 3.01) * t) * 0.1;

      final double sample = (s1 + s2 + s3 + s4) * cycleEnv * edgeFade * 0.55;
      final int intSample = (sample * 32767).round().clamp(-32768, 32767);
      pcmData.add(intSample);
    }

    return _encodeWav(pcmData, sampleRate: sampleRate);
  }

  static Uint8List _encodeWav(List<int> samples, {required int sampleRate}) {
    final int byteRate = sampleRate * 2;
    final int subChunk2Size = samples.length * 2;
    final int chunkSize = 36 + subChunk2Size;

    final ByteData byteData = ByteData(44 + subChunk2Size);

    byteData.setUint8(0, 0x52);
    byteData.setUint8(1, 0x49);
    byteData.setUint8(2, 0x46);
    byteData.setUint8(3, 0x46);
    byteData.setUint32(4, chunkSize, Endian.little);
    byteData.setUint8(8, 0x57);
    byteData.setUint8(9, 0x41);
    byteData.setUint8(10, 0x56);
    byteData.setUint8(11, 0x45);

    byteData.setUint8(12, 0x66);
    byteData.setUint8(13, 0x6D);
    byteData.setUint8(14, 0x74);
    byteData.setUint8(15, 0x20);
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);
    byteData.setUint16(22, 1, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, byteRate, Endian.little);
    byteData.setUint16(32, 2, Endian.little);
    byteData.setUint16(34, 16, Endian.little);

    byteData.setUint8(36, 0x64);
    byteData.setUint8(37, 0x61);
    byteData.setUint8(38, 0x74);
    byteData.setUint8(39, 0x61);
    byteData.setUint32(40, subChunk2Size, Endian.little);

    int offset = 44;
    for (final sample in samples) {
      byteData.setInt16(offset, sample, Endian.little);
      offset += 2;
    }

    return byteData.buffer.asUint8List();
  }

  void dispose() {
    _tapPlayer?.dispose();
    _completionPlayer?.dispose();
    _meditationPlayer?.dispose();
  }
}
