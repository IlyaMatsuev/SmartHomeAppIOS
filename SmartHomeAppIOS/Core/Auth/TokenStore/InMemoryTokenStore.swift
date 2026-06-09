import Foundation

final class InMemoryTokenStore: TokenStore, @unchecked Sendable {
    private let lock = NSLock()
    private var token: AuthToken?

    init(token: AuthToken? = nil) {
        self.token = token
    }

    func load() throws -> AuthToken? {
        lock.lock()
        defer { lock.unlock() }
        return token
    }

    func save(_ token: AuthToken) throws {
        lock.lock()
        defer { lock.unlock() }
        self.token = token
    }

    func clear() throws {
        lock.lock()
        defer { lock.unlock() }

        self.token = nil
    }
}
