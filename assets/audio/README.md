# Jaap App Sound Files Guide

This directory (`assets/audio/`) is where all custom audio files for the app live.

## 🎵 Sound Files & Indications

| File Name | Format | Usage / Indication in App | Default Fallback if missing |
|:---|:---|:---|:---|
| **`tap_soft.mp3`** (or `.wav`) | MP3 / WAV | **Chant Tap (Soft)**: Played on each touch/count in Minimal Mode. | Procedural soft 440Hz waveform |
| **`tap_wood.mp3`** (or `.wav`) | MP3 / WAV | **Chant Tap (Wood)**: Played when Wood tap sound is selected. | Procedural wooden click waveform |
| **`tap_bead.mp3`** (or `.wav`) | MP3 / WAV | **Chant Tap (Bead)**: Played when Bead snap tap sound is selected. | Procedural bead friction snap waveform |
| **`bell_soft.mp3`** (or `.wav`) | MP3 / WAV | **Mala Completion (Soft Bell)**: Played when 108 / mala is reached. | Procedural 528Hz bell chime |
| **`bell_temple.mp3`** (or `.wav`) | MP3 / WAV | **Mala Completion (Temple Bell)**: Played when Temple Bell is selected. | Procedural bronze temple gong |
| **`meditation_bell.mp3`** (or `.wav`) | MP3 / WAV | **Meditation Chime**: Played when meditation timer starts or ends. | Procedural 432Hz bowl chime |
| **`meditation_ambient.mp3`** (or `.wav`) | MP3 / WAV | **Meditation Ambience**: Continuous background loop during meditation. | Procedural 432Hz ambient loop |

---

## 🛠️ How to Add or Replace Sounds Manually

1. Export your audio file as `.mp3` or `.wav` (recommended bitrate: 128kbps or 192kbps for fast loading).
2. Save or copy the file into this folder (`assets/audio/`) using one of the exact names above (e.g. `tap_soft.mp3` or `bell_temple.mp3`).
3. To configure or add new sounds in code, check:
   - Registry file: [`lib/core/constants/sound_assets.dart`](../../lib/core/constants/sound_assets.dart)
   - Audio playback engine: [`lib/core/services/audio_service.dart`](../../lib/core/services/audio_service.dart)
4. Restart or hot reload the app.

> **Note:** If an audio file is not present in this folder, the app will automatically use its built-in procedural sound generator so the app will never crash or stay silent.
