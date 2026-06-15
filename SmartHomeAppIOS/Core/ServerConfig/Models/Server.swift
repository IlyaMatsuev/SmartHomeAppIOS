import Foundation

struct Server: Codable, Equatable, Sendable, Identifiable {
    var label: String
    var scheme: AddressScheme
    var address: String
    var remote: Bool

    var id: String {
        address
    }

    var fullURL: String {
        "\(scheme)://\(address)"
    }

    var baseURL: URL? {
        guard !address.isEmpty else { return nil }
        guard let components = URLComponents(string: fullURL), components.host?.isEmpty == false else {
            return nil
        }
        return components.url
    }

    var valid: Bool {
        !label.isEmpty && baseURL != nil
    }

    var iconSystemName: String {
        remote ? "globe" : "house"
    }

    init(_ scheme: AddressScheme, _ address: String, remote: Bool = false, label: String = "") {
        self.scheme = scheme
        self.address = address.trimmingCharacters(in: .whitespacesAndNewlines)
        self.remote = remote
        self.label = label.isEmpty ? address : label
    }
}
