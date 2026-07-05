import Testing
@testable import MyHomeApp

struct DeviceRoomFilterTests {
    // MARK: - label

    @Test
    func labelAllIsAll() {
        #expect(DeviceRoomFilter.all.label == "All")
    }

    @Test
    func labelSpecificMatchesRoomLabel() {
        #expect(DeviceRoomFilter.specific(.kitchen).label == DeviceRoom.kitchen.label)
        #expect(DeviceRoomFilter.specific(.livingRoom).label == DeviceRoom.livingRoom.label)
        #expect(DeviceRoomFilter.specific(.general).label == DeviceRoom.general.label)
    }
}
