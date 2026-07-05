import Foundation
import AnyCodable

struct HubDeviceService: DeviceService {
    private struct UpdateControlRequest: Encodable {
        let controls: [String: AnyCodable]?
    }

    private let client: MyHomeAPIClient

    init(client: MyHomeAPIClient) {
        self.client = client
    }

    // TODO: Need to figure out how to handle pagination
    // TODO: Handle errors (401, 500)
    func fetchDevices() async throws -> Page<Device> {
        let request = HubRequest.get("/devices", ["pageSize": "20"])
        let response: Page<Device> = try await client.send(request)
        return response
    }

    // TODO: Handle errors: 400, 401, 404, 500
    func updateControl(deviceId: String, controlType: DeviceControlType) async throws -> Device {
        let body = UpdateControlRequest(controls: [controlType.key: controlType.value])
        let request = try HubRequest.put("/devices/\(deviceId)", body)
        let response: Device = try await client.send(request)
        return response
    }
}
