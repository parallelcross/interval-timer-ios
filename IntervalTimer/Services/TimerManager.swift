import Foundation
import AVFoundation
import Observation

@Observable
@MainActor
final class TimerManager {
    var state = TimerState()
    var countdownSeconds: Int = UserDefaults.standard.integer(forKey: "countdownSeconds") == 0
        ? 3
        : UserDefaults.standard.integer(forKey: "countdownSeconds")

    private var timer: Timer?
    private let synthesizer = AVSpeechSynthesizer()

    func updateSets(_ value: Int) {
        state.sets = max(1, min(99, value))
    }

    func updateWorkSeconds(_ value: Int) {
        state.workSeconds = max(5, min(3600, value))
        state.remainingSeconds = state.workSeconds
    }

    func updateRestSeconds(_ value: Int) {
        state.restSeconds = max(5, min(3600, value))
    }

    func startWorkout() {
        configureAudioSession()
        state.isRunning = true
        state.isPaused = false
        state.isFinished = false
        state.currentSet = 1

        if state.warmupEnabled {
            state.currentPhase = .warmup
            state.remainingSeconds = 60
            speak("Get ready. Starting in 1 minute.")
        } else {
            state.currentPhase = .work
            state.remainingSeconds = state.workSeconds
            speak("Starting work. Set 1 of \(state.sets)")
        }

        startTicking()
    }

    func stopWorkout() {
        timer?.invalidate()
        timer = nil
        synthesizer.stopSpeaking(at: .immediate)
        state.isRunning = false
        state.isPaused = false
        state.isFinished = false
        state.currentSet = 1
        state.currentPhase = .work
        state.remainingSeconds = state.workSeconds
        deactivateAudioSession()
    }

    func togglePause() {
        if state.isPaused {
            state.isPaused = false
            startTicking()
        } else {
            state.isPaused = true
            timer?.invalidate()
            timer = nil
        }
    }

    func skipForward() {
        timer?.invalidate()
        timer = nil
        advancePhase()
        if !state.isFinished && !state.isPaused {
            startTicking()
        }
    }

    func skipBackward() {
        timer?.invalidate()
        timer = nil

        switch state.currentPhase {
        case .warmup:
            state.remainingSeconds = 60
        case .rest:
            state.currentPhase = .work
            state.remainingSeconds = state.workSeconds
            speak("Starting work. Set \(state.currentSet) of \(state.sets)")
        case .work:
            if state.currentSet > 1 {
                state.currentSet -= 1
            }
            state.remainingSeconds = state.workSeconds
            speak("Starting work. Set \(state.currentSet) of \(state.sets)")
        }

        if !state.isPaused {
            startTicking()
        }
    }

    func updateCountdownSeconds(_ value: Int) {
        countdownSeconds = max(0, min(20, value))
        UserDefaults.standard.set(countdownSeconds, forKey: "countdownSeconds")
    }

    // MARK: - Private

    private func startTicking() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func tick() {
        guard state.isRunning, !state.isPaused else { return }

        state.remainingSeconds -= 1

        // Voice countdown before phase ends
        if countdownSeconds > 0 && state.remainingSeconds <= countdownSeconds && state.remainingSeconds > 0 {
            if state.remainingSeconds == countdownSeconds {
                let phaseName = state.currentPhase == .warmup ? "warmup" : state.currentPhase.rawValue.lowercased()
                speak("Finishing \(phaseName) in \(state.remainingSeconds)")
            } else {
                speak("\(state.remainingSeconds)")
            }
        }

        // Progress cues for long work intervals
        if state.currentPhase == .work && state.workSeconds > 60 {
            let elapsed = state.workSeconds - state.remainingSeconds
            let total = state.workSeconds
            if elapsed == total / 4 { speak("25% done") }
            else if elapsed == total / 2 { speak("Halfway there") }
            else if elapsed == total * 3 / 4 { speak("75% done") }
        }

        if state.remainingSeconds <= 0 {
            advancePhase()
        }
    }

    private func advancePhase() {
        switch state.currentPhase {
        case .warmup:
            state.currentPhase = .work
            state.remainingSeconds = state.workSeconds
            speak("Starting work. Set 1 of \(state.sets)")

        case .work:
            let isLastSet = state.currentSet >= state.sets
            if isLastSet && state.skipLastRest {
                finishWorkout()
                return
            } else if isLastSet {
                state.currentPhase = .rest
                state.remainingSeconds = state.restSeconds
                speak("Starting rest")
            } else {
                state.currentPhase = .rest
                state.remainingSeconds = state.restSeconds
                speak("Starting rest")
            }

        case .rest:
            let isLastSet = state.currentSet >= state.sets
            if isLastSet {
                finishWorkout()
                return
            }
            state.currentSet += 1
            state.currentPhase = .work
            state.remainingSeconds = state.workSeconds
            speak("Starting work. Set \(state.currentSet) of \(state.sets)")
        }
    }

    private func finishWorkout() {
        timer?.invalidate()
        timer = nil
        state.isRunning = false
        state.isFinished = true
        speak("Workout complete!")
        deactivateAudioSession()
    }

    private func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.volume = 0.5
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, options: .duckOthers)
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    private func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session deactivation error: \(error)")
        }
    }
}
