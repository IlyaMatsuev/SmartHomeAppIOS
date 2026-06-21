import Foundation
import os

struct LiveHubAPIClient: HubAPIClient {
    private static let logger = Logger(subsystem: "SmartHomeApp", category: "LiveHubAPIClient")

    private let session: URLSession
    private let currentServer: @MainActor @Sendable () -> Server?
    private let currentToken: @MainActor @Sendable () -> AuthToken?
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        currentServer: @escaping @MainActor @Sendable () -> Server?,
        currentToken: @escaping @MainActor @Sendable () -> AuthToken?
    ) {
        self.session = session
        self.currentServer = currentServer
        self.currentToken = currentToken
        self.decoder = JSONDecoder()
    }

    func send<T: Decodable & Sendable>(_ request: HubRequest) async throws -> T {
        let data = try await perform(request)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw HubAPIError.decoding(error.localizedDescription)
        }
    }

    func send(_ request: HubRequest) async throws {
        _ = try await perform(request)
    }

    private func perform(_ request: HubRequest) async throws -> Data {
        guard let baseURL = await currentServer()?.baseURL else {
            throw HubAPIError.noServerSelected
        }

        let urlRequest = await createRequest(baseURL, request)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            let reason = error.localizedDescription
            Self.logger.error("Failed to send a request: \(reason)")
            throw HubAPIError.transport
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            Self.logger.error("Failed to send a request: non-HTTP response")
            throw HubAPIError.transport
        }

        return try handleResponse(data, httpResponse)
    }

    private func createRequest(_ baseURL: URL, _ request: HubRequest) async -> URLRequest {
        Self.logger.debug("Sending a request on \(request.method.rawValue) \"\(request.uri)\"")

        var urlRequest = URLRequest(url: baseURL.appending(path: request.uri))
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body = request.body {
            Self.logger.debug("  with a body: \(String(data: body, encoding: .utf8) ?? "<binary>")")

            urlRequest.httpBody = body
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if request.protected, let token = await currentToken() {
            urlRequest.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }

    private func handleResponse(_ data: Data, _ response: HTTPURLResponse) throws -> Data {
        Self.logger.debug("Received a response (\(response.statusCode)) with a body: \(String(data: data, encoding: .utf8) ?? "<binary>")")
        
        switch response.statusCode {
        case 200..<300:
            return data
        case 401:
            throw HubAPIError.unauthorized
        default:
            throw HubAPIError.http(status: response.statusCode, body: String(data: data, encoding: .utf8))
        }
    }
}
