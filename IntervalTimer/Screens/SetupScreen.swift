import SwiftUI

struct SetupScreen: View {
    @Environment(TimerManager.self) private var timerManager
    @Binding var navigation: NavigationPath

    var body: some View {
        @Bindable var tm = timerManager

        ZStack {
            AppColors.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("New workout")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                        Spacer()
                        Button {
                            navigation.append(Route.settings)
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Sets
                    CounterCard(
                        label: "SETS",
                        labelColor: .white,
                        value: timerManager.state.sets,
                        displayText: "\(timerManager.state.sets)",
                        onIncrement: { timerManager.updateSets(timerManager.state.sets + 1) },
                        onDecrement: { timerManager.updateSets(timerManager.state.sets - 1) }
                    )

                    // Work
                    CounterCard(
                        label: "WORK",
                        labelColor: AppColors.workGreen,
                        value: timerManager.state.workSeconds,
                        displayText: formatDuration(timerManager.state.workSeconds),
                        onIncrement: { timerManager.updateWorkSeconds(timerManager.state.workSeconds + 5) },
                        onDecrement: { timerManager.updateWorkSeconds(timerManager.state.workSeconds - 5) }
                    )

                    // Rest
                    CounterCard(
                        label: "REST",
                        labelColor: AppColors.restBlue,
                        value: timerManager.state.restSeconds,
                        displayText: formatDuration(timerManager.state.restSeconds),
                        onIncrement: { timerManager.updateRestSeconds(timerManager.state.restSeconds + 5) },
                        onDecrement: { timerManager.updateRestSeconds(timerManager.state.restSeconds - 5) }
                    )

                    // Toggles
                    VStack(spacing: 12) {
                        ToggleRow(label: "Skip last rest", isOn: $tm.state.skipLastRest)
                        ToggleRow(label: "1-minute warmup countdown", isOn: $tm.state.warmupEnabled)
                    }
                    .padding(.horizontal)

                    // Start button
                    Button {
                        timerManager.startWorkout()
                        navigation.append(Route.active)
                    } label: {
                        VStack(spacing: 4) {
                            Text("START WORKOUT")
                                .font(.headline.bold())
                            Text(formatDuration(timerManager.state.totalWorkoutSeconds))
                                .font(.subheadline)
                                .opacity(0.8)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.workGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func formatDuration(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Counter Card

struct CounterCard: View {
    let label: String
    let labelColor: Color
    let value: Int
    let displayText: String
    let onIncrement: () -> Void
    let onDecrement: () -> Void

    var body: some View {
        HStack {
            Button {
                onDecrement()
            } label: {
                Image(systemName: "minus")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 4) {
                Text(label)
                    .font(.caption.bold())
                    .foregroundStyle(labelColor)
                    .tracking(2)
                Text(displayText)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
            }

            Spacer()

            Button {
                onIncrement()
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(AppColors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Toggle Row

struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
                .foregroundStyle(.white)
        }
        .tint(AppColors.accentGreen)
    }
}
