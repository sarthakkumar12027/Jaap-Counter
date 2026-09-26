# Jaap Counter (जाप काउंटर)

A peaceful, minimal, and beautiful digital Mala and Jaap counting application built with Flutter. Designed for daily spiritual practice across various traditions with mindful haptics, custom audio feedback, daily goal tracking, and multilingual support.

---

## ✨ Features

- **Minimalist & Distraction-Free:** Clean interface designed to keep your focus entirely on your spiritual chant.
- **Multiple Visualizer Modes:** Choose between a traditional Mala bead wheel, a minimal modern progress ring, or a full-screen Focus Mode.
- **Mantra Library:** Built-in catalog of popular chants, prayers, and mantras with original script, transliteration, and meanings (Radhe Radhe, Mahamantra, Gayatri Mantra, Waheguru, Om Mani Padme Hum, Navkar Mantra, Tasbih, and more).
- **Custom Profiles:** Create, edit, and organize multiple Jaap routines with custom mala sizes (27, 54, 108, or custom) and accent colors.
- **Mindful Feedback:**
  - Haptic feedback on every tap (light, medium, heavy, or bead simulation).
  - Subtle acoustic bells / chimes at mala milestones.
  - Optional Voice/Speech counting.
- **Daily Goals & Streak Tracking:** Track daily completion, view history and practice stats, and build consistent daily habits.
- **Meditation & Breath Timer:** Built-in timer with soothing ambient background sounds (Om frequency, Temple bell, Rain, River).
- **Offline & Private:** All data is saved locally on your device using Hive. No account or cloud sync required.
- **Multilingual Support:** Localized in 11 languages including English, Hindi, Bengali, Punjabi, Gujarati, Tamil, Telugu, Marathi, Kannada, Malayalam, and Odia.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) (Dart 3.x)
- **Local Storage:** [Hive](https://pub.dev/packages/hive) & [Hive Flutter](https://pub.dev/packages/hive_flutter)
- **State Management:** Reactive controller pattern using Flutter's native `ChangeNotifier` / `ListenableBuilder`
- **Audio & Haptics:** `audioplayers`, `flutter_tts`, `vibration`
- **Charts & UI:** `fl_chart`, `shared_preferences`, `intl`

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.24.0 or higher recommended)
- [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
- An Android or iOS device / emulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/sarthakkumar12027/Jaap-Counter.git]
   cd jaap_counter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

4. **Build APK (Android):**
   ```bash
   flutter build apk --release
   ```

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/       # App colors, typography, theme configs
│   ├── localization/    # 11-language translation engine
│   └── services/        # Audio, Haptics, Storage, TTS services
├── data/
│   ├── models/          # JaapProfile, JaapSession, MantraItem models
│   └── repositories/    # Mantra catalog & local database repository
├── state/               # App, Jaap, History, Meditation controllers
└── ui/
    ├── counter/         # Main counting screen & focus mode
    ├── history/         # Analytics, calendar, and streak tracker
    ├── library/         # Built-in mantra selection sheet
    ├── meditation/      # Timed meditation & ambient audio
    └── settings/        # Preferences, sound guide, language switcher
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
