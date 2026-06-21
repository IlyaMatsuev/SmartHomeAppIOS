import SwiftUI

struct ServerSetupView: View {
    @Environment(ServerConfigStore.self) private var serverConfigStore
    @State private var viewModel: ServerSetupViewModel?

    var mode: ServerSetupMode = .initialSetup

    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()

            if let viewModel {
                ServerSetupForm(viewModel: viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            if viewModel == nil {
                viewModel = ServerSetupViewModel(mode: mode, store: serverConfigStore)
            }
        }
    }
}

#Preview {
    let store = ServerConfigStore(persistence: InMemoryServerConfigPersistence())
    return ServerSetupView()
        .environment(store)
        .task { await store.load() }
}
