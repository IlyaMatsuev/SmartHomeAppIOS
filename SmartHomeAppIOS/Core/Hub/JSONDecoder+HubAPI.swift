import Foundation

extension JSONDecoder {
    static let hubAPI: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .hubAPI
        return decoder
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let hubAPI: Self = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Self.isoFormatter.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ISO-8601 date: \(string)")
        }
        return date
    }

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
