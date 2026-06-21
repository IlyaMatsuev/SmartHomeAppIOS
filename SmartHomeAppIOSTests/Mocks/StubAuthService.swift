import Foundation
@testable import SmartHomeAppIOS

final class StubAuthService: AuthService, @unchecked Sendable {
    var loginResult: Result<AuthToken, Error> = .success(.fixture())

    private(set) var loginCalls: [(email: String, password: String)] = []

    func login(email: String, password: String) async throws -> AuthToken {
        loginCalls.append((email, password))
        return try loginResult.get()
    }
}
