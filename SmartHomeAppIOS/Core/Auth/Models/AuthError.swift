import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidLoginCredentials
    case unexpected

    var errorDescription: String? {
        switch self {
        case .invalidLoginCredentials: "Invalid email or password."
        case .unexpected: "Something went wrong. Please try again later."
        }
    }
}
