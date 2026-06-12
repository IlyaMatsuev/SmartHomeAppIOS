import SwiftUI

struct AddEditServerSheet: View {
    @Bindable var viewModel: ServerSetupViewModel
    @Binding var server: Server

    var loading: Bool { viewModel.loading }
    var errorMessage: String? { viewModel.draftErrorMessage }

    let mode: Mode

    enum Mode {
        case add
        case edit

        var title: String {
            switch self {
            case .add: return "Add Server"
            case .edit: return "Edit Server"
            }
        }
    }

    init(viewModel: ServerSetupViewModel, mode: Mode, server: Binding<Server>) {
        self.viewModel = viewModel
        self.mode = mode
        self._server = server
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundPrimary").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        labelField
                        urlField
                        remoteToggle
                        tip
                        errorText
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle(mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.closeServerForm() }
                        .disabled(loading)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if loading {
                        ProgressView()
                    } else {
                        Button("Save") {
                            Task { await viewModel.saveDraft() }
                        }
                        .disabled(!viewModel.canSaveDraft)
                    }
                }
            }
        }
    }

    private var labelField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Label")
                .font(.footnote)
                .foregroundStyle(Color("TextSecondary"))

            HStack(spacing: 0) {
                TextField("My Home", text: $server.label)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 12)
            }
            .frame(minHeight: 48)
            .background(Color("BackgroundSecondary"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var urlField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Server address")
                .font(.footnote)
                .foregroundStyle(Color("TextSecondary"))

            HStack(spacing: 0) {
                schemePicker
                Divider().frame(height: 24)
                TextField("192.168.1.10:8080", text: $server.address)
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 12)
            }
            .frame(minHeight: 48)
            .background(Color("BackgroundSecondary"))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Include the port if your server uses one (e.g. :8080).")
                .font(.caption2)
                .foregroundStyle(Color("TextSecondary"))
        }
    }

    private var schemePicker: some View {
        Menu {
            Picker("Scheme", selection: $server.scheme) {
                ForEach(AddressScheme.allCases) { scheme in
                    Text(scheme.label).tag(scheme)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(server.scheme.label)
                    .font(.subheadline.monospaced())
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .foregroundStyle(Color("TextPrimary"))
            .padding(.horizontal, 14)
            .frame(maxHeight: .infinity)
        }
    }

    private var remoteToggle: some View {
        Toggle(isOn: $server.remote) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Remote server")
                    .foregroundStyle(Color("TextPrimary"))
                Text("Reachable over the internet via a domain name.")
                    .font(.caption)
                    .foregroundStyle(Color("TextSecondary"))
            }
        }
        .tint(Color("AccentPrimary"))
        .padding()
        .background(Color("BackgroundSecondary"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(loading)
    }

    @ViewBuilder
    private var errorText: some View {
        if let message = errorMessage {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(message).font(.footnote)
            }
            .foregroundStyle(Color("Danger"))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var tip: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: server.remote ? "globe" : "wifi")
            Text(tipText).font(.footnote)
        }
        .foregroundStyle(Color("TextSecondary"))
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("BackgroundSecondary"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var tipText: String {
        if server.remote {
            "Make sure the URL is reachable over the internet from outside your home network."
        } else {
            "Make sure your phone is connected to the same Wi-Fi network as the server."
        }
    }
}
