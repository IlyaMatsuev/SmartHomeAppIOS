import SwiftUI

@main
struct SmartHomeAppIOSApp: App {
    private var sessionStore = SessionStore(service: MockAuthService(), tokenStore: KeychainTokenStore())

    var body: some Scene {
        WindowGroup {
            RootView().environment(sessionStore)
        }
    }
}
