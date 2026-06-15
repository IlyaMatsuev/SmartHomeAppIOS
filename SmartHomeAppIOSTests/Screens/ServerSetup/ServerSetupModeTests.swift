import Testing
@testable import SmartHomeAppIOS

struct ServerSetupModeTests {
    // MARK: - buttonLabel

    @Test
    func buttonLabelForInitialSetupIsContinue() {
        #expect(ServerSetupMode.initialSetup.buttonLabel == "Continue")
    }

    @Test
    func buttonLabelForEditIsSave() {
        #expect(ServerSetupMode.edit.buttonLabel == "Save")
    }
}
