import SwiftUI

struct SettingsScreen: View {
    @Environment(TimerManager.self) private var timerManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        }
                        Text("Settings")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Voice countdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("VOICE COUNTDOWN")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.5))
                            .tracking(2)

                        Text(countdownLabel)
                            .font(.headline)
                            .foregroundStyle(.white)

                        Slider(
                            value: Binding(
                                get: { Double(timerManager.countdownSeconds) },
                                set: { timerManager.updateCountdownSeconds(Int($0)) }
                            ),
                            in: 0...20,
                            step: 1
                        )
                        .tint(AppColors.accentGreen)
                    }
                    .padding(.horizontal)

                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.horizontal)

                    // Open source
                    VStack(alignment: .leading, spacing: 12) {
                        Text("OPEN SOURCE LIBRARIES")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.5))
                            .tracking(2)

                        LibraryCard(name: "SwiftUI", description: "Declarative UI framework", license: "Apple License")
                        LibraryCard(name: "AVFoundation", description: "Audio and speech synthesis", license: "Apple License")
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    private var countdownLabel: String {
        if timerManager.countdownSeconds == 0 {
            return "Off"
        }
        return "\(timerManager.countdownSeconds)s before phase ends"
    }
}

struct LibraryCard: View {
    let name: String
    let description: String
    let license: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.headline)
                .foregroundStyle(.white)
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
            Text(license)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
