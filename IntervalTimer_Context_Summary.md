# IntervalTimer iOS — Context Summary

## What It Is
An iOS port of the Android Interval Timer app. A clean, dark-themed workout timer with voice coaching via AVSpeechSynthesizer. Users configure sets, work/rest durations, and optional warmup, then run a full-screen color-coded countdown with TTS announcements.

## Tech Stack
- **Swift 6.0**, **SwiftUI**, iOS 17.0+
- **xcodegen** for project generation (`project.yml`)
- **AVFoundation** for speech synthesis (AVSpeechSynthesizer) and audio session management
- **@Observable** ViewModels (`TimerManager`), `@MainActor` for concurrency safety
- **UserDefaults** for settings persistence (countdown seconds)
- **NavigationStack** with typed `Route` enum for navigation

## Architecture
- `TimerManager` — `@Observable` singleton managing all timer state, countdown logic, TTS, and audio session
- `TimerState` — value type with workout config + runtime state + computed remaining time
- Screens: `SetupScreen` → `ActiveTimerScreen` → `CompletionScreen`, plus `SettingsScreen`
- `TimerManager` passed via SwiftUI `.environment()`

## Bundle / Package
- **Bundle ID:** `com.intervaltimer.app`
- **Display Name:** Interval Timer

## Features
1. Configurable interval workouts (1–99 sets, 5s–60min work/rest)
2. Skip last rest toggle
3. Optional 1-minute warmup countdown
4. Voice announcements (phase transitions, progress cues at 25/50/75%, configurable countdown)
5. Audio ducking (`.duckOthers`) so music plays underneath TTS
6. Full-screen color-coded timer (green=work, blue=rest, orange=warmup)
7. Pause/resume, skip forward/backward controls
8. Animated confetti on workout completion
9. Settings screen with voice countdown slider (0–20s)
10. Dark theme throughout

## Key Design Decisions
- No foreground service needed — iOS keeps the app alive with audio session active
- AVSpeechSynthesizer at 50% volume to blend with background music
- Timer uses Foundation `Timer` on main actor (simpler than Android's coroutine approach)
- Navigation via `NavigationStack` + `NavigationPath` for programmatic push/pop

## Screens
| Screen | File | Description |
|--------|------|-------------|
| Setup | `SetupScreen.swift` | Configure workout parameters, show total time, start button |
| Active Timer | `ActiveTimerScreen.swift` | Full-screen countdown, phase colors, controls |
| Completion | `CompletionScreen.swift` | Confetti animation, "Workout Complete!" |
| Settings | `SettingsScreen.swift` | Voice countdown slider, open source credits |

## Color Palette
- Background: `#0F0F1A`, Card: `#242438`
- Work: `#2ECC40` (dark: `#1B9E2F`)
- Rest: `#2196F3` (dark: `#1565C0`)
- Warmup: `#FF9800` (dark: `#E65100`)
