import SwiftUI

struct LoginView: View {
    @Environment(SessionStore.self) private var sessionStore
    @State private var viewModel: LoginViewModel?

    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()

            if let viewModel {
                LoginForm(viewModel: viewModel)
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
    return LoginView().environment(sessionStore)
}
