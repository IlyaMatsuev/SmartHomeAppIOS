import SwiftUI

struct PasswordField: View {
    @Binding var password: String

    var body: some View {
        SecureField("Password", text: $password)
            .textContentType(.password)
            .padding()
            .background(Color("BackgroundSecondary"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
