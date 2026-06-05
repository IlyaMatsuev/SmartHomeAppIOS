import XCTest

final class SmartHomeAppIOSUITestsLaunchTests: XCTestCase {
    @MainActor
    func testLaunch() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
