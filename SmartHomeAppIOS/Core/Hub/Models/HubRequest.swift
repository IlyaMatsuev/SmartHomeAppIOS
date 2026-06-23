import Foundation

struct HubRequest: Sendable {
    enum Method: String, Sendable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    let method: Method
    let path: String
    let query: [String: String]
    let body: Data?
    let protected: Bool
}

extension HubRequest {
    static func get(_ path: String, _ query: [String: String] = [:], protected: Bool = true) -> Self {
        .init(method: .get, path: path, query: query, body: nil, protected: protected)
    }

    static func delete(_ path: String, _ query: [String: String] = [:], protected: Bool = true) -> Self {
        .init(method: .delete, path: path, query: query, body: nil, protected: protected)
    }

    static func post(_ path: String, _ body: some Encodable, protected: Bool = true) throws -> Self {
        .init(method: .post, path: path, query: [:], body: try JSONEncoder().encode(body), protected: protected)
    }

    static func put(_ path: String, _ body: some Encodable, protected: Bool = true) throws -> Self {
        .init(method: .put, path: path, query: [:], body: try JSONEncoder().encode(body), protected: protected)
    }
}
