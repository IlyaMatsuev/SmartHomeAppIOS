struct Page<Item: Codable & Hashable & Sendable>: Codable, Hashable, Sendable {
    let items: [Item]
    let page: Int
    let pageSize: Int
    let totalPages: Int
    let totalItems: Int
}
