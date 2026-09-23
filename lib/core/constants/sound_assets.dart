// Central Sound Assets Registry for Jaap Counter
//
// This file lists every sound effect used in the app, where it is used,
// and where you can place custom audio files (.mp3 or .wav) in assets/audio/.
//
// ============================================================================
// HOW TO ADD YOUR OWN CUSTOM SOUNDS:
// ============================================================================
// 1. Copy your audio file (.mp3 or .wav) into the assets/audio/ folder.
// 2. Make sure the filename matches the path below (or update the path here).
// 3. If no file is placed in assets/audio/, the app will automatically use
//    its built-in procedural sound generator as a graceful fallback.
// ============================================================================

class AppSoundItem {
  final String id;
  final String title;
  final String description;
  final String assetPath;
  final String usageLocation;
  final SoundCategory category;

  const AppSoundItem({
    required this.id,
    required this.title,
    required this.description,
    required this.assetPath,
    required this.usageLocation,
    required this.category,
  });
}

enum SoundCategory {
  tap,
  completion,
  meditation,
}

class SoundAssets {
  // ---------------------------------------------------------------------------
  // 1. TAP SOUNDS (Played on every jaap chant / count tap)
  // ---------------------------------------------------------------------------
  
  /// Soft minimal droplet tap (Default)
  static const String tapSoft = 'assets/audio/tap_soft.mp3';

  /// Wooden clapper / prayer beads wood sound
  static const String tapWood = 'assets/audio/tap_wood.mp3';

  /// Rudraksha / Tulsi bead snap sound
  static const String tapBead = 'assets/audio/tap_bead.mp3';

  // ---------------------------------------------------------------------------
  // 2. MALA COMPLETION & STREAK SOUNDS (Played when 108 / mala completes)
  // ---------------------------------------------------------------------------

  /// Soft soothing Tibetan singing bell chime
  static const String bellSoft = 'assets/audio/bell_soft.mp3';

  /// Traditional resonant Temple Bell (Ghanti / Shankh / Mandir Bell)
  static const String bellTemple = 'assets/audio/bell_temple.mp3';

  // ---------------------------------------------------------------------------
  // 3. MEDITATION & SACRED AMBIENCE SOUNDS
  // ---------------------------------------------------------------------------

  /// Meditation start / completion singing bowl chime
  static const String meditationBell = 'assets/audio/meditation_bell.mp3';

  /// Continuous meditative ambient drone (432Hz sacred healing frequency / Tanpura)
  static const String meditationAmbient = 'assets/audio/meditation_ambient.mp3';

  // ---------------------------------------------------------------------------
  // Master Catalog with descriptions and indications
  // ---------------------------------------------------------------------------
  static const List<AppSoundItem> allSounds = [
    // Tap Sounds
    AppSoundItem(
      id: 'tap_soft',
      title: 'Soft Tap',
      description: 'Gentle, low-frequency subtle click for peaceful, quiet chanting.',
      assetPath: tapSoft,
      usageLocation: 'Chanting Screen: Count tap in Minimal Mode',
      category: SoundCategory.tap,
    ),
    AppSoundItem(
      id: 'tap_wood',
      title: 'Wood Tap',
      description: 'Acoustic wooden prayer clapper sound.',
      assetPath: tapWood,
      usageLocation: 'Chanting Screen: Count tap when Wood sound is selected',
      category: SoundCategory.tap,
    ),
    AppSoundItem(
      id: 'tap_bead',
      title: 'Bead Snap',
      description: 'Tactile sound of moving a single Tulsi / Rudraksha mala bead.',
      assetPath: tapBead,
      usageLocation: 'Chanting Screen: Count tap in Bead Mode',
      category: SoundCategory.tap,
    ),

    // Completion Sounds
    AppSoundItem(
      id: 'bell_soft',
      title: 'Soft Bell',
      description: 'Warm 528 Hz chime indicating mala or cycle completion.',
      assetPath: bellSoft,
      usageLocation: 'Mala Completion: Triggered when reaching mala size (e.g. 108)',
      category: SoundCategory.completion,
    ),
    AppSoundItem(
      id: 'bell_temple',
      title: 'Temple Bell',
      description: 'Resonant bronze temple bell with deep sustained reverb.',
      assetPath: bellTemple,
      usageLocation: 'Mala Completion: Triggered when Temple Bell is selected',
      category: SoundCategory.completion,
    ),

    // Meditation Sounds
    AppSoundItem(
      id: 'meditation_bell',
      title: 'Meditation Bowl Chime',
      description: '432 Hz singing bowl chime marking meditation interval start and end.',
      assetPath: meditationBell,
      usageLocation: 'Meditation Screen: Timer start, interval gong, and finish',
      category: SoundCategory.meditation,
    ),
    AppSoundItem(
      id: 'meditation_ambient',
      title: 'Meditation Ambient Drone',
      description: 'Calming, seamless looping background drone for deep focus.',
      assetPath: meditationAmbient,
      usageLocation: 'Meditation Screen: Looping audio during meditation session',
      category: SoundCategory.meditation,
    ),
  ];
}
