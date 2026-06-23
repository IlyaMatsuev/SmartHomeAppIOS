import Foundation
import AnyCodable

struct Device: Codable, Identifiable, Hashable {
    let externalId: String
    let name: String

    let type: DeviceType
    let brand: DeviceBrand
    let room: DeviceRoom

    let transportProtocol: TransportProtocol
    let ip: String?
    let updateInterval: Int?

    let tuyaDeviceId: String?
    let tuyaDeviceLocalKey: String?

    let zigbeeFriendlyName: String?
    let zigbeeIeeeAddress: String?

    // TODO: Make controls "let"
    // "controls" and "measurements" might come undefined or empty
    // swiftlint:disable:next discouraged_optional_collection
    var controls: [String: AnyCodable]?
    // swiftlint:disable:next discouraged_optional_collection
    let measurements: [String: AnyCodable]?

    var controlsUpdatedAt: Date?
    let measurementsUpdatedAt: Date?
    let createdAt: Date
    let updatedAt: Date

    var id: String { externalId }
}

extension Device: Comparable {
    static func < (lhs: Device, rhs: Device) -> Bool {
        lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

extension Device {
    var availableControls: [DeviceControlType] {
        guard let controls = controls else { return [] }
        return controls
            .compactMap { key, anyCodable -> DeviceControlType? in
                if key == "on", let bool = anyCodable.value as? Bool {
                    return .toggle(key: key, value: bool)
                }
                return nil
            }
    }
}
