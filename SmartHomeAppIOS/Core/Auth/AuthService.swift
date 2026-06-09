import Foundation

protocol AuthService: Sendable {
    func login(email: String, password: String) async throws -> AuthToken
}
