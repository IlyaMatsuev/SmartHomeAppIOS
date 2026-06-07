import Foundation
import AnyCodable
@testable import SmartHomeAppIOS

final class StubDeviceService: DeviceService, @unchecked Sendable {
    private(set) var fetchDevicesResult: Result<Page<Device>, Error> = .success(
        Page(items: [], page: 1, pageSize: 0, totalPages: 1, totalItems: 0)
    )
    var updateControlResult: (String) -> Result<Device, Error> = { deviceId in
        .failure(MockDeviceService.DeviceNotFoundError(deviceId: deviceId))
    }

    private(set) var fetchDevicesCallCount = 0
    private(set) var updateControlCalls: [(deviceId: String, controlType: DeviceControlType)] = []

    func fetchDevices() async throws -> Page<Device> {
        fetchDevicesCallCount += 1
        return try fetchDevicesResult.get()
    }

    func updateControl(deviceId: String, controlType: DeviceControlType) async throws -> Device {
        updateControlCalls.append((deviceId, controlType))
        return try updateControlResult(deviceId).get()
    }

    func setDevices(_ devices: [Device]) {
        fetchDevicesResult = .success(
            Page(
                items: devices,
                page: 1,
                pageSize: devices.count,
                totalPages: 1,
                totalItems: devices.count
            )
        )
    }

    func setDevicesError(_ error: Error) {
        fetchDevicesResult = .failure(error)
    }
}
