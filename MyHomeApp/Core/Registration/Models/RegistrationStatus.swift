import SwiftUI

enum RegistrationStatus: String, Codable, Equatable, Sendable, CaseIterable {
    case pending
    case approved
    case rejected

    var label: String {
        switch self {
        case .pending: "Pending"
        case .approved: "Approved"
        case .rejected: "Rejected"
        }
    }

    var detail: String {
        switch self {
        case .pending: "Your request is waiting for the hub owner to approve it. Swipe down to refresh."
        case .approved: "Your request was approved. You can now register a new account with that email."
        case .rejected: "Your request was rejected. Reach out to the Home admin if you think this was a mistake."
        }
    }

    var icon: String {
        switch self {
        case .pending: "clock.badge.questionmark"
        case .approved: "checkmark.seal.fill"
        case .rejected: "xmark.seal.fill"
        }
    }

    var color: Color {
        switch self {
        case .pending: Color("AccentPrimary")
        case .approved: Color("Success")
        case .rejected: Color("Danger")
        }
    }
}
