protocol DeviceService: Sendable {
    func fetchDevices() async throws -> Page<Device>
    func updateControl(deviceId: String, controlType: DeviceControlType) async throws -> Device
}
