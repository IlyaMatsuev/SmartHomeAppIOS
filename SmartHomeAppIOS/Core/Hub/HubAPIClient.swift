import Foundation

protocol HubAPIClient: Sendable {
    func send<T: Decodable & Sendable>(_ request: HubRequest) async throws -> T
    func send(_ request: HubRequest) async throws
}
