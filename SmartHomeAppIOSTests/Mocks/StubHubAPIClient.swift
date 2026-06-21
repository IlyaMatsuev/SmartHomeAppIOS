import Foundation
@testable import SmartHomeAppIOS

final class StubHubAPIClient: HubAPIClient, @unchecked Sendable {
    enum Response: Sendable {
        case data(Data)
        case error(Error)
    }

    var response: Response = .data(Data())
    private(set) var sentRequests: [HubRequest] = []

    func send<T: Decodable & Sendable>(_ request: HubRequest) async throws -> T {
        sentRequests.append(request)
        switch response {
        case .data(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .error(let error):
            throw error
        }
    }

    func send(_ request: HubRequest) async throws {
        sentRequests.append(request)
        if case .error(let error) = response {
            throw error
        }
    }
}
