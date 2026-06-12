import SwiftUI

struct ServerSetupView: View {
    @Environment(ServerConfigStore.self) private var serverConfigStore
    @State private var viewModel: ServerSetupViewModel?

    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()

            if let viewModel {
                ServerSetupForm(viewModel: viewModel)
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ServerSetupViewModel(store: serverConfigStore)
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
