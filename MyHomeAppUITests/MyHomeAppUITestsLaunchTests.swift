import XCTest

final class MyHomeAppUITestsLaunchTests: XCTestCase {
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
