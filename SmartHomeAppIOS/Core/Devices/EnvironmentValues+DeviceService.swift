import SwiftUI

extension EnvironmentValues {
    @Entry var deviceService: any DeviceService = MockDeviceService()
}
