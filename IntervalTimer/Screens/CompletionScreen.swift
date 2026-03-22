import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    let x: CGFloat
    let speed: Double
    let delay: Double
    let wobble: CGFloat
    let rotation: Double
}

struct CompletionScreen: View {
    @Binding var navigation: NavigationPath
    @State private var animating = false

    private let confetti: [ConfettiPiece] = (0..<80).map { _ in
        ConfettiPiece(
            color: [
                AppColors.workGreen, AppColors.restBlue, AppColors.warmupOrange,
                Color.yellow, Color.pink, Color.purple, Color.cyan, Color.red
            ].randomElement()!,
            size: CGFloat.random(in: 6...16),
            x: CGFloat.random(in: 0...1),
            speed: Double.random(in: 2...4),
            delay: Double.random(in: 0...1.5),
            wobble: CGFloat.random(in: -30...30),
            rotation: Double.random(in: 0...360)
        )
    }

    var body: some View {
        ZStack {
            AppColors.darkBackground.ignoresSafeArea()

            // Confetti
            GeometryReader { geo in
                ForEach(confetti) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 0.6)
                        .rotationEffect(.degrees(animating ? piece.rotation + 360 : piece.rotation))
                        .position(
                            x: geo.size.width * piece.x + (animating ? piece.wobble : 0),
                            y: animating ? geo.size.height + 20 : -20
                        )
                        .animation(
                            .easeIn(duration: piece.speed).delay(piece.delay),
                            value: animating
                        )
                }
            }
            .ignoresSafeArea()

            // Content
            VStack(spacing: 24) {
                Spacer()

                Text("Workout\nComplete!")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Great job! You crushed it.")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()

                Button {
                    navigation.removeLast(navigation.count)
                } label: {
                    Text("Done")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.workGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            animating = true
        }
    }
}
