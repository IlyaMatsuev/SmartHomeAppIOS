import SwiftUI

struct EmailField: View {
    @Binding var email: String
    var invalidEmail: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .padding(.top, invalidEmail ? 14 : 0)

            if invalidEmail {
                Text("Invalid email")
                    .font(.caption2)
                    .foregroundStyle(Color("Danger"))
                    .padding(.horizontal, 14)
                    .padding(.top, 6)
                    .transition(.opacity.combined(with: .offset(y: 6)))
            }
        }
        .background(Color("BackgroundSecondary"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(invalidEmail ? Color("Danger") : .clear, lineWidth: 1.5)
        }
        .animation(.spring(duration: 0.25), value: invalidEmail)
    }
}
