import Foundation

enum DeviceControlType: Identifiable, Equatable {
    case toggle(key: String, value: Bool)

    var id: String { key }

    var key: String {
        switch self {
        case .toggle(let key, _): return key
        }
    }
}
