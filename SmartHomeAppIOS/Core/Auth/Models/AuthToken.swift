struct AuthToken: Codable, Equatable, Sendable {
    let email: String
    let externalId: String
    let accessToken: String
    let refreshToken: String
}
