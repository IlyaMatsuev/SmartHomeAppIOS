import SwiftUI

struct DeviceRoomFilterList: View {
    let availableRooms: [DeviceRoom]
    @Binding var selection: DeviceRoomFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                tile(title: DeviceRoomFilter.all.label, isSelected: selection == .all) {
                    selection = .all
                }

                ForEach(availableRooms, id: \.self) { room in
                    tile(title: room.label, isSelected: selection == .specific(room)) {
                        selection = .specific(room)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .scrollClipDisabled()
    }

    private func tile(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .foregroundStyle(
                    isSelected ? Color("TextPrimary") : Color("TextSecondary")
                )
                .background(
                    Capsule()
                        .fill(isSelected ? Color("AccentPrimary") : Color("BackgroundSecondary"))
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
