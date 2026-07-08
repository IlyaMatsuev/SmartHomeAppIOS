import Foundation
import Observation

@Observable
@MainActor
final class RegistrationRequestViewModel {
    private static let emailRegex = /^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/

    private let registrationStore: RegistrationStore

    private(set) var loading = false
    private(set) var errorMessage: String?

    var email: String = "" {
        didSet { errorMessage = nil }
    }
    var comment: String = "" {
        didSet { errorMessage = nil }
    }

    var isEmailValid: Bool {
        !email.isEmpty && (try? Self.emailRegex.wholeMatch(in: email)) != nil
    }

    var showEmailError: Bool {
        !email.isEmpty && !isEmailValid
    }

    var canSubmit: Bool {
        !loading && isEmailValid
    }

    init(registrationStore: RegistrationStore) {
        self.registrationStore = registrationStore
    }

    @discardableResult
    func submit() async -> Bool {
        guard canSubmit else { return false }

        loading = true
        errorMessage = nil
        defer { loading = false }
        do {
            let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            try await registrationStore.requestAccess(
                email: email,
                comment: trimmedComment.isEmpty ? nil : trimmedComment
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
