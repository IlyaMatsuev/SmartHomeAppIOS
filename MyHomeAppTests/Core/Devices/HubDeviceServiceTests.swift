import Foundation
import AnyCodable
import Testing
@testable import MyHomeApp

struct HubDeviceServiceTests {
    private let client: StubMyHomeAPIClient
    private let service: HubDeviceService

    init() {
        client = StubMyHomeAPIClient()
        service = HubDeviceService(client: client)
    }

    // MARK: - fetchDevices() — request shape

    @Test
    func fetchDevicesSendsGetDevicesAsProtectedRequest() async throws {
        client.response = .data(Self.encodeEmptyPage())

        _ = try await service.fetchDevices()

        #expect(client.sentRequests.count == 1)
        let request = try #require(client.sentRequests.first)
        #expect(request.method == .get)
        #expect(request.path == "/devices")
        #expect(request.query == ["pageSize": "20"])
        #expect(request.protected == true)
        #expect(request.body == nil)
    }

    // MARK: - fetchDevices() — success

    @Test
    func fetchDevicesReturnsDecodedPage() async throws {
        let lamp = Device.fixture(name: "Lamp")
            .inRoom(.livingRoom)
            .build()
        let speaker = Device.fixture(name: "Speaker")
            .inRoom(.livingRoom)
            .build()
        let page = Page(
            items: [lamp, speaker],
            page: 1,
            pageSize: 20,
            totalPages: 1,
            totalItems: 2
        )
        client.response = .data(try Self.encode(page))

        let result = try await service.fetchDevices()

        #expect(result == page)
    }

    // MARK: - fetchDevices() — failure paths

    @Test
    func fetchDevicesPropagatesClientError() async {
        client.response = .error(HubAPIError.unauthorized)

        await #expect(throws: HubAPIError.unauthorized) {
            _ = try await service.fetchDevices()
        }
    }

    @Test
    func fetchDevicesPropagatesDecodingError() async {
        client.response = .data(Data("not-json".utf8))

        await #expect(throws: DecodingError.self) {
            _ = try await service.fetchDevices()
        }
    }

    // MARK: - updateControl() — request shape

    @Test
    func updateControlSendsPutDeviceByIdAsProtectedRequest() async throws {
        let device = Device.fixture(name: "Lamp").build()
        client.response = .data(try Self.encode(device))

        _ = try await service.updateControl(
            deviceId: "device-42",
            controlType: .toggle(key: "on", value: true)
        )

        #expect(client.sentRequests.count == 1)
        let request = try #require(client.sentRequests.first)
        #expect(request.method == .put)
        #expect(request.path == "/devices/device-42")
        #expect(request.protected == true)
    }

    @Test
    func updateControlSerializesControlsBodyAsKeyedDictionary() async throws {
        let device = Device.fixture(name: "Lamp").build()
        client.response = .data(try Self.encode(device))

        _ = try await service.updateControl(
            deviceId: "device-42",
            controlType: .toggle(key: "on", value: true)
        )

        let request = try #require(client.sentRequests.first)
        let body = try #require(request.body)
        let decoded = try JSONDecoder().decode(ControlsPayload.self, from: body)
        #expect(decoded.controls == ["on": AnyCodable(true)])
    }

    @Test
    func updateControlSerializesFalseToggleValue() async throws {
        let device = Device.fixture(name: "Lamp").build()
        client.response = .data(try Self.encode(device))

        _ = try await service.updateControl(
            deviceId: "device-42",
            controlType: .toggle(key: "on", value: false)
        )

        let request = try #require(client.sentRequests.first)
        let body = try #require(request.body)
        let decoded = try JSONDecoder().decode(ControlsPayload.self, from: body)
        #expect(decoded.controls == ["on": AnyCodable(false)])
    }

    // MARK: - updateControl() — success

    @Test
    func updateControlReturnsDecodedDevice() async throws {
        let device = Device.fixture(name: "Lamp")
            .inRoom(.livingRoom)
            .build()
        client.response = .data(try Self.encode(device))

        let result = try await service.updateControl(
            deviceId: device.externalId,
            controlType: .toggle(key: "on", value: true)
        )

        #expect(result == device)
    }

    // MARK: - updateControl() — failure paths

    @Test
    func updateControlPropagatesClientError() async {
        client.response = .error(HubAPIError.unauthorized)

        await #expect(throws: HubAPIError.unauthorized) {
            _ = try await service.updateControl(
                deviceId: "device-42",
                controlType: .toggle(key: "on", value: true)
            )
        }
    }

    @Test
    func updateControlPropagatesDecodingError() async {
        client.response = .data(Data("not-json".utf8))

        await #expect(throws: DecodingError.self) {
            _ = try await service.updateControl(
                deviceId: "device-42",
                controlType: .toggle(key: "on", value: true)
            )
        }
    }

    // MARK: - helpers

    private struct ControlsPayload: Decodable {
        let controls: [String: AnyCodable]
    }

    private static func encode<T: Encodable>(_ value: T) throws -> Data {
        try JSONEncoder().encode(value)
    }

    private static func encodeEmptyPage() -> Data {
        // swiftlint:disable:next force_try
        try! encode(Page<Device>(items: [], page: 1, pageSize: 20, totalPages: 1, totalItems: 0))
    }
}
