import Foundation
import Testing
@testable import SmartHomeAppIOS

struct HubAPIErrorTests {
    @Test
    func noServerSelectedDescribesMissingConfiguration() {
        let description = HubAPIError.noServerSelected.errorDescription
        #expect(description == "No server is selected. Setup a server first.")
    }

    @Test
    func transportDescribesNetworkFailure() {
        let description = HubAPIError.transport.errorDescription
        #expect(description == "Cannot reach the server. Are you connected to the same network?")
    }

    @Test
    func decodingIncludesUnderlyingMessage() {
        let description = HubAPIError.decoding("missing key").errorDescription
        #expect(description == "Failed to decode the server response: missing key")
    }

    @Test
    func unauthorizedDescribesAuthFailure() {
        let description = HubAPIError.unauthorized.errorDescription
        #expect(description == "The request was not authorized.")
    }

    @Test
    func httpWithBodyIncludesStatusAndBody() {
        let description = HubAPIError.http(status: 500, body: "boom").errorDescription
        #expect(description == "Server returned 500: boom")
    }

    @Test
    func httpWithoutBodyIncludesStatusOnly() {
        let description = HubAPIError.http(status: 404, body: nil).errorDescription
        #expect(description == "Server returned 404")
    }
}
