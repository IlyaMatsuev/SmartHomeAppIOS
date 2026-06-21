import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidLoginCredentials
    case sessionExpired
    case unexpected

    var errorDescription: String? {
        switch self {
        case .invalidLoginCredentials: "Invalid email or password."
        case .sessionExpired: "Your session has expired. Please log in again."
        case .unexpected: "Something went wrong. Please try again later."
        }
    }
}
