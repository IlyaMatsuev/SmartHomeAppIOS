import Foundation
import Testing
@testable import MyHomeApp

struct JSONDecoderHubAPITests {
    private struct Wrapper: Decodable {
        let date: Date
    }

    // MARK: - date decoding — success

    @Test
    func decodesISO8601StringWithFractionalSeconds() throws {
        let data = Data(#"{"date":"2025-08-30T16:04:22.289Z"}"#.utf8)

        let decoded = try JSONDecoder.hubAPI.decode(Wrapper.self, from: data)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expected = try #require(formatter.date(from: "2025-08-30T16:04:22.289Z"))
        #expect(decoded.date == expected)
    }

    @Test
    func decodesISO8601StringWithFractionalSecondsAtMillisecondPrecision() throws {
        let data = Data(#"{"date":"2026-06-22T22:00:05.037Z"}"#.utf8)

        let decoded = try JSONDecoder.hubAPI.decode(Wrapper.self, from: data)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expected = try #require(formatter.date(from: "2026-06-22T22:00:05.037Z"))
        #expect(decoded.date.timeIntervalSince1970 == expected.timeIntervalSince1970)
    }

    // MARK: - date decoding — failure paths

    @Test
    func throwsOnNonISO8601String() {
        let data = Data(#"{"date":"not-a-date"}"#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder.hubAPI.decode(Wrapper.self, from: data)
        }
    }

    @Test
    func throwsOnISO8601StringWithoutFractionalSeconds() {
        // The strategy is configured strictly: server is expected to always
        // emit fractional seconds. Document that contract here.
        let data = Data(#"{"date":"2025-08-30T16:04:22Z"}"#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder.hubAPI.decode(Wrapper.self, from: data)
        }
    }

    @Test
    func throwsOnNonStringDateValue() {
        let data = Data(#"{"date":1234567890.0}"#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder.hubAPI.decode(Wrapper.self, from: data)
        }
    }
}
