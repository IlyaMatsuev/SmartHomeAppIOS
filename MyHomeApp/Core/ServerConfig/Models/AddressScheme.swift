enum AddressScheme: String, Codable, Identifiable, Equatable, CaseIterable {
    case http
    case https

    var id: String { rawValue }
    var label: String { rawValue }
}
