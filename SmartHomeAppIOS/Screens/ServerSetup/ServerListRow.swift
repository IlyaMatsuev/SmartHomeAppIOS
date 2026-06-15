import SwiftUI

struct ServerListRow: View {
    let server: Server

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: server.iconSystemName)
                .foregroundStyle(Color("AccentPrimary"))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(server.label)
                    .font(.subheadline.monospaced())
                    .foregroundStyle(Color("TextPrimary"))
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(server.fullURL)
                    .font(.caption)
                    .foregroundStyle(Color("TextSecondary"))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color("TextSecondary"))
        }
        .contentShape(Rectangle())
    }
}
