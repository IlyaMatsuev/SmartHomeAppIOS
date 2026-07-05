import Testing
@testable import MyHomeApp

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
