import SwiftUI

struct RootView: View {
    @Environment(SessionStore.self) private var sessionStore
    @Environment(ServerConfigStore.self) private var serverConfigStore

    @State private var displayStage: Stage = .loading

    enum Stage: Hashable {
        case loading
        case serverSetup
        case login
        case main
    }

    private var stage: Stage {
        switch (serverConfigStore.state, sessionStore.state) {
        case (.loading, _), (_, .loading): .loading
        case (.unconfigured, _): .serverSetup
        case (.configured, .unauthenticated): .login
        case (.configured, .authenticated): .main
        }
    }

    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()

            currentScreen.id(displayStage)
        }
        .task {
            await serverConfigStore.load()
            await sessionStore.load()
        }
        .onChange(of: stage, initial: true) { _, newValue in
            withAnimation(.easeInOut(duration: 0.35)) {
                displayStage = newValue
            }
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch displayStage {
        case .loading:
            ProgressView()
        case .serverSetup:
            ServerSetupView()
        case .login:
            LoginView()
        case .main:
            ContentView()
        }
    }
}

#Preview("Unconfigured") {
    let sessionStore = SessionStore(service: MockAuthService(), tokenStore: InMemoryTokenStore())
    let serverConfigStore = ServerConfigStore(persistence: InMemoryServerConfigPersistence())
    return RootView()
        .environment(sessionStore)
        .environment(serverConfigStore)
}

#Preview("Configured and signed out") {
    let sessionStore = SessionStore(service: MockAuthService(), tokenStore: InMemoryTokenStore())
    let serverConfig = Server(.http, "hub.local:8080", remote: false)
    let serverConfigStore = ServerConfigStore(persistence: InMemoryServerConfigPersistence(initial: [serverConfig]))
    return RootView()
        .environment(sessionStore)
        .environment(serverConfigStore)
}
