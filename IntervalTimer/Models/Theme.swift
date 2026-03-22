import SwiftUI

enum AppColors {
    static let workGreen = Color(red: 0.18, green: 0.80, blue: 0.25)
    static let workGreenDark = Color(red: 0.11, green: 0.62, blue: 0.18)
    static let restBlue = Color(red: 0.13, green: 0.59, blue: 0.95)
    static let restBlueDark = Color(red: 0.08, green: 0.40, blue: 0.75)
    static let warmupOrange = Color(red: 1.0, green: 0.60, blue: 0.0)
    static let warmupOrangeDark = Color(red: 0.90, green: 0.32, blue: 0.0)
    static let accentGreen = Color(red: 0.18, green: 0.80, blue: 0.25)
    static let cardSurface = Color(red: 0.14, green: 0.14, blue: 0.22)
    static let darkSurface = Color(red: 0.10, green: 0.10, blue: 0.18)
    static let darkBackground = Color(red: 0.06, green: 0.06, blue: 0.10)

    static func phaseColor(for phase: TimerPhase) -> Color {
        switch phase {
        case .warmup: warmupOrange
        case .work: workGreen
        case .rest: restBlue
        }
    }

    static func phaseButtonColor(for phase: TimerPhase) -> Color {
        switch phase {
        case .warmup: warmupOrangeDark
        case .work: workGreenDark
        case .rest: restBlueDark
        }
    }
}
