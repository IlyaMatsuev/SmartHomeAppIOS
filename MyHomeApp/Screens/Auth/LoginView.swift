import SwiftUI

struct LoginView: View {
    @Environment(SessionStore.self) private var sessionStore
    @State private var viewModel: LoginViewModel?

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                if let viewModel {
                    LoginForm(viewModel: viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ServerSwitcherMenu()
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if viewModel == nil {
                viewModel = LoginViewModel(sessionStore: sessionStore)
            }
        }
    }
}

#Preview {
    let sessionStore = SessionStore(service: MockAuthService(operationDelay: .zero), tokenStore: InMemoryTokenStore())
    let server = Server(.http, "hub.local:8080", remote: false, label: "Home")
    let serverStore = ServerConfigStore(persistence: InMemoryServerConfigPersistence(initial: [server]))
    return LoginView()
        .environment(sessionStore)
        .environment(serverStore)
        .task { await serverStore.load() }
}
