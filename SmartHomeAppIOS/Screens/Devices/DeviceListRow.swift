import SwiftUI

struct DeviceListRow: View {
    let device: Device

    @Environment(DevicesViewModel.self) private var viewModel

    var loading: Bool { viewModel.isLoading(device) }

    var body: some View {
        HStack(spacing: 12) {
            Text(device.type.emoji)
                .font(.title3)
                .foregroundStyle(Color("AccentPrimary"))
                .frame(width: 36, height: 36)
                .background(Color("BackgroundTertiary"))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(device.name)
                    .font(.body)
                    .foregroundStyle(Color("TextPrimary"))

                Text("\(device.type.label) · \(device.brand.label)")
                    .font(.subheadline)
                    .foregroundStyle(Color("TextSecondary"))
            }

            if !device.availableControls.isEmpty {
                Spacer(minLength: 12)
                HStack(spacing: 8) {
                    ForEach(device.availableControls) { control in
                        controlView(for: control)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func controlView(for control: DeviceControlType) -> some View {
        switch control {
        case .toggle(let key, let value):
            HStack(spacing: 6) {
                if loading {
                    ProgressView().controlSize(.small)
                }
                Toggle("", isOn: Binding(
                    get: { value },
                    set: { viewModel.toggle(device, key: key, to: $0) }
                ))
                .labelsHidden()
                .tint(Color("AccentPrimary"))
                .disabled(loading)
            }
        }
    }
}
