import SwiftUI

struct ServerList: View {
    @Bindable var viewModel: ServerSetupViewModel

    var body: some View {
        if viewModel.servers.isEmpty {
            noServersState
        } else {
            List {
                ForEach(viewModel.servers) { server in
                    Button {
                        viewModel.showEditServerForm(server)
                    } label: {
                        ServerListRow(server: server)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color("BackgroundSecondary"))
                }
                .onDelete(perform: viewModel.removeServer)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
    }

    private var noServersState: some View {
        VStack(spacing: 12) {
            Image(systemName: "server.rack")
                .font(.system(size: 48))
                .foregroundStyle(Color("TextSecondary"))
            Text("No servers added yet")
                .font(.headline)
                .foregroundStyle(Color("TextPrimary"))
            Text("Tap the + button to add the first one")
                .font(.footnote)
                .foregroundStyle(Color("TextSecondary"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }
}
