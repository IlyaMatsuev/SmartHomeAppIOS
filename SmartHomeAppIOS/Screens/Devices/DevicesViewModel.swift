import Foundation
import Observation

struct DeviceRoomGroup: Identifiable, Hashable {
    let room: DeviceRoom
    let devices: [Device]

    var id: String { room.rawValue }
    var title: String { room.label }
}

@Observable
@MainActor
final class DevicesViewModel {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    var selectedRoom: DeviceRoomFilter
    private(set) var state: LoadState = .idle
    // TODO: Maybe just store them as Dictionary with rooms as keys?
    private(set) var roomGroups: [DeviceRoomGroup] = []

    private let service: DeviceService

    var availableRooms: [DeviceRoom] {
        roomGroups.map(\.room)
    }

    var visibleRoomGroups: [DeviceRoomGroup] {
        switch selectedRoom {
        case .all:
            roomGroups

        case .specific(let room):
            roomGroups.filter { $0.room == room }
        }
    }

    init(service: DeviceService, selectedRoom: DeviceRoomFilter = .all) {
        self.service = service
        self.selectedRoom = selectedRoom
    }

    func load() async {
        state = .loading
        do {
            // TODO: Need to query all devices, or implement lazy loading or something
            let devicesPage = try await service.fetchDevices()
            roomGroups = Self.group(devicesPage.items)
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    private static func group(_ devices: [Device]) -> [DeviceRoomGroup] {
        let grouped = Dictionary(grouping: devices, by: { $0.room })
        return grouped
            .map { DeviceRoomGroup(room: $0, devices: $1.sorted()) }
            .sorted(using: KeyPathComparator(\.room))
    }
}
