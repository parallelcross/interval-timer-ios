import SwiftUI

struct ActiveTimerScreen: View {
    @Environment(TimerManager.self) private var timerManager
    @Binding var navigation: NavigationPath

    var body: some View {
        let phase = timerManager.state.currentPhase
        let bgColor = AppColors.phaseColor(for: phase)
        let buttonColor = AppColors.phaseButtonColor(for: phase)

        ZStack {
            bgColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: phase)

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        timerManager.stopWorkout()
                        navigation.removeLast(navigation.count)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text("REMAINING")
                            .font(.caption2.bold())
                            .foregroundStyle(.white.opacity(0.7))
                            .tracking(1)
                        Text(formatTime(timerManager.state.totalRemainingSeconds))
                            .font(.subheadline.bold().monospacedDigit())
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                // Phase label
                Text(phaseLabel)
                    .font(.title3.bold())
                    .foregroundStyle(.white.opacity(0.8))
                    .tracking(2)

                // Main countdown
                Text(formatTime(timerManager.state.remainingSeconds))
                    .font(.system(size: 96, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)

                Spacer()

                // Controls
                HStack(spacing: 32) {
                    Button {
                        timerManager.skipBackward()
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                    }

                    Button {
                        timerManager.togglePause()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: timerManager.state.isPaused ? "play.fill" : "pause.fill")
                                .font(.title2)
                            Text(timerManager.state.isPaused ? "Resume" : "Pause")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(buttonColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .animation(.easeInOut(duration: 0.4), value: phase)
                    }

                    Button {
                        timerManager.skipForward()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: timerManager.state.isFinished) { _, finished in
            if finished {
                navigation.removeLast()
                navigation.append(Route.completion)
            }
        }
    }

    private var phaseLabel: String {
        switch timerManager.state.currentPhase {
        case .warmup:
            return "GET READY"
        case .work:
            return "WORK \(timerManager.state.currentSet)/\(timerManager.state.sets)"
        case .rest:
            return "REST \(timerManager.state.currentSet)/\(timerManager.state.sets)"
        }
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let m = totalSeconds / 60
        let s = totalSeconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
