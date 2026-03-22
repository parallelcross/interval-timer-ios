import Foundation

enum TimerPhase: String {
    case warmup = "GET READY"
    case work = "WORK"
    case rest = "REST"
}

struct TimerState {
    var sets: Int = 8
    var workSeconds: Int = 20
    var restSeconds: Int = 10
    var skipLastRest: Bool = true
    var warmupEnabled: Bool = false

    var isRunning: Bool = false
    var isPaused: Bool = false
    var currentSet: Int = 1
    var currentPhase: TimerPhase = .work
    var remainingSeconds: Int = 20
    var isFinished: Bool = false

    var totalWorkoutSeconds: Int {
        let warmup = warmupEnabled ? 60 : 0
        let work = sets * workSeconds
        let restSets = skipLastRest ? max(sets - 1, 0) : sets
        let rest = restSets * restSeconds
        return warmup + work + rest
    }

    var totalRemainingSeconds: Int {
        guard isRunning else { return totalWorkoutSeconds }

        // Start with time left in current phase
        var remaining = remainingSeconds

        // Add time for all future phases
        switch currentPhase {
        case .warmup:
            // All work + rest phases remain
            remaining += sets * workSeconds
            let restSets = skipLastRest ? max(sets - 1, 0) : sets
            remaining += restSets * restSeconds

        case .work:
            // Future sets after current: work + rest for each
            let futureSets = sets - currentSet
            remaining += futureSets * workSeconds
            // Rest after current work set (unless it's last and skipLastRest)
            let isLastSet = currentSet >= sets
            if !(isLastSet && skipLastRest) {
                remaining += restSeconds
            }
            // Rest for remaining future sets
            let futureRestSets = skipLastRest ? max(futureSets - 1, 0) : futureSets
            remaining += futureRestSets * restSeconds

        case .rest:
            // Remaining sets after current
            let futureSets = sets - currentSet
            remaining += futureSets * workSeconds
            let futureRestSets = skipLastRest ? max(futureSets - 1, 0) : futureSets
            remaining += futureRestSets * restSeconds
        }

        return remaining
    }
}
