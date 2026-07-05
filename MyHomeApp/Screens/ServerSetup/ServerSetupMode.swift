enum ServerSetupMode {
    case initialSetup
    case edit

    var buttonLabel: String {
        switch self {
        case .initialSetup: return "Continue"
        case .edit: return "Save"
        }
    }
}
