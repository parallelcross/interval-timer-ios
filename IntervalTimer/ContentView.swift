import SwiftUI

struct ContentView: View {
    @State private var navigation = NavigationPath()
    @State private var timerManager = TimerManager()

    var body: some View {
        NavigationStack(path: $navigation) {
            SetupScreen(navigation: $navigation)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .active:
                        ActiveTimerScreen(navigation: $navigation)
                    case .completion:
                        CompletionScreen(navigation: $navigation)
                    case .settings:
                        SettingsScreen()
                    }
                }
        }
        .environment(timerManager)
    }
}

enum Route: Hashable {
    case active
    case completion
    case settings
}
