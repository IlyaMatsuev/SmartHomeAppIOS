import Foundation
import Testing
@testable import SmartHomeAppIOS

@Suite(.serialized)
struct LiveHubAPIClientTests {
    private struct SamplePayload: Codable, Equatable {
        let name: String
    }

    private static let server = Server(.http, "hub.local:8080", label: "Test Hub")
    private static let token = AuthToken.fixture(accessToken: "test-token")

    private static func makeClient(
        server: Server? = LiveHubAPIClientTests.server,
        token: AuthToken? = LiveHubAPIClientTests.token,
        handler: @escaping TestURLProtocol.Handler
    ) -> LiveHubAPIClient {
        LiveHubAPIClient(
            session: .testSession(handler: handler),
            currentServer: { server },
            currentToken: { token }
        )
    }

    private static func okResponse(for request: URLRequest, body: Data = Data()) -> (HTTPURLResponse, Data) {
        let url = request.url ?? URL(fileURLWithPath: "/")
        // swiftlint:disable:next force_unwrapping
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        return (response, body)
    }

    private static func response(
        for request: URLRequest,
        status: Int,
        body: Data = Data()
    ) -> (HTTPURLResponse, Data) {
        let url = request.url ?? URL(fileURLWithPath: "/")
        // swiftlint:disable:next force_unwrapping
        let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: nil)!
        return (response, body)
    }

    // MARK: - server lookup

    @Test
    func sendThrowsNoServerSelectedWhenServerProviderReturnsNil() async {
        let client = Self.makeClient(server: nil) { _ in (HTTPURLResponse(), Data()) }

        await #expect(throws: HubAPIError.noServerSelected) {
            let _: SamplePayload = try await client.send(.get("/devices"))
        }
    }

    // MARK: - request shape

    @Test
    func sendBuildsURLFromServerBaseAndRequestURI() async throws {
        let captured = CapturedRequest()
        let client = Self.makeClient { request in
            captured.value = request
            return Self.okResponse(for: request, body: try Self.encode(SamplePayload(name: "x")))
        }

        let _: SamplePayload = try await client.send(.get("/devices/42"))

        let request = try #require(captured.value)
        #expect(request.url?.absoluteString == "http://hub.local:8080/devices/42")
        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test
    func sendAttachesJSONBodyAndContentTypeOnPost() async throws {
        let captured = CapturedRequest()
        let client = Self.makeClient { request in
            captured.value = request
            return Self.okResponse(for: request, body: try Self.encode(SamplePayload(name: "x")))
        }

        let payload = SamplePayload(name: "lamp")
        let _: SamplePayload = try await client.send(try .post("/devices", payload))

        let request = try #require(captured.value)
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let body = try #require(request.bodyData)
        let decoded = try JSONDecoder().decode(SamplePayload.self, from: body)
        #expect(decoded == payload)
    }

    @Test
    func sendAttachesBearerTokenOnProtectedRequest() async throws {
        let captured = CapturedRequest()
        let client = Self.makeClient { request in
            captured.value = request
            return Self.okResponse(for: request, body: try Self.encode(SamplePayload(name: "x")))
        }

        let _: SamplePayload = try await client.send(.get("/devices"))

        let request = try #require(captured.value)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
    }

    @Test
    func sendOmitsBearerTokenOnUnprotectedRequest() async throws {
        let captured = CapturedRequest()
        let client = Self.makeClient { request in
            captured.value = request
            return Self.okResponse(for: request, body: try Self.encode(SamplePayload(name: "x")))
        }

        let _: SamplePayload = try await client.send(.get("/health", protected: false))

        let request = try #require(captured.value)
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
    }

    @Test
    func sendOmitsBearerTokenWhenNoTokenAvailable() async throws {
        let captured = CapturedRequest()
        let client = Self.makeClient(token: nil) { request in
            captured.value = request
            return Self.okResponse(for: request, body: try Self.encode(SamplePayload(name: "x")))
        }

        let _: SamplePayload = try await client.send(.get("/devices"))

        let request = try #require(captured.value)
        #expect(request.value(forHTTPHeaderField: "Authorization") == nil)
    }

    // MARK: - decoding

    @Test
    func sendReturnsDecodedResponseBody() async throws {
        let expected = SamplePayload(name: "kitchen")
        let client = Self.makeClient { request in
            Self.okResponse(for: request, body: try Self.encode(expected))
        }

        let result: SamplePayload = try await client.send(.get("/rooms/kitchen"))

        #expect(result == expected)
    }

    @Test
    func sendThrowsDecodingOnMalformedJSON() async {
        let client = Self.makeClient { request in
            Self.okResponse(for: request, body: Data("not-json".utf8))
        }

        await #expect(throws: HubAPIError.self) {
            let _: SamplePayload = try await client.send(.get("/devices"))
        }
    }

    @Test
    func voidSendIgnoresEmptyResponseBody() async throws {
        let client = Self.makeClient { request in
            (Self.response(for: request, status: 204).0, Data())
        }

        try await client.send(.delete("/devices/42"))
    }

    // MARK: - status code mapping

    @Test
    func send401ThrowsUnauthorized() async {
        let client = Self.makeClient { request in
            Self.response(for: request, status: 401)
        }

        await #expect(throws: HubAPIError.unauthorized) {
            let _: SamplePayload = try await client.send(.get("/devices"))
        }
    }

    @Test
    func sendNon2xxThrowsHttpWithStatusAndBody() async throws {
        let client = Self.makeClient { request in
            Self.response(for: request, status: 500, body: Data("boom".utf8))
        }

        do {
            let _: SamplePayload = try await client.send(.get("/devices"))
            Issue.record("expected throw")
        } catch let error as HubAPIError {
            #expect(error == .http(status: 500, body: "boom"))
        }
    }

    // MARK: - transport errors

    @Test
    func sendWrapsURLSessionFailureInTransport() async {
        let client = Self.makeClient { _ in
            throw URLError(.notConnectedToInternet)
        }

        await #expect(throws: HubAPIError.transport) {
            let _: SamplePayload = try await client.send(.get("/devices"))
        }
    }

    // MARK: - helpers

    private static func encode<T: Encodable>(_ value: T) throws -> Data {
        try JSONEncoder().encode(value)
    }
}

private final class CapturedRequest: @unchecked Sendable {
    var value: URLRequest?
}

private extension URLRequest {
    /// `URLProtocol` receives the request before `httpBody` is set on the wrapper but exposes the
    /// body via `httpBodyStream`. Drain it so tests can decode the payload that actually went out.
    var bodyData: Data? {
        if let body = httpBody { return body }
        guard let stream = httpBodyStream else { return nil }
        stream.open()
        defer { stream.close() }
        var data = Data()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        while stream.hasBytesAvailable {
            let read = stream.read(buffer, maxLength: bufferSize)
            if read <= 0 { break }
            data.append(buffer, count: read)
        }
        return data
    }
}
