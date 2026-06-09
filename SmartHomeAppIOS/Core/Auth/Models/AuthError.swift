import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidLoginCredentials

    var errorDescription: String? {
        switch self {
        case .invalidLoginCredentials: "Invalid email or password."
        }
    }
}
