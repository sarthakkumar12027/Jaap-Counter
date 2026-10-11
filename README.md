# Jaap Counter (जाप काउंटर)

A peaceful, minimal, and beautiful digital Mala and Jaap counting application built with Flutter. Designed for daily spiritual practice across traditions with mindful haptics, custom audio feedback, daily streak tracking, 40-day Sankalp vows, and 11-language multilingual support.

---

## ✨ Features

- **Minimalist & Distraction-Free:** Clean interface designed to keep your focus entirely on your spiritual chant.
- **Multiple Visualizer Modes:**
  - **Traditional Mala Beads:** Realistic 108-bead circular simulation with fluid rotational scrolling.
  - **Minimal Ring:** Clean modern circular progress ring with smooth completion indicators.
  - **Full-Screen Focus Mode:** Immersive, single-tap counting screen eliminating all distractions.
- **Multi-Profile Chanting:** Create, edit, and organize multiple Jaap routines with custom mala sizes (27, 54, 108, or custom targets) and custom spiritual accent colors.
- **Quick Increments & Reversible Undo:**
  - One-tap addition for `+1`, `+10`, `+27`, and `+108` counts.
  - Snapshot-based multi-step **Undo Engine** that safely reverses count additions, completed malas, session totals, and active Sankalp progress.
- **Curated Mantra Library:** Built-in catalog of 14 popular chants, prayers, and mantras with original script, transliteration, and spiritual meanings (Radhe Radhe, Mahamantra, Gayatri Mantra, Mahamrityunjaya, Waheguru, Om Mani Padme Hum, Navkar Mantra, Tasbih, and more).
- **40-Day Sankalp (Vow) Tracker:** Set sacred vows with custom targets, daily milestones, completion tracking, and visual progress indicators.
- **Mindful Feedback:**
  - Configurable tactile haptic feedback (Off, Light, Medium, Heavy, Bead Simulation) powered by Flutter's native haptic engine.
  - Subtle acoustic bells, temple gongs, singing bowls, and flute chimes for mala milestone completions.
- **History Analytics & Streaks:** Custom-rendered 7-day weekly practice bar chart, lifetime statistics, manual session logging, and consecutive-day streak tracking.
- **Timed Meditation & Ambient Audio:** Built-in meditation timer (custom durations) with continuous soothing ambient sound (Om chanting) and completion bell gong.
- **100% Offline & Private:** All data is stored locally on-device using a type-safe **Drift (SQLite)** relational database. No accounts, no servers, no ads, and no tracking. Includes full JSON Backup Export & Import.
- **Multilingual Support:** Instant runtime language switching across 11 Indian and global languages:
  - English, हिन्दी (Hindi), বাংলা (Bengali), ਪੰਜਾਬੀ (Punjabi), ગુજરાતી (Gujarati), தமிழ் (Tamil), తెలుగు (Telugu), मराठी (Marathi), ಕನ್ನಡ (Kannada), മലയാളം (Malayalam), and ଓଡ଼ିଆ (Odia).

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) (Dart 3.x)
- **Database / Local Storage:**
  - [Drift (SQLite)](https://pub.dev/packages/drift) with [sqlite3_flutter_libs](https://pub.dev/packages/sqlite3_flutter_libs) for fast, relational, ACID-compliant local storage.
  - [SharedPreferences](https://pub.dev/packages/shared_preferences) with automatic zero-data-loss migration to Drift.
- **State Management:** Reactive controller pattern using Flutter's native `ChangeNotifier` and `ListenableBuilder` (`JaapController`, `HistoryController`, `SettingsController`, `MeditationController`).
- **Typography:** [Google Fonts](https://pub.dev/packages/google_fonts) (`Outfit`).
- **Audio Service:** [Audioplayers](https://pub.dev/packages/audioplayers) for low-latency acoustic feedback and ambient looping.
- **Haptic Engine:** Native `HapticFeedback` via custom `HapticService`.
- **Localization:** Lightweight zero-dependency translation engine (`AppLocalizations`).
- **UI Components:** Custom Canvas-drawn analytics (`WeeklyChart`), procedural bead rendering (`MalaBeads`), and custom Cupertino/Material adaptive sheets.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.24.0 or higher)
- [Android Studio](https://developer.android.com/studio) / VS Code with Flutter extension
- An Android device or emulator (Android 7.0+ / API 24+) or iOS device / simulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sarthakkumar12027/Jaap-Counter.git
   cd jaap_counter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run tests:**
   ```bash
   flutter test
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/       # App colors, typography, sound asset paths
│   ├── localization/    # 11-language runtime translation engine
│   ├── services/        # AudioService, HapticService, StorageService
│   └── theme/           # Light & Dark theme definitions with spiritual accent colors
├── data/
│   ├── database/        # Drift SQLite database, tables, and migration logic
│   ├── models/          # JaapProfile, JaapSession, SankalpGoal, UserSettings, MantraItem
│   └── repositories/    # Mantra catalog & Jaap data repository
├── state/               # JaapController, HistoryController, SettingsController, MeditationController
└── ui/
    ├── counter/         # Main counting screen, Mala wheel, ring, profile sheet
    ├── focus/           # Fullscreen distraction-free chanting mode
    ├── history/         # Analytics, custom weekly chart, and streak tracker
    ├── library/         # Built-in 14-mantra curated spiritual library
    ├── meditation/      # Timed meditation with ambient sound & bell timer
    ├── navigation/      # Main bottom navigation bar
    ├── onboarding/      # First-launch language and initial setup screen
    ├── settings/        # Preferences, Sankalp management, backup/restore, sound guide
    └── widgets/         # Mala bead wheel, minimal ring, completion toast, streak badge
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
