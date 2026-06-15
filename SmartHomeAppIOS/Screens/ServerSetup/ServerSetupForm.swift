import SwiftUI

struct ServerSetupForm: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: ServerSetupViewModel

    var body: some View {
        VStack(spacing: 0) {
            header
            ServerList(viewModel: viewModel)
            footer
        }
        .fullScreenCover(isPresented: $viewModel.isServerFormOpen) {
            AddEditServerSheet(
                viewModel: viewModel,
                mode: viewModel.addingNewServer ? .add : .edit,
                server: $viewModel.draftServer
            )
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Add your Home")
                .font(.largeTitle.bold())
                .foregroundStyle(Color("TextPrimary"))
            Text("Add the addresses where your SmartHome Hub can be reached")
                .font(.subheadline)
                .foregroundStyle(Color("TextSecondary"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 16)
    }

    private var footer: some View {
        VStack(spacing: 12) {
            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(Color("Danger"))
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 12) {
                Button {
                    viewModel.showAddServerForm()
                } label: {
                    Label("Add server", systemImage: "plus")
                        .font(.headline)
                        .foregroundStyle(Color("AccentPrimary"))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color("BackgroundSecondary"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    Task {
                        await viewModel.continueSetup()
                        if viewModel.mode == .edit && viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                } label: {
                    ZStack {
                        Text(viewModel.mode.buttonLabel)
                            .opacity(viewModel.loading ? 0 : 1)
                        if viewModel.loading {
                            ProgressView().tint(.white)
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Color("AccentPrimary"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(viewModel.canContinue ? 1 : 0.5)
                }
                .disabled(!viewModel.canContinue)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}
