import Foundation
@testable import SmartHomeAppIOS

extension AuthToken {
    static func fixture(
        email: String = "user@example.com",
        externalId: String = "test-external-id",
        accessToken: String = "test-access-token",
        refreshToken: String = "test-refresh-token"
    ) -> AuthToken {
        AuthToken(
            email: email,
            externalId: externalId,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
