import Foundation
import AnyCodable
import Testing
@testable import MyHomeApp

struct DeviceControlTypeTests {
    // MARK: - key / id

    @Test
    func toggleExposesAssociatedKeyAsKeyAndId() {
        let control = DeviceControlType.toggle(key: "on", value: true)

        #expect(control.key == "on")
        #expect(control.id == "on")
    }

    // MARK: - value

    @Test
    func toggleValueWrapsTrueInAnyCodable() {
        let control = DeviceControlType.toggle(key: "on", value: true)

        #expect(control.value == AnyCodable(true))
    }

    @Test
    func toggleValueWrapsFalseInAnyCodable() {
        let control = DeviceControlType.toggle(key: "on", value: false)

        #expect(control.value == AnyCodable(false))
    }
}
