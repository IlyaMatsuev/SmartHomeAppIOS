struct AuthToken: Codable, Equatable, Sendable {
    let email: String
    let accessToken: String
}
