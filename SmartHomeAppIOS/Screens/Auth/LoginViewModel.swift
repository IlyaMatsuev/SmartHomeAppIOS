import Foundation
import Observation

@Observable
@MainActor
final class LoginViewModel {
    private static let emailRegex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/

    private let sessionStore: SessionStore

    private(set) var loading = false
    private(set) var errorMessage: String?

    var email: String = "" {
        didSet { errorMessage = nil }
    }
    var password: String = "" {
        didSet { errorMessage = nil }
    }

    var isEmailValid: Bool {
        !email.isEmpty && (try? Self.emailRegex.wholeMatch(in: email)) != nil
    }

    var isPasswordValid: Bool {
        !password.isEmpty
    }

    var showEmailError: Bool {
        !email.isEmpty && !isEmailValid
    }

    var canSubmit: Bool {
        !loading && isEmailValid && isPasswordValid
    }

    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }

    func submit() async {
        guard canSubmit else { return }

        loading = true
        errorMessage = nil
        do {
            try await sessionStore.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        loading = false
    }
}
