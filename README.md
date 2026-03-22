# Interval Timer

A clean workout interval timer for iOS with spoken voice coaching. Built with SwiftUI, it announces phase changes and counts down aloud so you can stay focused on your workout while listening to music.

## Features

- **Configurable workouts** — Set number of rounds (1–99), work duration (5s–60min), and rest duration (5s–60min)
- **Voice announcements** — Speaks phase transitions ("Starting work, Set 1 of 8"), progress cues (25%, 50%, 75%), and configurable countdown before phase ends
- **Audio ducking** — Automatically lowers your music volume during announcements, then restores it
- **Visual feedback** — Full-screen color changes (green for work, blue for rest, orange for warmup) with animated transitions
- **Smart controls** — Skip forward/back between intervals, pause/resume anytime
- **Skip last rest** — Toggle to end your workout immediately after the final work set
- **1-minute warmup** — Optional countdown to get ready before your first set
- **Total time display** — See total workout duration before starting and remaining time while running
- **Completion celebration** — Animated confetti when you finish your workout
- **Voice countdown settings** — Slider to set countdown duration (0–20 seconds) or turn it off entirely
- **Dark theme** — Easy on the eyes during workouts

## Screenshots

### Setup Screen
Configure your workout with intuitive +/- controls:
- **Sets:** 1–99 rounds
- **Work:** 5 seconds to 60 minutes per round
- **Rest:** 5 seconds to 60 minutes between rounds
- Toggle skip last rest and warmup countdown

### Active Timer
Full-screen countdown with:
- Large, readable timer
- Current set and phase indicator
- Total remaining time
- Pause, skip forward, and skip back controls
- Animated color transitions between phases
- Spoken countdown and phase announcements

## Tech Stack

| Component | Version |
|-----------|---------|
| Swift | 6.0 |
| SwiftUI | Latest |
| iOS Deployment Target | 17.0 |
| Project Generation | xcodegen |

## Building

Generate the Xcode project and build:

```bash
xcodegen generate
open IntervalTimer.xcodeproj
```

Or from the command line:

```bash
xcodegen generate
xcodebuild -project IntervalTimer.xcodeproj -scheme IntervalTimer -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Architecture

Single-window SwiftUI app with `@Observable` TimerManager passed via environment:

- `SetupScreen` — Workout configuration with sets, work/rest durations, toggles
- `ActiveTimerScreen` — Full-screen countdown timer with voice coaching
- `CompletionScreen` — Animated confetti celebration
- `SettingsScreen` — Voice countdown slider and open source credits
- `TimerManager` — Centralized `@Observable` timer engine handling countdown, TTS, and audio session
- `TimerState` — Value type with workout config, runtime state, and computed remaining time

Uses `AVSpeechSynthesizer` for voice announcements and `AVAudioSession` with `.duckOthers` to temporarily lower music volume during speech. Settings persisted via UserDefaults.

No external dependencies — keeps the app lightweight and fast.

## License

[MIT License](LICENSE)
