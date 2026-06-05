import Foundation
@testable import SmartHomeAppIOS

final class StubDeviceService: DeviceService, @unchecked Sendable {
    private(set) var fetchDevicesResult: Result<Page<Device>, Error> = .success(
        Page(items: [], page: 1, pageSize: 0, totalPages: 1, totalItems: 0)
    )

    private(set) var fetchDevicesCallCount = 0

    func fetchDevices() async throws -> Page<Device> {
        fetchDevicesCallCount += 1
        return try fetchDevicesResult.get()
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
