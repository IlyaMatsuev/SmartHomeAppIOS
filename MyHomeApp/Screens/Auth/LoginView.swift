import SwiftUI

struct LoginView: View {
    @Environment(SessionStore.self) private var sessionStore
    @Environment(RegistrationStore.self) private var registrationStore
    @State private var viewModel: LoginViewModel?
    @State private var path: [Route] = []

    private enum Route: Hashable {
        case requestAccess
        case requestStatus
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                if let viewModel {
                    LoginForm(
                        viewModel: viewModel,
                        hasPendingRequest: registrationStore.hasPendingRequest,
                        onRequestAccess: { path.append(.requestAccess) },
                        onOpenRequest: { path.append(.requestStatus) }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ServerSwitcherMenu()
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .requestAccess:
                    RegistrationRequestView(onSubmitted: { path = [.requestStatus] })
                case .requestStatus:
                    RegistrationStatusView(onDismiss: { path.removeAll() })
                }
            }
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
    let registrationStore = RegistrationStore(
        service: MockRegistrationService(operationDelay: .zero),
        persistence: InMemoryRegistrationPersistence()
    )
    let server = Server(.http, "hub.local:8080", remote: false, label: "Home")
    let serverStore = ServerConfigStore(persistence: InMemoryServerConfigPersistence(initial: [server]))
    return LoginView()
        .environment(sessionStore)
        .environment(registrationStore)
        .environment(serverStore)
        .task { await serverStore.load() }
}
