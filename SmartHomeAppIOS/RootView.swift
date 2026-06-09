import SwiftUI

struct RootView: View {
    @Environment(SessionStore.self) private var sessionStore

    var body: some View {
        Group {
            switch sessionStore.state {
            case .loading:
                ZStack {
                    Color("BackgroundPrimary").ignoresSafeArea()
                    ProgressView()
                }

            case .unauthenticated:
                LoginView()

            case .authenticated:
                ContentView()
            }
        }
        .task { await sessionStore.load() }
    }
}

#Preview {
    let store = SessionStore(service: MockAuthService(), tokenStore: InMemoryTokenStore())
    return RootView().environment(store)
}
